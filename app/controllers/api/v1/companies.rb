module API
  module V1
    class Companies < Grape::API
      include API::V1::Defaults
      helpers UpdateCompanies

      resource :companies do
        
        # CREATE

        desc 'Create new company' 
        oauth2
        params do
          requires :data, type: Hash do
            requires :name, type: String, allow_blank: false
            optional :parent, type: String
            requires :description, allow_blank: false
            requires :typus, type: String, values: ["Klinik", "Institut", "Firma"]
            requires :website, type: String, allow_blank: false
            optional :logo, type: Rack::Multipart::UploadedFile
          end
        end
        post '/' do
          create_company(params)
        end

        # READ
        desc 'Get all companies'
        get '/' do
          get_all()
        end

        desc 'Get validated companies'
        get '/approve' do
          return_validated()
        end

        desc 'get one company'
        params do 
          requires :id, type: Integer
        end
        get '/:id' do
          get_one(params)
        end

        # UPDATE

        desc 'approve new company'
        oauth2
        params do
          requires :id, type: Integer
        end
        put '/approve/:id' do
          validate(params)
        end

        desc 'edit company details'
        oauth2
        params do
          requires :data, type: Hash do
            requires :name, type: String, allow_blank: false
            optional :parent, type: String
            optional :description, allow_blank: false
            optional :typus, type: String, values: ["Klinik", "Institut", "Firma"]
            optional :website, type: String, allow_blank: false
            optional :logo, type: Rack::Multipart::UploadedFile
          end
        end
        put '/:id' do
          edit_company(params)
        end

        #DESTROY
        desc 'delete company'
        oauth2
        delete '/:id' do
          destroy_company(params)
        end
      end
    end
  end
end