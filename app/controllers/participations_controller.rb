class ParticipationsController < ApplicationController
  authorize_resource
  before_action :set_company
  before_action :set_organisation

  def new
    @participation = @organisation.participations.new
  end

  def create
    @participation = @organisation.participations.create!(participation_params)
    redirect_to company_user_path(@company, @organisation.user)
  end

  def destroy
    participation = @organisation.participations.find(params[:id])
    participation.destroy
    flash[:success] = t('user.flashes.destroy_participation')
    redirect_to company_user_path(current_company, @organisation.user)
  end

  private

    def set_company
      @company = current_company
    end

    def set_organisation
      @organisation = @company.organisations.find(params[:organisation_id])
    end

    def participation_params
      params.require(:participation).permit(
        :organisation_id,
        :user_id
      )
    end
end
