require 'test_helper'

class Api::ShortUrlsControllerTest < ActionDispatch::IntegrationTest
  test 'should post to create and return record with valid params' do
    payload = { long_url: 'https://www.nba.com/celtics', slug: 'letsgoceltics' }
    post api_short_urls_url short_url: payload
    assert_response :success
    body = JSON.parse(response.body)
    assert body['long_url'] == payload[:long_url]
    assert body['slug'] == payload[:slug]
    assert_not body['id'].nil?
  end

  test 'should post to create and error with invalid params' do
    payload = { long_url: 'foo' }
    post api_short_urls_url short_url: payload
    assert_response 422
  end

  test 'should delete to destroy and return record with valid secret' do
    short_url = short_urls :one
    delete api_short_url_url id: short_url.id, secret: short_url.secret
    assert_response :success
    body = JSON.parse(response.body)
    assert body['long_url'] == short_url.long_url
    assert body['slug'] == short_url.slug
  end

  test 'should delete to destroy and return error without valid secret' do
    short_url = short_urls :one
    delete api_short_url_url id: short_url.id, secret: short_url.secret.reverse
    assert_response 401
  end

  test 'should delete to destroy and return error without valid id' do
    short_url = short_urls :one
    delete api_short_url_url id: short_url.id + 200, secret: short_url.secret
    assert_response 404
  end
end
