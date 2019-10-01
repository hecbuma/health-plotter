# frozen_string_literal: true

class StudiesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    if params[:study_group]
      @studies = current_user.studies.by_group(params[:study_group])
    elsif params[:study_name]
      @studies = current_user.studies.by_name(params[:study_name])
    elsif params[:search].present? && params[:search][:search] != ''
      @studies = current_user.studies.search_by_name(params[:search][:search])
    end
  end

  def edit
    @study = current_user.studies.find(params[:id])
  end

  def update
    @study = current_user.studies.find(params[:id])
    if @study.update(study_params)
      redirect_to result_sheet_path(@study.result_sheet_id), notice: 'Study was successfully updated.'
    else
      flash.now[:alert] = 'Study not updated'
      render :edit
    end
  end

  def destroy
    @study = current_user.studies.find(params[:id])
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
