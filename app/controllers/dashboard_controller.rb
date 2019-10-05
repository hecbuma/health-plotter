# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @general_studies = current_user.studies
    return unless params[:search].present? && params[:search][:search] != ''

    @general_studies = current_user.studies.search_by_group(params[:search][:search])
  end
end
