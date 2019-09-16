# == Schema Information
#
# Table name: result_sheets
#
#  id         :bigint           not null, primary key
#  doctor     :string
#  date       :datetime
#  user_id    :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ResultSheet < ApplicationRecord
  belongs_to :user

  has_many :studies

  has_one_attached :document
end
