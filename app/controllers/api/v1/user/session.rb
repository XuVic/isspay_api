module Api::V1::User
  module Session
    def login
    end

    def logout
    end

    private

    def login_params
      params.require(:user).permit(:email, :password)
    end

    def authenticate_user
      
    end
  end
end