module API
  module V1
    class Users < Grape::API
      include API::V1::Defaults  
      helpers UpdateUsers

      helpers do
        # Revokes the current token in the database
        def revoke
          # The authorization server first validates the client credentials
          if current_token && current_token.accessible?
            revoke_token(current_token)
          end
        end

        def revoke_token(token)
          if token
            token.revoke
            true
          else
            false
          end
        end
      end

      resource :users do
        ##################
        #
        # => Create
        #    new user
        #    login
        #
        ##################

        desc 'Creates a normal user account'
        params do
          requires :data, type: Hash do
            requires :username, type: String
            requires :password, type: String
            requires :password_confirmation, type: String
            requires :email, type: String
            requires :typus, type: String
            optional :contact_data, type: Hash do
              requires :firstname, type: String
              requires :lastname, type: String
              optional :web, type: String
              optional :fon, type: String
              optional :company, type: Integer
            end            
          end
        end
        post '/' do
          create_user(params)
        end

        desc 'Login Process'
        params do
          requires :data, type: Hash do
            requires :username, type: String
            requires :password, type: String
          end
        end
        post '/login' do
          login(params)
        end


        ##################
        #
        # => READ
        #    get users
        #    get user
        #
        ##################

        desc 'Return all users'
        oauth2
        get '/' do
          get_all(params)
        end

        desc 'Return users interests'
        params do
          requires :id, type: Integer
        end
        oauth2
        get '/interests/:id' do
          return_interests(params)
        end

        desc 'Return one user'
        oauth2
        get '/:id' do
          return_user(params)
        end

        ##################
        #
        # => UPDATE
        #    edit profile
        #
        ##################

        params do
          requires :data, type: Hash do
            requires :username, type: String
            optional :email, type: String
            optional :ort, type: String
            optional :plz, type: String
            optional :web, type: String
            optional :fon, type: String
            optional :password, type: String
            optional :password_confirmation, type: String
            requires :current_password, type: String
          end
        end
        desc 'Update user'
        oauth2
        put '/' do
          p params
          update_user(params)
        end


        ##################
        #
        # => DESTROY
        #    logout
        #    delete user
        #
        ##################

        desc 'Logout'
        oauth2
        delete '/logout' do
          revoke && warden.logout
        end

        desc 'Deletes an user'
        oauth2
        params do
          requires :id, type: Integer, desc: 'user id'
        end
        delete '/:id' do
          destroy_user(params)
        end
      end
    end
  end
end
