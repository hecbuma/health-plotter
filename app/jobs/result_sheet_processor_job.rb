# frozen_string_literal: true

class ResultSheetProcessorJob < ApplicationJob
  queue_as :default

  def perform(result_sheet_id)
    result_sheet = ResultSheet.find(result_sheet_id)
    ResultSheetProcessor.parse_file(result_sheet)
  end
end
