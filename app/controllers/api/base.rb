require 'grape-swagger'

module API
  class Base < Grape::API
    content_type :json, 'application/json'
    default_format :json
    use ::WineBouncer::OAuth2
    mount API::V1::Base
  end
end
