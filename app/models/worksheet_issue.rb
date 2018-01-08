# Worksheet Issue table represents the worksheet data entered
# by the judge, it is not an official determination on the issue
class WorksheetIssue < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :appeal
  belongs_to :hearing, foreign_key: :appeal_id, primary_key: :appeal_id

  validates :appeal, :vacols_sequence_id, presence: true

  def notes
    super || attributes["description"]
  end

  class << self
    def create_from_issue(appeal, issue)
      WorksheetIssue.find_or_create_by(appeal: appeal, vacols_sequence_id: issue.vacols_sequence_id).tap do |record|
        record.update(program: issue.program.try(:capitalize),
                      name: issue.type,
                      levels: issue.description.join("; "),
                      notes: issue.note,
                      description: issue.note,
                      from_vacols: true)
      end
    end
  end
end
