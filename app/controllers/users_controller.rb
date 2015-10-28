class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]

  def index
    role = init_role(params[:role])
    load_users(role)
  end

  def new
    @user = current_company.users.new(role: params[:role])
    load_cabinet_detail(@user)
  end

  def create
    @user = current_company.users.create!(user_params)
    load_users_and_render_index(@user.role)
  end

  def update
    @user.update!(user_params)
    load_users_and_render_index(@user.role)
  end

  private

    def set_user
      @user = current_company.users.find(params[:id])
    end

    def init_role(role)
      role = role ? role : "cabinet"
    end

    def load_users(role)
      @users = role == "all" ? current_company.users : current_company.users.where(role: role)
    end

    def load_users_and_render_index(role)
      load_users(role)
      render :index, change: "users"
    end

    def load_cabinet_detail(user)
      if user.cabinet_detail.nil?
        user.build_cabinet_detail
      end
    end

    def user_params
      params.require(:user).permit(
        :name,
        :firstname,
        :email,
        :role,
        :password,
        :password_confirmation,
        cabinet_detail_attributes: [
          :id,
          :name,
          :street,
          :zipcode,
          :town,
          :specialty,
          :user_id,
          :tel
        ]
      )
    end
end
