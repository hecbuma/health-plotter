# frozen_string_literal: true

UNITS_PATTERNS = %r{x10\^6/uL|g/dL|\%|fL|pg|x10\^3/µL|UI/L|mg/d|U/L|mmol/L|ml|ml/min|kg|mts|mts2|ml/mi/1.73|mg/kg/dia|mg/24h|POR CAMPO|pH|U.E./dl|NEGATIVO|POSITIVO|\+}.freeze
LINE_EXCLUTION = /En el limite de nivel|Conveniente|para diabetes|Conveniente:|Elevado:|\d/.freeze
TESTS_PATTERNS = /albumina-en-suero|biometria-hematica|quimica-clinica|proteinas-en-orina-de-24-horas|inmologia|quimica-de-\d-elementos/.freeze
METAS_PATTERNS = /paciente|sexo|fecha|dirigido|doctor/i.freeze
META_PATTERN_WHITELIST = /^paciente$|sexo|edad|fecha$|diagnostico-presuntivo|fecha-y-hora-de-registro|doctor|dirigido-a/
RESULT_SHEET_ATTRS = {paciente: :patient,
                      'diagnostico-presuntivo': :diagnosis,
                      edad: :age,
                      doctor: :doctor,
                      sexo: :sex,
                      'fecha-y-hora-de-registro': :date,
                      fecha: :date,
                      'dirigido-a': :doctor}

class ResultSheetProcessor
  def self.parse_file_later(result_sheet)
    ResultSheetProcessorJob.perform_later(result_sheet.id)
  end

  def self.parse_file(result_sheet)
    lines = separate_in_lines(download_file(result_sheet))

    build_studies_values_hash(lines).each do |study|
      result_sheet.studies.create study
    end

    result_sheet.update build_metadata_values_hash(lines)

    notify_user(result_sheet)
  end

  def self.download_file(result_sheet)
    tmp_file = "tmp/#{SecureRandom.uuid}.pdf"

    File.open(tmp_file, 'wb') do |file|
      file.write(result_sheet.document.download)
    end

    tmp_file
  end

  def self.separate_in_lines(file)
    lines = { study_lines: [], metadata_lines: [] }
    File.open(file, 'rb') do |io|
      reader = PDF::Reader.new(io)
      test = ''
      reader.pages.each do |page|
        page.text.split("\n").each do |line|
          test = line.parameterize if line.parameterize.match(TESTS_PATTERNS)
          lines[:study_lines] << test + '  ' + line.strip if line.match(UNITS_PATTERNS)
          lines[:metadata_lines] << line if line.match(METAS_PATTERNS)
        end
      end
    end

    lines
  end

  def self.build_studies_values_hash(lines)
    values_hash = lines[:study_lines].each_with_object([]) do |line, result|
      parts = line.strip.split(/\s\s/).reject(&:empty?)
      next if parts[1].nil? || parts[1].match(LINE_EXCLUTION)

      result << { name: parts[1], result: parts[2], unit: parts[3], range: parts[4], group: parts[0] }
    end
  end

  def self.build_metadata_values_hash(lines)
    metadata_lines = lines[:metadata_lines].each_with_object([]) do |meta, result|
      result << meta.split(/\s\s\s\s\s\s\s\s\s/)
    end

    metas = metadata_lines.flatten.reject(&:empty?).each_with_object([]) do |meta, result|
      parts = meta.strip.split(/:\s|\s:\s/).reject(&:empty?)
      result << parts
    end

    hash = metas.each_with_object({}) do |(key, value), result|
      key = key.parameterize
      if key.match(META_PATTERN_WHITELIST)
        key = RESULT_SHEET_ATTRS[key.to_sym]
        next if result.keys.include?(key) || key.blank? || value.blank?
        value = value&.strip&.scan(/\d*/)[0] if key == :age
        result.merge!("#{key}": value&.strip&.downcase)
      end
    end
  end

  def self.notify_user(result_sheet)
    NotificationMailer.with(result_sheet: result_sheet).results_ready.deliver_later
  end
end
