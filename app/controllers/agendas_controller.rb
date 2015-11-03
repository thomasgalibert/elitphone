class AgendasController < ApplicationController
  authorize_resource
  before_action :set_cabinet, only: [:index, :new, :create, :show, :update, :edit]
  before_action :set_agenda, only: [:show, :edit, :update]

  def index
    load_agendas
  end

  def new
    @agenda = @cabinet.agendas.new(company_id: current_company.id)
  end

  def create
    @agenda = @cabinet.agendas.create!(agenda_params)
    load_agendas_and_render_index
  end

  def update
    @agenda.update!(agenda_params)
    load_agendas_and_render_index
  end

  def show
    # Event.destroy_all
  end

  private

    def set_cabinet
      @cabinet = current_company.users.find(params[:user_id])
    end

    def set_agenda
      @agenda = @cabinet.agendas.find(params[:id])

      # variables for calendar view
      @date_ref = init_date
      first_day = @date_ref.beginning_of_week
      last_day = @date_ref.end_of_week
      @events = @agenda.events.where(start_at: first_day..last_day)
    end

    def init_date
      date_ref = params[:set_date] ? DateTime.parse(params[:set_date]) : Time.zone.now.to_datetime
    end

    def load_agendas
      @agendas = @cabinet.agendas.order("created_at DESC")
    end

    def load_agendas_and_render_index
      load_agendas
      render :index, change: "agendas"
    end

    def agenda_params
      params.require(:agenda).permit(
        :name,
        :step,
        :start_hour,
        :end_hour,
        :archived,
        :company_id,
        :user_id
      )
    end
end
