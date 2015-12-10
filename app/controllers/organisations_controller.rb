class OrganisationsController < ApplicationController
  authorize_resource
  before_action :set_company
  before_action :set_user
  before_action :set_organisation, only: [:edit, :update, :delete]

  def new
    @organisation = @company.organisations.new
  end

  def create
    @organisation = @company.organisations.create!(organisation_params)
    redirect_to_user(@user, 'create')
  end

  def update
    @organisation.update!(organisation_params)
    redirect_to_user(@user, 'update')
  end

  def destroy
    @organisation.destroy
    redirect_to_user(@user, 'destroy')
  end

  private

    def set_company
      @company = current_company
    end

    def set_user
      @user = @company.users.find(params[:user_id])
    end

    def set_organisation
      @organisation = @company.organisations.find(params[:organisation_id])
    end

    def redirect_to_user(user, action)
      flash[:success] = t("organisation.flashes.#{action}")
      redirect_to company_user_path(@company, user)
    end

    def organisation_params
      params.require(:organisation).permit(
        :name,
        :description,
        :company_id,
        :user_id
      )
    end
end
