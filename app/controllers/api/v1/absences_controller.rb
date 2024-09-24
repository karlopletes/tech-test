# frozen_string_literal: true

module Api
  module V1
    # Controller for listing studio absences
    class AbsencesController < ApplicationController
      def index
        @absences = Studio.includes(:stays).flat_map do |studio|
          AbsenceCalculator.new(studio).calculate_absences
        end

        if @absences.empty?
          render json: { message: 'No absences found' }, status: :ok
        else
          render :index, formats: :json
        end
      rescue StandardError => e
        failure_response(e.message)
      end

      def update
        results = StayUpdater.new(absence_params).update_stays

        render json: { message: 'Absences processed', results: }, status: :ok
      rescue ActionController::ParameterMissing
        render json: { error: 'Invalid data' }, status: :unprocessable_entity
      rescue StandardError => e
        failure_response(e.message)
      end

      private

      def failure_response(message)
        render json: { error: "An error occurred: #{message}" }, status: :internal_server_error
      end

      def absence_params
        params.permit(absences: %i[start_date end_date studio_id]).require(:absences)
      end
    end
  end
end
