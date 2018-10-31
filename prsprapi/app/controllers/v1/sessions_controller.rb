class V1::SessionsController < ApiController
    skip_before_action :require_login!, only: [:create]

    def show
        current_user ? head(:ok) : head(:unauthorized)
    end


    # def create
    #     success, user = User.valid_password?(params[:email], params[:password])
    #     if success
    #       render json: user.as_json(only: [:id, :email, :authentication_token]), status: :created  
    #     else
    #       head :unauthorized
    #     end
    # end

    # def destroy
    #     current_user&.authentication_token = nil
    #     if current_user.save
    #         head(:ok)
    #     else 
    #         head(:unauthorized)
    #     end
    # end

    def create
    
        success, user = User.valid_password?(params[:email], params[:password])
        if success
          authentication_token = user.generate_auth_token
          render json: { auth_token: authentication_token }
        else
          head :unauthorized
        end
    
    end

    def destroy
        current_user&.authentication_token = nil
        if current_user.save
            head(:ok)
        else 
            head(:unauthorized)
        end
    end 
    
    private
    def invalid_login_attempt
        render json: { errors: [ { detail:"Error with your login or password" }]}, status: 401
    end


end
