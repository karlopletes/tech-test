# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Studio do
  context 'with associations' do
    it { is_expected.to have_many(:stays).dependent(:destroy) }
  end
end
