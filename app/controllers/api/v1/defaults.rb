module API
  module V1
    module Defaults
      extend ActiveSupport::Concern

      included do
        version 'v1'
        format :json

        helpers do
          def current_token
            Doorkeeper::AccessToken.find_by! token: bearer_token
          end

          def bearer_token
            pattern = /^Bearer /
            header  = request.headers['Authorization']
            header.gsub(pattern, '') if header && header.match(pattern)
          end

          def warden
            env['warden']
          end

          def current_resource_owner
            User.find(current_token.resource_owner_id) if current_token
          end
          alias_method :current_user, :current_resource_owner

          def current_resource_owner_id
            current_token.resource_owner_id if current_token
          end
        end

        # global exception handler, used for error notifications
        rescue_from :all do |e|
          if Rails.env.development?
            puts 'Rescue Team to the Rescue!'
            fail e
          else
            puts e
            error_response(message: 'Internal server error', status: 500)
          end
        end
        rescue_from Grape::Exceptions::ValidationErrors do |e|
          response = {
            status: 400,
            error: e
          }
          error!(response, 400)
        end
        rescue_from WineBouncer::Errors::OAuthUnauthorizedError do |e|
          response = {
            status: 401,
            error: e.response
          }
          error!(response, 401)
        end
      end
    end
  end
end
