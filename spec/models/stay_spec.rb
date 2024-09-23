# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stay do
  context 'with associations' do
    it { is_expected.to belong_to(:studio) }
  end

  context 'with validations' do
    let(:stay) { build(:stay) }

    it 'is invalid without an start date' do
      stay.start_date = nil
      expect(stay).not_to be_valid
    end
  end
end
