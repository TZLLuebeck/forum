module API
  module V1
    module UpdateInterests
      extend ActiveSupport::Concern
      
      ##################
      #CREATE
      ##################

      def create_new_interest(params)
        params[:data].merge!(
            user_id: current_resource_owner_id,
          )
        keywords = params[:data][:keywords]
        params[:data].delete :keywords
        ref = Interest.new(params[:data])
        if keywords
          keywords.each do |keyword|
              ref.tag_list.add(keyword)
          end
        end
        ref.contacts = 0
        if ref.save 
          ref.find_similar_interests
          status 200
          {status: 200, data: ref}
        else
          response = {
            status: 400,
            error: 'could_not_create'
          }
          error!(response, 400)
        end
      end

      def assign_interest(params)
        keywords = params[:data][:keywords]
        params[:data].delete :keywords
        ref = Interest.new(params[:data])
        if keywords
          keywords.each do |keyword|
              ref.tag_list.add(keyword)
          end
        end
        ref.contacts = 0
        if ref.save 
          status 200
          {status: 200, data: ref}
        else
          response = {
            status: 400,
            error: 'could_not_create'
          }
          error!(response, 400)
        end
      end
      
      #################
      #READ
      #################
      
      def get_all(params)
        int = Interest.all
        res = int.map do |element|
          u = User.find(element.user_id)
          element.serializable_hash.merge(owner: u.email, keywords: element.tag_list)
        end
        if res
          status 200
          {status: 200, data: res}
        else
          response = {
            status: 400,
            error: 'read_error'
          }
          error!(response, 400)
        end
      end

      def get_by_category(params)
        int = Interest.where(category: params[:category]).or(Interest.where(category: "Beliebig"))
        res = int.map do |element|        
          element.serializable_hash.merge(keywords: element.tag_list)
        end
        if res
          status 200
          {status: 200, data: res}
        else
          response = {
            status: 400,
            error: 'read_error'
          }
          error!(response, 400)
        end
      end

      def get_one(params)
        int = Interest.find(params[:id])
        u = User.find(int.user_id)
        res = int.serializable_hash.merge(owner: u.email, keywords: int.tag_list)     
        if res
          status 200
          {status: 200, data: res}
        else
          response = {
            status: 400,
            error: 'read_error'
          }
          error!(response, 400)
        end
      end

      def make_contact(params)
        int = Interest.find(params[:id])
        if int
          Interest.increment_counter(:contacts, int.id)
          if int.save
            u = User.find(int.user_id)
            if u.company_id
              c = Company.find(u.company_id)
            end
            res = {
              firstname: u.firstname,
              lastname: u.lastname,
              email: u.email,
              web: u.web,
              fon: u.fon,
              cmp: c.name,
              cmpt: c.typus
            }
            status 200
            {status: 200, data: res}
          end
        else
          response = {
            status: 404,
            error: 'not_found'
          }
          error!(response, 404)
        end
      end


      def get_most_keywords()
        sql = "Select tags.name from tags order by tags.taggings_count limit 16"
        keywords = ActiveRecord::Base.connection.execute(sql)
        if keywords
          status 200
          {status: 200, data: keywords}
        else
          response = {
            error: 400,
            message: 'could_not_read_keywords'
          }
        end
      end

      #################
      #UPDATE
      #################

      def edit_interest(params)
        i = Interest.find(params[:data][:id])
        params[:data].delete :owner
        keywords = params[:data][:keywords].to_a
        tags = i.tag_list.dup
        tags.each do |tag|
          if not keywords.include?(tag)
            p tag + ' is not in keywords, remove.'
            i.tag_list.remove(tag)
          end
        end
        keywords.each do |keyword|
          if not tags.include?(keyword)
            p keyword + ' is not in tags, add.'
            i.tag_list.add(keyword)
          end
        end
        params[:data].delete :keywords
        if i.update(params[:data])
          status 200
          { status: 200, message: 'ok', data: i }
        else
          p i.errors.inspect
          response = {
            status: 400,
            error: 'update_error'
          }
          error!(response, 400)
        end
      end

      #################
      #DESTROY
      #################

      def remove_interest(params)
        if Interest.find(params[:id]).destroy
         status 200
          { status: 200, message: 'ok' }
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