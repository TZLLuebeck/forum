module API
  module V1
    module UpdateCompanies
      extend ActiveSupport::Concern

      #CREATE

      def create_company(params)
        c = Company.find_by(name: params[:data][:name])
        if c
          response = {
            status: 409,
            error: 'company_already_exists'
          }
          error!(response, 409)
        else
          c = Company.new(params[:data])
          c.validated = false
          if c.save
            status 200
            {status: 200, data: c}
          else
            response = {
              status: 400,
              error: 'could_not_create'
            }
            error!(response, 400)
          end
        end
      end


      #READ
      def get_all()
        c = Company.all.order(:name)
        if c
          status 200
          {status: 200, data: c}
        else
          response = {
            status: 400,
            error: 'read_error'
          }
          error!(response, 400)
        end
      end

      def return_validated()
        c = Company.where(validated: true).order(:name)
        if c
          status 200
          {status: 200, data: c}
        else
          response = {
            status: 400,
            error: 'read_error'
          }
          error!(response, 400)
        end
      end

      def get_one(params)
        c = Company.find(params[:id])
        posts = c.interests
        if c
          status 200
          {status: 200, data: {
            company: c,
            posts: posts
            }
          }
        else
          response = {
            status: 404,
            error: 'company_not_found'
          }
          error!(response, 404)
        end
      end


      #UPDATE
      def edit_company(params)
        c = Company.find(params[:data][:id])
        if Ability.new(current_resource_owner).can?(:update, c)
          if c.update(params[:data])
            status 200
            { status: 200, message: 'ok', data: c }
          else
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


      def validate(params)
        if Ability.new(current_resource_owner).can?(:approve, Company)
          c = Company.find(params[:id])
          c.validated = true
          if c.save()
            status 200
            {status: 200, data: 'approval_successful'}
          else
            response = {
              status: 400,
              error: 'approval_failed'
            }
            error!(response, 400)
          end
        else
          response = {
            status: 403,
            error: 'can_not_approve'
          }
          error!(response, 403)
        end
      end


      #DESTROY

      def destroy_company(params)
        c = Company.find(params[:id])
        if c.destroy
          status 200
          {status: 200}
        else
          response = {
            status: 400,
            error: 'delete_error'
          }
          error!(response, 400)
        end
      end

    end
  end
end