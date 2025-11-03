class Api::Users::ConsumptionsController < ApplicationController
  throw_json_response_on_unauthenticated_access
  before_action :set_user, only: [ :index ]

  def index
    @consumptions = @user.consumptions
    render formats: :json
  end

  private

  def set_user
    if Current.user == User.find(params[:user_id])
      @user = Current.user
    else
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
