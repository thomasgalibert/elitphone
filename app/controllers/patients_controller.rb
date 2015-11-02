class PatientsController < ApplicationController
  authorize_resource
  before_filter :set_company
  before_filter :set_patient, only: [:show, :edit, :update]

  def index
    load_patients
  end

  def new
    @patient = @company.patients.new
  end

  def edit

  end

  def create
    @patient = @company.patients.create!(patient_params)
    load_patients_and_render_index
  end

  def update
    @patient.update!(patient_params)
    load_patients_and_render_index
  end

  def destroy
    @patient.destroy
    load_patients_and_render_index
  end

  private

    def set_company
      @company = current_company
    end

    def set_patient
      @patient = @company.patients.find(params[:id])
    end

    def load_patients
      @patients = @company.patients
    end

    def load_patients_and_render_index
      load_patients
      render :index, change: "patients"
    end

    def patient_params
      params.require(:patient).permit(
        :company_id,
        :gender,
        :name,
        :firstname,
        :email,
        :tel,
        :street,
        :zipcode,
        :town,
        :birthday
      )
    end
end
