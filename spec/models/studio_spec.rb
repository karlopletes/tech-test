# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Studio do
  context 'with associations' do
    it { is_expected.to have_many(:stays).dependent(:destroy) }
  end

  context 'with validations' do
    let(:studio) { build(:studio) }

    it 'is invalid without an name' do
      studio.name = nil
      expect(studio).not_to be_valid
    end
  end
end
