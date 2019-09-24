module ApplicationHelper
  def names_uniq(general_studies)
    general_studies.map(&:name).uniq
  end

  def results(studies)
    studies.map { |study| {name: study.result_sheet.date, data: {"#{study.created_at}": study.result}}}
  end
end
