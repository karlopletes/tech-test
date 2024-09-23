# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Studio, type: :model do
  context 'associations' do
    it { is_expected.to have_many(:stays).dependent(:destroy) }
  end
end
