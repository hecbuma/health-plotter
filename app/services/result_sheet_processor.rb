# frozen_string_literal: true

UNITS_PATTERNS = /x10\^6\/uL|g\/dL|\%|fL|pg|x10\^3\/µL|UI\/L|mg\/d|U\/L|mmol\/L|ml|ml\/min|kg|mts|mts2|ml\/mi\/1.73|mg\/kg\/dia|mg\/24h|POR CAMPO|pH|U.E.\/dl|NEGATIVO|POSITIVO|\+/
LINE_EXCLUTION = /En el limite de nivel|Conveniente|para diabetes|Conveniente:|Elevado:|\d/

class ResultSheetProcessor
  def self.parse_file_later(result_sheet)
    ResultSheetProcessorJob.perform_later(result_sheet.id)
  end

  def self.parse_file(result_sheet)
    lines = separate_in_lines(download_file(result_sheet))

    build_values_hash(lines).each do |study|
      result_sheet.studies.create study
    end
  end

  def self.download_file(result_sheet)
    tmp_file = "tmp/#{SecureRandom.uuid}.pdf"

    File.open(tmp_file, 'wb') do |file|
       file.write(result_sheet.document.download)
    end

    tmp_file
  end

  def self.separate_in_lines(file)
    lines = []
    File.open(file, "rb") do |io|
      reader = PDF::Reader.new(io)
      reader.pages.each do |page|
        page.text.split("\n").each do |line|
          if line.match(UNITS_PATTERNS)
            lines << line.strip
          end
        end
      end
    end

    lines
  end

  def self.build_values_hash(lines)
    values_hash = lines.each_with_object([]) do |line, result|
      parts = line.strip.split(/\s\s/).reject{|a| a.empty? }
      next if parts[0].match(LINE_EXCLUTION)
      result << {name: parts[0], result: parts[1], unit: parts[2], range: parts[3]}
    end
  end
end
