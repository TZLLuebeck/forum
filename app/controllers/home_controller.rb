class HomeController < ActionController::Base
  include JsEnv
  respond_to :html, :json
  protect_from_forgery with: :exception
  layout 'index'

  def index
    render text: '', layout: true
  end
end