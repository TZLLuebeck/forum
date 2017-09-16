module API
  module V1
    class Base < Grape::API
      mount API::V1::Users
      mount API::V1::Interests
      mount API::V1::Companies

      Mysql2::Client.default_query_options.merge!(symbolize_keys: :true, as: :hash)
    end
  end
end
