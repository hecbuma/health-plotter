class ResultSheetsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user

  def index
    @result_sheets = @user.result_sheets
  end

  def new
    @result_sheet = ResultSheet.new
  end

  def create
    @result_sheet = ResultSheet.new(result_sheet_params)

    if @result_sheet.save
      flash[:notice] = 'Result Sheet was succesfully create'
      render :show
    else
      flash.now[:alert] = 'Please check the inputs'
      render :new
    end
  end
  
  def show
    @result_sheet = ResultSheet.find(result_sheet_params)
  end

  def destroy
    @result_sheet = ResultSheet.find(params[:id])

    if @result_sheet.destroy
      flash[:notice] = 'Sheet was succesfully deleted'
    else
      flash[:alert] = 'Error to delete sheet'
    end
    redirect_to result_sheets_path
  end

  private
  def result_sheet_params
    params.require(:result_sheet)
      .permit(:doctor, :date, :document).merge(user_id: @user.id)
  end

  def load_user
    @user = current_user
  end
end
