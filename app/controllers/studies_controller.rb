class StudiesController < ApplicationController
  def index
    if params[:study_name]
      @studies = []
      general_studies(current_user.result_sheets).each do |study|
        @studies += [study] if study.name == params[:study_name]
      end
    end
    @studies 
  end

  private
  def study_params
    params.require(:study).permit(:name, :result, :unit, :result_sheet_id)
  end
end
