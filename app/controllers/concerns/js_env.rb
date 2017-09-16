module JsEnv
  extend ActiveSupport::Concern

  included do
    helper_method :js_env
  end

  #
  # Helper to inject the Rails Constant in angular. This can be used to share
  # information between both instances
  #
  # @return [String] Returns a `<script>`-tag with the shared angular constant
  #
  def js_env
    data = {
      host: ENV['HOST'],
      database: ENV['DATABASE_HOST'],
      redirect_uri: ENV['REDIRECT_URI'],
      env: Rails.env,
      application_id: ENV['APPLICATION_UID'],
      application_secret: ENV['APPLICATION_SECRET']
    }

    <<-EOS.html_safe
      <script type="text/javascript">
        shared = angular.module('mediMeet')
        shared.constant('Rails', #{data.to_json})
      </script>
    EOS
  end
end
