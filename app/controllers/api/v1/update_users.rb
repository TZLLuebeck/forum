module API
  module V1
    module UpdateUsers
      extend  ActiveSupport::Concern

      # CREATE

      def create_user(params)
        params.delete :format
        if User.find_by(username: params[:data][:username])
          response = {
            status: 409,
            error: 'username_exists'
          }
          error!(response, 409)
        else
          if User.find_by(email: params[:data][:email])
          response = {
            status: 409,
            error: 'email_exists'
          }
          error!(response, 409)          
          else 
            par = params[:data]
            if params[:data][:typus] != "Student"
              par1 = params[:data]
              par2 = params[:data][:contact_data]
              par1.delete :contact_data
              par = par1.merge(par2)
            end
            type = params[:data][:typus]
            par.delete :typus
            if !par.has_key?(:company_id)
              c = Company.create(params[:data][:company])
              if !c
                response = {
                  status: 400,
                  error: 'could_not_create_company'
                }
                error!(response, 400)
              end
              par[:company_id] = c.id
              par.delete :company
            end
            par[:news] = true
            u = User.new(par)
            u.add_role(type.downcase.to_sym)
            if u.save
              token = Doorkeeper::AccessToken.create!(
                application_id: ENV['APPLICATION_ID'],
                resource_owner_id: u.id,
                scopes: 'all',
                expires_in: Doorkeeper.configuration.access_token_expires_in,
                use_refresh_token: Doorkeeper.configuration.refresh_token_enabled?
              )
              ret = {
                user: u.serializable_hash.merge(roles: u.roles.pluck(:name)),
                token: {
                  access_token: token.token,
                  refresh_token: token.refresh_token,
                  expires_in: token.expires_in
                }
              }
              WelcomeMailer.welcome_email(u).deliver_later
              #WelcomeMailWorker.perform_async(u)
              status 200
              { status: 200, data: ret}
            else
              status 400
              { status: 400, error: 'registration_error', data: params}
            end
          end
        end
      end

      def admin_create(params)
        params.delete :format
        r = current_resource_owner
        if ((r.has_role? :admin) || (r.has_role :data)) 
          if User.find_by(username: params[:data][:username])
            response = {
              status: 409,
              error: 'username_exists'
            }
            error!(response, 409)
          else
            if User.find_by(email: params[:data][:email])
            response = {
              status: 409,
              error: 'email_exists'
            }
            error!(response, 409)          
            else 
              par = params[:data]
              if (params[:data][:typus] != "Data" || params[:data][:typus] != "Statistics")
                par1 = params[:data]
                par2 = params[:data][:contact_data]
                par1.delete :contact_data
                par = par1.merge(par2)
              end
              type = params[:data][:typus]
              par.delete :typus
              par[:news] = false
              u = User.new(par)
              u.add_role(type.downcase.to_sym)
              if u.save
                ret = {
                  user: u.serializable_hash.merge(roles: u.roles.pluck(:name)),
                }
                status 200
                { status: 200, data: ret}
              else
                status 400
                { status: 400, error: 'registration_error', data: params}
              end
            end
          end
        else
        response = {
              description: 'Sie haben nicht die nötigen Rechte, um diese Aktion durchzuführen.',
              error: {
                name: 'no_ability',
                state: 'forbidden'
                },
              reason: 'unknown',
              redirect_uri: nil,
              response_on_fragment: nil,
              status: 403
          }
          error!(response, 403)
        end  
      end

      def login(params)
        u = User.where(username: params[:data][:username]).first
        if u
          if u.valid_password?(params[:data][:password])
            token = Doorkeeper::AccessToken.create!(
              application_id: ENV['APPLICATION_ID'],
              resource_owner_id: u.id,
              scopes: 'all',
              expires_in: Doorkeeper.configuration.access_token_expires_in,
              use_refresh_token: Doorkeeper.configuration.refresh_token_enabled?
            )
            ret = {
              user: u.serializable_hash.merge(roles: u.roles.pluck(:name)),
              token: {
                access_token: token.token,
                refresh_token: token.refresh_token,
                expires_in: token.expires_in
              }
            }
            status 200
            { status: 200, data: ret}
          else
            response = {
              description: 'Das eingegebene Passwort war falsch.',
              error: {
                name: 'wrong_password',
                state: 'unauthorized'
                },
              reason: 'unknown',
              redirect_uri: nil,
              response_on_fragment: nil,
              status: 401
          }
          error!(response, 401)
          end
        else
          response = {
              description: 'Dieser Accountname existiert nicht.',
              error: {
                name: 'username_not_found',
                state: 'not_found'
                },
              reason: 'unknown',
              redirect_uri: nil,
              response_on_fragment: nil,
              status: 401
          }
          error!(response, 404)
        end
      end

      
      # READ

      def get_users(params)
        if Ability.new(current_resource_owner).can?(:read, User)
          res = User.where.not(id: current_resource_owner_id).map do |u|
            u.serializable_hash.merge(roles: u.roles)
          end
          if res
            status 200
            { status: 200, data: res }
          else
            response = {
              status: 400,
              error: 'read_error'
            }
            error!(response, 400)
          end
        end
      end

      def return_user(params)
        u = (id = params[:id]) == 'me' ? current_resource_owner : User.find(id)
        if Ability.new(current_resource_owner).can?(:read, u)
          if res = u.serializable_hash.merge(roles: u.roles.pluck(:name))
            p res
            status 200
            { status: 200, data: res }
          else
            response = {
              status: 404,
              error: 'user_not_found'
            }
            error!(response, 404)
          end
        else
          response = {
              description: 'Sie haben nicht die nötigen Rechte, um diese Aktion durchzuführen.',
              error: {
                name: 'no_ability',
                state: 'forbidden'
                },
              reason: 'unknown',
              redirect_uri: nil,
              response_on_fragment: nil,
              status: 403
          }
          error!(response, 403)
        end
      end

      def get_all(params)
        if Ability.new(current_resource_owner).can?(:read, User)
          res = User.all.map do |u|
            u.serializable_hash.merge(roles: u.roles.pluck(:name), posts: u.interests.count())
          end
          if res
            status 200
            { status: 200, data: res }
          else
            response = {
              status: 400,
              error: 'read_error'
            }
            error!(response, 400)
          end
        else
          response = {
              description: 'Sie haben nicht die nötigen Rechte, um diese Aktion durchzuführen.',
              error: {
                name: 'no_ability',
                state: 'forbidden'
                },
              reason: 'unknown',
              redirect_uri: nil,
              response_on_fragment: nil,
              status: 403
          }
          error!(response, 403)
        end
      end

      def return_interests(params)
        if Ability.new(current_resource_owner).can?(:read, Interest)
          int = User.find(params[:id]).interests
          if int
            status 200
            { status: 200, data: int}
          else
            response = {
              status: 404,
              error: 'user_not_found'
            }
            error!(response, 404)
          end
        else
          response = {
              description: 'Sie haben nicht die nötigen Rechte, um diese Aktion durchzuführen.',
              error: {
                name: 'no_ability',
                state: 'forbidden'
                },
              reason: 'unknown',
              redirect_uri: nil,
              response_on_fragment: nil,
              status: 403
          }
          error!(response, 403)
        end
      end
      
      # UPDATE

      def update_user(params)
        params[:data].delete :roles
        u = User.find(params[:data][:id])
        if Ability.new(current_resource_owner).can?(:update, u)
          if u.update_with_password(params[:data])
            p 'Saved!'
            status 200
            { status: 200, message: 'ok', data: u }
          else
            p u.errors.inspect
            response = {
              status: 400,
              error: 'update_error'
            }
            error!(response, 400)
          end
        else
          response = {
              description: 'Sie haben nicht die nötigen Rechte, um diese Aktion durchzuführen.',
              error: {
                name: 'no_ability',
                state: 'forbidden'
                },
              reason: 'unknown',
              redirect_uri: nil,
              response_on_fragment: nil,
              status: 403
          }
          error!(response, 403)
        end
      end

      def reset_password(params)
        if u = User.find_by(username: params[:data])
          generated_password = Devise.friendly_token.first(15)
          if u.update({password: generated_password, password_confirmation: generated_password})
            PasswordMailer.reset_password_email(u, generated_password).deliver_later
          end
        else
          response = {
            description: 'Es wurde kein Account mit diesem Namen gefunden.',
            error: {
              name: 'wrong_username',
              state: 'not_found'
              },
            reason: 'unknown',
            redirect_uri: nil,
            response_on_fragment: nil,
            status: 404
          }
          error!(response, 404)
        end
      end

      # DESTROY

      def destroy_user(params)
        u = User.find(params[:id]) 
        if Ability.new(current_resource_owner).can?(:update, u)
          if u.destroy
            status 200
            { status: 200, message: 'ok' }
          else
            response = {
              status: 400,
              error: 'delete_error'
            }
            error!(response, 400)
          end
        else
          response = {
              description: 'Sie haben nicht die nötigen Rechte, um diese Aktion durchzuführen.',
              error: {
                name: 'no_ability',
                state: 'forbidden'
                },
              reason: 'unknown',
              redirect_uri: nil,
              response_on_fragment: nil,
              status: 403
          }
          error!(response, 403)
        end
      end

      def ability_precheck(opts = {})
        if opts[:ability]
          instance_eval(&opts[:ability])
        else
          Ability.new(current_resource_owner).can?(:manage, User)
        end
      end

    end
  end
end