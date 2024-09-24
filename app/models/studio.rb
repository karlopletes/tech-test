# frozen_string_literal: true

class Studio < ApplicationRecord
  has_many :stays, dependent: :destroy

  validates :name, presence: true
end
