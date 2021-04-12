require 'uri'

class ShortUrl < ApplicationRecord
  include ActiveModel::Validations

  # long url needs to include a protocol scheme or our controller will think
  # it's an internal route; beyond that it's none of our concern what the rest
  # the url is
  class HasProtocolSchemeValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      if !value.nil? && URI.parse(value).scheme.nil?
        record.errors.add attribute, 'must include protocol prefix'
      end
    end
  end

  # slug length validation is relatively arbitrary; 6 to 50 characters feels "short"
  # enough to me. enforcing an alphanumeric format also seems like a good idea here
  # since that should ensure url safety
  validates :slug, presence: true, uniqueness: true, length: { in: 6..50 }, format: /\A[a-zA-Z0-9]+\z/
  validates :long_url, presence: true, has_protocol_scheme: true

  # make sure a new instance always has a slug before we try to save it
  after_initialize do |short_url|
    if short_url.slug.nil?
      short_url.slug = ShortUrl.generate_slug
    end
  end

  private

    # generate a new, random, non-colliding slug
    def self.generate_slug
      # generate a random url-friendly string and pluck all existing slugs
      new_slug = SecureRandom.urlsafe_base64 8
      existing_slugs = ShortUrl.pluck :slug

      # see if new slug already exists
      until !existing_slugs.include? new_slug
        # regenerate it if it does
        new_slug = SecureRandom.urlsafe_base64 8
      end

      # ruby implicit return looks nice
      new_slug
    end
end
