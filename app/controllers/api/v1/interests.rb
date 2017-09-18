module API
  module V1
    class Interests < Grape::API
      include API::V1::Defaults
      helpers UpdateInterests

      resource :interests do

        ############################
        # => CREATE
        #    new interest
        ############################

        desc 'Create a new interest for the current user.'
        oauth2
        params do
          requires :data, type: Hash do
            requires :offer, type: String
            requires :target, type: String
            requires :category, type: String
            requires :subcategory, type: String
            requires :typus, type: String
            requires :keywords, type: Array
            requires :title, type: String
            requires :description
          end
        end
        post '/' do
          create_new_interest(params)
        end

        ############################
        # => READ
        #    get interests
        #    get interest
        ############################

        desc 'Return all interests'
        oauth2
        get '/' do
          get_all(params)
        end

        desc 'Return all interests of category'
        params do
          requires :category, type: String
        end
        get '/category' do
          get_by_category(params)
        end

        desc 'Return most used keywords'
        get '/keywords' do
          get_most_keywords()
        end

        desc 'Return one interest'
        oauth2
        params do
          requires :id, type: Integer
        end
        get '/:id' do
          get_one(params)
        end

        desc 'Get Contact Data'
        oauth2
        params do
          requires :id, type: Integer
        end
        get '/contact/:id' do
          make_contact(params)
        end

        ############################
        # => UPDATE
        #    edit interest
        ############################

        desc 'Edit an existing interest'
        oauth2
        params do
          requires :data, type: Hash do
            requires :id, type: Integer
            requires :offer, type: String
            requires :target, type: String
            requires :category, type: String
            requires :subcategory, type: String
            requires :typus, type: String
            requires :keywords, type: Array
            requires :title, type: String
            requires :description, type: String
          end
        end
        put '/' do
          edit_interest(params)
        end

        ############################
        # => DESTROY
        #    delete interest
        ############################

        desc 'Remove an existing interest'
        oauth2
        delete '/:id' do
          remove_interest(params)
        end
      end
    end
  end
end