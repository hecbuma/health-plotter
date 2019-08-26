class ResultSheet < ApplicationRecord
  belongs_to :patient

  has_many :studies

  has_one_attached :document
end
