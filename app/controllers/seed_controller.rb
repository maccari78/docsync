class SeedController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :run
  def run
    load Rails.root.join('db/seeds.rb')
    render plain: 'Seeds executed successfully'
  end
end
