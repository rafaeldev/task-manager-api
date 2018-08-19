class Api::V1::TasksController < ApplicationController
  before_action :authenticate_with_token!

  def index
    render json: { tasks: current_user.tasks, status: 200 }
  end

end
