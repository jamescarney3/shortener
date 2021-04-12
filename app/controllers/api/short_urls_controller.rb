class Api::ShortUrlsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    short_url = ShortUrl.new(short_url_params)

    if short_url.save
      # for entities with more granular attributes I'd write a separate view
      # layer, but I'm okay with JSON serializing the model here since the
      # project only includes a single API resource with only 2 methods
      render json: short_url, status: 200
    else
      render json: { errors: 'unprocessable entity' }, status: 422
    end
  end

  def destroy
    short_url = ShortUrl.find_by_id params[:id]
    if short_url.nil?
      render json: { errors: 'entity not found' }, status: 404
    elsif short_url.secret != params[:secret]
      render json: { errors: 'invalid secret' }, status: 401
    elsif short_url.destroy
      # see notes above
      render json: short_url, status: 200
    else
      render json: { errors: 'bad request' }, status: 400
    end
  end

  private

  def short_url_params
    params.require(:short_url).permit :long_url, :slug
  end
end
