# frozen_string_literal: true

class StudiesController < ApplicationController
  def index
    if params[:study_group]
      @studies = []
      current_user.studies.each do |study|
        @studies += [study] if study.group == params[:study_group]
      end
    end
    @studies
  end

  def edit
    @study = Study.find(params[:id])
  end

  def update
    @study = Study.find(params[:id])
    if @study.update(study_params)
      redirect_to result_sheet_path(@study.result_sheet_id), notice: 'Study was successfully updated.'
    else
      flash.now[:alert] = 'Study not updated'
      render :edit
    end
  end

  def destroy
    @study = Study.find(params[:id])
    if @study.destroy
      redirect_to result_sheet_path(@study.result_sheet_id), notice: 'Study was successfully deleted.'
    else
      flash.now[:alert] = 'Study not deleted'
    end
  end

  private

  def study_params
    params.require(:study).permit(:name, :result, :unit, :result_sheet_id)
  end
end
