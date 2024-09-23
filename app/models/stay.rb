# frozen_string_literal: true

class Stay < ApplicationRecord
  belongs_to :studio

  validates :start_date, presence: true
end
