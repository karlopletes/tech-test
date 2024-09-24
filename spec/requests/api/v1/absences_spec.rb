# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Absences' do
  fixtures :studios, :stays

  describe 'GET #absences' do
    context 'when absences exist' do
      it 'returns the absences' do
        get '/api/v1/absences'

        # expect(response).to have_http_status(:ok)
        json_response = response.parsed_body
        expect(json_response).to contain_exactly(
          ['absences', [{
            'studio_id' => 1,
            'studio_name' => 'Studio1',
            'start_date' => '2024-01-11',
            'end_date' => '2024-01-14'
          },
                        {
                          'studio_id' => 2,
                          'studio_name' => 'Studio2',
                          'start_date' => '2024-01-11',
                          'end_date' => '2024-01-14'
                        }]]
        )
      end
    end

    context 'when no absences exist' do
      before do
        create(:stay, studio: studios(:studio1), start_date: '2024-01-10', end_date: '2024-01-15')
        create(:stay, studio: studios(:studio2), start_date: '2024-01-10', end_date: '2024-01-15')
      end

      it 'returns a message indicating no absences found' do
        get '/api/v1/absences'

        expect(response).to have_http_status(:ok)
        json_response = response.parsed_body
        expect(json_response).to eq({ 'message' => 'No absences found' })
      end
    end
  end

  describe 'POST #update_absences' do
    let(:valid_absences) do
      [
        { studio_id: 1, start_date: '2024-01-01', end_date: '2024-01-10' },
        { studio_id: 2, start_date: '2024-01-05', end_date: '2024-01-10' }
      ]
    end

    context 'when valid absences data is provided' do
      it 'updates stays in the database' do
        post '/api/v1/absences/update', params: { absences: valid_absences }

        expect(response).to have_http_status(:ok)
        json_response = response.parsed_body
        expect(json_response['message']).to eq('Absences processed')
        expect(json_response['results']).to contain_exactly(
          { 'studio' => 'Studio1', 'status' => 'success' },
          { 'studio' => 'Studio2', 'status' => 'success' }
        )

        expect(studios(:studio1).stays.count).to eq(1)
        expect(studios(:studio2).stays.count).to eq(1)
      end
    end

    context 'when a studio does not exist' do
      let(:invalid_absences) do
        [
          { studio_id: 3, start_date: '2024-01-06', end_date: '2024-01-10' }
        ]
      end

      it 'returns a failure message for the missing studio' do
        post '/api/v1/absences/update', params: { absences: invalid_absences }

        expect(response).to have_http_status(:ok)
        json_response = response.parsed_body
        expect(json_response['results']).to contain_exactly(
          { 'studio' => nil, 'status' => 'failed', 'error' => 'Studio not found' }
        )
      end
    end

    context 'when invalid data is provided' do
      it 'returns an error message' do
        post '/api/v1/absences/update', params: {}

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = response.parsed_body
        expect(json_response).to eq({ 'error' => 'Invalid data' })
      end
    end
  end
end
