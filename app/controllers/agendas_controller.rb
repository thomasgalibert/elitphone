class AgendasController < ApplicationController
  autocomplete :agenda, :name_cabinet, full: true, extra_data: [:name, :user_id], display_value: :display_results
  authorize_resource
  before_action :set_cabinet, only: [:index, :new, :create, :show, :update, :edit, :show_day_events, :show_day]
  before_action :set_agenda, only: [:show, :edit, :update, :show_day_events, :show_day]

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
    find_events_week
  end

  def show_day
    find_events_day
  end

  def show_day_events
    find_events_day
  end

  private

    def set_cabinet
      @cabinet = current_company.users.find(params[:user_id])
    end

    def set_agenda
      @agenda = @cabinet.agendas.find(params[:id])
    end

    def find_events_week
      @date_ref = init_date
      first_day = @date_ref.beginning_of_week
      last_day = @date_ref.end_of_week
      @events = @agenda.events.where(start_at: first_day..last_day)
    end

    def find_events_day
      @date_ref = params[:day].to_datetime
      @events = @agenda.events.onday(@date_ref)
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
        :user_id,
        :name_cabinet
      )
    end
end
