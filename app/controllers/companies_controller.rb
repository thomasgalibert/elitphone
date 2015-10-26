class CompaniesController < ApplicationController
  def new
    @company = Company.new
    @company.users.new
    render layout: "login"
  end

  def create
    @company = Company.create(company_params)

    respond_to do |format|
      if @company.save
        format.html do
          redirect_to login_path
          flash[:success] = t('session.confirm_signup')
        end
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def company_params
      params.require(:company).permit(
        :id,
        :name,
        :number,
        :email,
        :tel,
        :cgv,
        :created_at,
        :updated_at,
        users_attributes: [
          :name,
          :firstname,
          :email,
          :role,
          :password,
          :password_confirmation
        ]
      )
    end
end
