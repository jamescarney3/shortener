class HubController < ApplicationController
  # this is where we redirect a client that requests a slug url; look up whether
  # we a short url instance with the slug and redirect if we do, otherwise return
  # some error text.
  def redirect
    short_url = ShortUrl.find_by slug: params[:slug]
    if not short_url.nil?
      redirect_to short_url.long_url
    else
      render plain: 'no valid link with slug \'' + params[:slug] + '\' found', status: 404
    end
  end
end
