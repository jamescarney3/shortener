require 'test_helper'

class ShortUrlTest < ActiveSupport::TestCase
  def setup
    @valid_short_url = short_urls :one
  end

  test 'instance should validate with valid attributes' do
    assert @valid_short_url.valid?
  end

  test 'instance should not validate without long_url property' do
    no_long_url = ShortUrl.new(slug: 'foo')
    assert_not no_long_url.valid?
  end

  # has to be a web url with protocol included for redirect to work in controller
  test 'instance should not validate with invalid long_url' do
    no_protocol_url = ShortUrl.new(long_url: 'www.nba.com/celtics/')
    assert_not no_protocol_url.valid?

    empty_url = ShortUrl.new(long_url: '')
    assert_not empty_url.valid?
  end

  test 'instance should not validate with duplicate slug' do
    duplicate_slug = ShortUrl.new(slug: @valid_short_url.slug, long_url: 'https://www.nba.com/celtics/')
    assert_not duplicate_slug.valid?
  end

  test 'instance should not validate with non-alphanumeric slug' do
    special_char_slug = ShortUrl.new(slug: 'abc$$//12344', long_url: 'https://www.nba.com/celtics/')
    assert_not special_char_slug.valid?
  end

  test 'instance should enforce slug length constraints' do
    slug_length = ShortUrl.new(slug: 'abcdef', long_url: 'https://www.nba.com/celtics/')
    assert slug_length.valid?
    slug_length.slug = 'abcde'
    assert_not slug_length.valid?
    slug_length.slug = 'abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijx'
    assert_not slug_length.valid?
  end

  test 'initializes with generated slug ivar if not passed in constructor' do
    generated_slug = ShortUrl.new(long_url: 'https://www.nba.com/celtics/')
    assert_not generated_slug.slug.nil?
  end
end
