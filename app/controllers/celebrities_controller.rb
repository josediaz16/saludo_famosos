class CelebritiesController < ApplicationController
  skip_before_action :authenticate, only: [:index]

  def index
    render json: search_celebrities
  end

  private

  def search_celebrities
    Celebrities::Search.(params[:query], params.permit(:page, :per_page).to_h, &add_celebrity_path)
  end

  def add_celebrity_path
    -> result { result.merge detail_path: celebrity_path(result["id"]) }
  end

end
