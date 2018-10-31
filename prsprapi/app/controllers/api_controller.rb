class ApiController < ActionController::API
    include ActionController::HttpAuthentication::Token::ControllerMethods
    acts_as_token_authentication_handler_for User, fallback: :none

    before_action :require_login!
    helper_method :person_signed_in?, :current_user
  
    def user_signed_in?
        current_person.present?
    end

    def require_login!
        return true if authenticate_token
        render json: { errors: [ { detail: "Access denied" } ] }, status: 401
    end

    def current_user
        @_current_user ||= authenticate_token
    end
    

    private
    def authenticate_token
        authenticate_with_http_token do |token, options|
            User.find_by(authentication_token: token)
        end
    end
end
