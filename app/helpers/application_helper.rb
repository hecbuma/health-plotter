# frozen_string_literal: true

module ApplicationHelper
  def names_uniq(general_studies)
    general_studies.map(&:group).uniq
  end

  def results(studies)
    studies.map { |study| [study.created_at, study.result.to_f] }
  end

  def random_color
    color = rand(0..2)
    colors = %w[is-info is-success is-primary]
    colors[color]
  end
end
