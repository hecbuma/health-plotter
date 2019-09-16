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

require 'test_helper'

class ResultSheetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
