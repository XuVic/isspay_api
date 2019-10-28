module Api::Chatfuel
  class UsersController < BaseController
    def create
      record = CreateUser.new(params: sign_up_params).call!
      
      msg = ["恭喜 #{record.name}，成功註冊 IssPay～～", "請到 #{record.email} 信箱收取驗證信"]

      render_msg type: :text, msg: msg
    end

    def update
      record = UserForm.in_update(current_user, attributes: update_params).submit!

      render_msg type: :text, msg: ['個人資料已更新!']
    end

    private
    def update_params
      params.require(:user).permit(:first_name, :last_name, :nick_name, :gender, :role, :admin)
    end

    def sign_up_params
      sanitize_sign_up_params
      params.require(:user).permit(:email, :first_name, :last_name, :nick_name, :gender, :role, :messenger_id)
    end

    def sanitize_sign_up_params
      return unless params[:user]
      
      params[:user][:gender] = params[:user][:gender].to_i if params[:user][:gender]
      params[:user][:role] = params[:user][:role].to_i if params[:user][:gender]
    end
  end
end
