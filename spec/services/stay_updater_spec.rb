require 'rails_helper'

RSpec.describe StayUpdater, type: :service do
  fixtures :studios, :stays

  let(:studio1) { studios(:studio1) }
  let(:studio2) { studios(:studio2) }
  let(:results) { stay_updater.update_stays }

  subject(:stay_updater) { described_class.new(absences) }

  describe '#update_stays' do
    context 'when a studio does not exist' do
      let(:absences) do
        [
          { studio_id: 3, start_date: '2024-01-06', end_date: '2024-01-10' }
        ]
      end

      it 'returns a failed status for the missing studio' do
        expect(results).to contain_exactly(
          { studio: nil, status: 'failed', error: 'Studio not found' }
        )
      end
    end

    context 'when absences overlap with existing stays' do
      let(:absences) do
        [
          { studio_id: 1, start_date: '2024-01-01', end_date: '2024-01-03' },
          { studio_id: 1, start_date: '2024-01-07', end_date: '2024-01-08' },
          { studio_id: 2, start_date: '2024-01-16', end_date: '2024-01-18' }
        ]
      end

      it 'processes absences and updates stays correctly' do
        expect(results).to contain_exactly(
          { studio: 'Studio1', status: 'success' },
          { studio: 'Studio1', status: 'success' },
          { studio: 'Studio2', status: 'success' }
        )

        # 1 existing stay + 2 new stays after split
        expect(studio1.stays.count).to eq(3)

        # 1 existing stay + 1 updated stay
        expect(studio2.stays.count).to eq(2)
      end
    end

    context 'when the studio does not exist' do
      let(:absences) do
        [{ studio_id: 3, start_date: '2024-01-06', end_date: '2024-01-10' }]
      end

      it 'returns a failure response' do
        expect(results).to contain_exactly(
          { studio: nil, status: 'failed', error: 'Studio not found' }
        )
      end
    end

    context 'when overlapping stays fully contain the absence period' do
      let(:absences) do
        [{ studio_id: 1, start_date: '2024-01-01', end_date: '2024-01-10' }]
      end

      it 'destroys the overlapping stay' do
        results

        # One stay should be destroyed
        expect(studio1.stays.count).to eq(1)
      end
    end

    context 'when there are no overlapping stays' do
      let(:absences) do
        [{ studio_id: 1, start_date: '2024-02-01', end_date: '2024-02-10' }]
      end

      it 'returns an empty array' do
        expect(results).to be_empty
      end
    end
  end
end
