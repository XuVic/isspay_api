module Api::Chatfuel
  class UsersController < BaseController
    def create
      record = CreateUser.new(params: sign_up_params).call!
      
      msg = ["恭喜 #{record.name}，成功註冊 IssPay～～", "請到 #{record.email} 信箱收取確認信"]
      replier.send_messages(msg)
    end

    def update
      user = UserForm.in_update(current_user, attributes: updated_params).submit!
      
      replier.update(user)
    end

    def show
      replier.show(current_user)
    end

    def set_admin
      current_user.set_admin!(admin_param)
      verb = admin_param ? '成為' : '註銷'
      replier.send_messages(["#{current_user.first_name} #{verb} Admin."])
    end

    private

    def updated_params
      sanitize_params

      params.require(:user).permit(:email, :first_name, :last_name, :nick_name, :gender, :role, :messenger_id, :admin)
    end

    def admin_param
      params[:user][:admin].downcase == 'false' ? false : true
    end

    def sign_up_params
      sanitize_params
      params.require(:user).permit(:email, :first_name, :last_name, :nick_name, :gender, :role, :messenger_id)
    end

    def sanitize_params
      return unless params[:user]
      
      params[:user][:gender] = params[:user][:gender].to_i if params[:user][:gender]
      params[:user][:role] = params[:user][:role].to_i if params[:user][:role]
    end
  end
end
