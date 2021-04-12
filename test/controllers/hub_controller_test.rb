require 'test_helper'

class HubControllerTest < ActionDispatch::IntegrationTest
  test 'should get and redirect with valid slug' do
    short_url = short_urls :one
    get hub_redirect_url slug: short_url.slug
    assert_redirected_to short_url.long_url
  end

  test 'should get and error without valid slug' do
    short_url = short_urls :one
    get hub_redirect_url slug: short_url.slug.reverse
    assert_response :not_found
  end
end
