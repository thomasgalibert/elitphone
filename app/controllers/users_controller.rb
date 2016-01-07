class UsersController < ApplicationController
  authorize_resource
  before_action :set_user, only: [:edit, :update, :show, :destroy]

  def index
    role = init_role(params[:role])
    load_users(role)
  end

  def new
    @user = current_company.users.new(
      role: params[:role],
      organisation_id: params[:organisation]
    )
    load_cabinet_detail(@user)
  end

  def create
    @user = current_company.users.create!(user_params)
    load_users_and_render_index(@user)
  end

  def update
    @user.update!(user_params)
    if @user == current_user
      flash[:success] = t('user.flashes.update')
      redirect_to company_user_path(current_company, @user)
    else
      load_users_and_render_index(@user)
    end
  end

  def destroy
    master_user = @user.participated_organisations.first.user
    @user.participations.destroy_all
    @user.destroy
    flash[:success] = t('user.flashes.destroy')
    redirect_to company_user_path(current_company, master_user)
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

    def load_users_and_render_index(user)
      if user.role == "cabinet"
        load_users(user.role)
        render :index, change: "users"
      elsif user.role == "secretary"
        flash[:success] = t('user.flashes.create_secretary')
        redirect_to company_user_path(
          current_company,
          user.participated_organisations.first.user)
      end
    end

    def load_cabinet_detail(user)
      if user.cabinet_detail.nil? && user.cabinet?
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
        :organisation_id,
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
