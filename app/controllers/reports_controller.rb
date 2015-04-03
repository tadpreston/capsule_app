class ReportsController < ApplicationController
  def registrations
    @users = UserReport.registrations params[:start_date]
    respond_to do |format|
      format.csv { render text: @users.to_csv }
    end
  end
end
