class ApplicationController < ActionController::Base
  def general_studies(sheets)
    result = []
    sheets.each do |sheet|
      result += sheet.studies
    end
    result
  end
end
