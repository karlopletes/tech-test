require 'rails_helper'

RSpec.describe AbsenceCalculator, type: :service do
  fixtures :studios, :stays

  let(:studio) { studios(:studio1) }
  let(:absences) { absence_calculator.calculate_absences }

  subject(:absence_calculator) { described_class.new(studio) }

  describe '#calculate_absences' do
    context 'when stays exist with absences' do
      it 'returns correct absences' do
        expect(absences).to contain_exactly(
          {
            studio_id: 1,
            studio_name: 'Studio1',
            start_date: '2024-01-11',
            end_date: '2024-01-14'
          }
        )
      end
    end

    context 'when there are no absences' do
      before do
        create(:stay, studio: studio, start_date: '2024-01-10', end_date: '2024-01-15')
      end

      it 'returns an empty array' do
        expect(absences).to be_empty
      end
    end

    context 'when there are no stays' do
      before do
        studio.stays.destroy_all
      end

      it 'returns an empty array' do
        expect(absences).to be_empty
      end
    end
  end
end
