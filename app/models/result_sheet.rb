class ResultSheet < ApplicationRecord
  belongs_to :user

  has_many :studies

  has_one_attached :document
end
