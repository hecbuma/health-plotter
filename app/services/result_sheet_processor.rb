# frozen_string_literal: true

UNITS_PATTERNS = /x10\^6\/uL|g\/dL|\%|fL|pg|x10\^3\/µL|UI\/L|mg\/d|U\/L|mmol\/L|ml|ml\/min|kg|mts|mts2|ml\/mi\/1.73|mg\/kg\/dia|mg\/24h|POR CAMPO|pH|U.E.\/dl|NEGATIVO|POSITIVO|\+/
LINE_EXCLUTION = /En el limite de nivel|Conveniente|para diabetes|Conveniente:|Elevado:|\d/
TESTS_PATTERNS = /albumina-en-suero|biometria-hematica|quimica-clinica|proteinas-en-orina-de-24-horas|inmologia|quimica-de-\d-elementos/
METAS_PATTERNS = /paciente|sexo|fecha|dirigido|doctor/i

class ResultSheetProcessor
  def self.parse_file_later(result_sheet)
    ResultSheetProcessorJob.perform_later(result_sheet.id)
  end

  def self.parse_file(result_sheet)
    lines = separate_in_lines(download_file(result_sheet))

    build_studies_values_hash(lines).each do |study|
      result_sheet.studies.create study
    end

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

    lines = {study_lines: [], metadata_lines: []}
    File.open(file, "rb") do |io|
      reader = PDF::Reader.new(io)
      test = ''
      reader.pages.each do |page|
        page.text.split("\n").each do |line|
          if line.parameterize.match(TESTS_PATTERNS)
           test = line.parameterize
          end
          if line.match(UNITS_PATTERNS)
            lines[:study_lines] << test + "  " +line.strip
          end
          if line.match(METAS_PATTERNS)
            lines[:metadata_lines] << line
          end
        end
      end
    end

    lines
  end

  def self.build_studies_values_hash(lines)
    values_hash = lines[:study_lines].each_with_object([]) do |line, result|
      parts = line.strip.split(/\s\s/).reject{|a| a.empty? }
      next if parts[1].nil?
      next if parts[1].match(LINE_EXCLUTION)
      result << {name: parts[1], result: parts[2], unit: parts[3], range: parts[4], group: parts[0]}
    end
  end

  # TODO: Get metadata hash
  def self.build_metadata_values_hash(lines)
    metadata_lines = lines[:metadata_lines].each_with_object([]) do |meta, result|
      lines << meta.split(/\s\s\s\s\s\s\s\s\s/)
    end

    metas = metadata_lines.flatten.reject { |c| c.empty? }.each_with_object([]) do |meta, result|
      parts = metas.strip.split(/:\s|\s:\s/).reject{|a| a.empty? }
      result << meta
    end

    hash = {}
    metas.each do |key, value|
      key = key.parameterize
      if key.match(/paciente|sexo|edad|fecha/)
        hash.merge!("#{key}": value)
      end
    end

    hash
  end

  def self.notify_user(result_sheet)
    NotificationMailer.with(result_sheet: result_sheet).results_ready.deliver_later
  end
end
