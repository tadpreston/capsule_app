class Admin::CampaignsController < Admin::ApplicationController
  before_action :find_client
  before_action :find_campaign, only: [:show, :update, :destroy]

  def index
    render json: @client.campaigns, each_serializer: Admin::CampaignSerializer
  end

  def show
    render json: @campaign, serializer: Admin::CampaignSerializer
  end

  def create
    campaign = Campaign.new client_params.merge(created_by: current_user.id, updated_by: current_user.id)
    if campaign.save
      render json: campaign, serializer: Admin::CampaignSerializer, status: 201
    else
      render_campaign_errors
    end
  end

  private

  def find_client
    @client = Client.find params[:client_id]
  end

  def find_campaign
    @campaign = @client.campaigns.find params[:id]
  end

  def campaign_params
    params.required(:campaign).permit :name, :description, :budget, :client_message, :user_message, :image_from_client, :image_from_user,
                                      :image_keep, :image_forward, :image_expired
  end

  def render_campaign_errors
    render status: 400, json: {
      errors: [
        status: '400',
        code: '400',
        title: @client.errors,
        links: [],
        path: request.env['REQUEST_PATH']
      ]
    }
  end
end
