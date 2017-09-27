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
          requires :data, type: Hash, message: "data:missing" do
            requires :username, type: String, allow_blank: {value: false, message: "username:Der Accountname darf nicht nur aus Leerzeichen bestehen."}, message: "username:Der Accountname fehlt."
            requires :password, type: String, allow_blank: {value: false, message: "password:Das Passwort darf nicht nur aus Leerzeichen bestehen"}, message: "password:Das Passwort fehlt."
            requires :password_confirmation, type: String, allow_blank: {value: false, message: "password_confirmation:Die Passwort-Bestätigung darf nicht nur aus Leerzeichen bestehen."}, message: "password_confirmation:Die Passwort-Bestätigung fehlt."
            requires :email, type: String, regexp: {value: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, message: "email:Ungültiges Email-Format."}, message: "email:Die Email fehlt."
            requires :typus, type: String, values: {value: ["Klinik", "Institut", "Firma", "Student"], message: "Ungültiger Accounttyp."}, message: "typus:Es muss ein Accounttyp ausgewählt werden."
            optional :contact_data, type: Hash do
              requires :firstname, type: String, allow_blank: {value: false, message: "firstname:blank"}, message: "firstname:Der Vorname fehlt."
              requires :lastname, type: String, allow_blank: {value: false, message: "lastname:blank"}, message: "lastname:Der Nachname fehlt."
              requires :plz, type: String, allow_blank: {value: false, message: "plz:blank"}, message: "plz:Die Postleitzahl fehlt."
              requires :ort, type: String, allow_blank: {value: false, message: "ort:blank"}, message: "ort:Der Ort fehlt."
              requires :web, type: String, allow_blank: {value: false, message: "web:blank"}, message: "web:Die Webaddresse fehlt."
              requires :fon, type: String, allow_blank: {value: false, message: "fon:Die Telefonnummer darf nicht nur aus Leerzeichen bestehen."}, message: "fon:Die Telefonnummer fehlt."
              optional :company_id, type: Integer
            end
            optional :company, type: Hash do
              requires :name, type: String, allow_blank: {value: false, message: "companyname:Der Firmenname darf nicht nur aus Leerzeichen bestehen."}, message: "companyname:Der Firmenname fehlt."
              requires :description, allow_blank: {value: false, message: "companydescription:Die Kurzbeschreibung darf nicht nur aus Leerzeichen bestehen."}, message: "companydescription:Die Kurzbeschreibung fehlt."
              requires :typus, type: String, values: {value: ["Klinik", "Institut", "Firma"], message: "Ungültiger Firmentyp"}, message: "companytypus:missing"
              optional :parent, type: String, allow_blank: {value: false, message: "parent:Die Zugehörigkeit darf nicht nur aus Leerzeichen bestehen."}
              optional :logo, type: Rack::Multipart::UploadedFile
            end            
          end
        end
        post '/' do
          create_user(params)
        end

        desc 'Account created by an admin'
        params do
          requires :data, type: Hash do
            requires :username, type: String, allow_blank: false
            requires :password, type: String, allow_blank: false
            requires :password_confirmation, type: String, allow_blank: false
            requires :email, type: String
            requires :typus, type: String, values: ["Klinik", "Institut", "Firma", "Data", "Statistics"]
            optional :contact_data, type: Hash do
              requires :firstname, type: String, allow_blank: false
              requires :lastname, type: String, allow_blank: false
              requires :plz, type: String, allow_blank: false
              requires :ort, type: String, allow_blank: false
              requires :web, type: String, allow_blank: false
              requires :fon, type: String, allow_blank: false
              optional :company_id, type: Integer
            end            
          end
        end
        oauth2
        post '/create' do
          admin_create(params)
        end

        desc 'Login Process'
        params do
          requires :data, type: Hash do
            requires :username, type: String, allow_blank: false
            requires :password, type: String, allow_blank: false
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
            requires :username, type: String, allow_blank: false
            optional :email, type: String, regexp: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
            optional :ort, type: String, allow_blank: false
            optional :plz, type: String, allow_blank: false
            optional :web, type: String, allow_blank: false
            optional :fon, type: String, allow_blank: false
            optional :password, type: String, allow_blank: false
            optional :password_confirmation, type: String, allow_blank: false
            requires :current_password, type: String, allow_blank: false
            optional :news, type: Boolean
          end
        end
        desc 'Update user'
        oauth2
        put '/' do
          update_user(params)
        end

        params do
          requires :data, type: String
        end
        post '/reset' do
          reset_password(params)
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
