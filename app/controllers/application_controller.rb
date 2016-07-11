class ApplicationController < ActionController::API
  include ActionController::Serialization
  include CanCan::ControllerAdditions

  before_action :authenticate_request
  attr_reader :current_user


  rescue_from CanCan::AccessDenied do |exception|
    render json: {error: 'Access Denied'}, status: 403
  end

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render json: {error: 'Not Authorized'}, status: 401 unless @current_user
  end

end
