class AddSecretToShortUrls < ActiveRecord::Migration[6.0]
  def change
    add_column :short_urls, :secret, :string
  end
end
