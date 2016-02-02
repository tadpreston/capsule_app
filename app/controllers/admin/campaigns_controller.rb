class Admin::CampaignsController < Admin::ApplicationController
  before_action :find_client
  before_action :find_campaign, only: [:show, :update, :destroy]

  def index
    render json: @client.campaigns, each_serializer: Admin::CampaignSerializer
  end

  def show
    render json: @campaign, serializer: Admin::CampaignSerializer
  end

  private

  def find_client
    @client = Client.find params[:client_id]
  end

  def find_campaign
    @campaign = @client.campaigns.find params[:id]
  end
end
