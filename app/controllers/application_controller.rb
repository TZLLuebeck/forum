class ApplicationController < ActionController::Base
  include JsEnv
  respond_to :html, :json
  protect_from_forgery with: :exception
end
