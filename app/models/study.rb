# frozen_string_literal: true

# == Schema Information
#
# Table name: studies
#
#  id              :bigint           not null, primary key
#  name            :string
#  result          :decimal(, )
#  unit            :string
#  result_sheet_id :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Study < ApplicationRecord
  belongs_to :result_sheet
  include PgSearch
  pg_search_scope :search_by_name, against: :name

  scope :by_group, -> (group_name) { where(group: group_name)}
end
