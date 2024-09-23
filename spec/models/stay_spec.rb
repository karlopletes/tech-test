# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stay, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:studio) }
  end

  context 'validations' do
    let(:stay) { build(:stay) }

    it 'is invalid without an start date' do
      stay.start_date = nil
      expect(stay).not_to be_valid
    end
  end
end
