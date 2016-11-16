class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :appeal

  COMPLETION_STATUS_MAPPING = {
    completed: 0,
    cancelled_by_user: 1,
    expired: 2,
    routed_to_ro: 3
  }.freeze

  REASSIGN_OLD_TASKS = [:EstablishClaim]

  class << self
    def unassigned
      where(user_id: nil)
    end

    def assigned_not_completed
      to_complete.where.not(assigned_at: nil)
    end

    def newest_first
      order(created_at: :desc)
    end

    def completed_today
      where(completed_at: DateTime.now.beginning_of_day.utc..DateTime.now.end_of_day.utc)
    end

    def to_complete
      where(completed_at: nil)
    end

    def completed
      where.not(completed_at: nil)
    end

    def completion_status_code(text)
      COMPLETION_STATUS_MAPPING.key(text)
    end
  end

  def start_text
    type.titlecase
  end

  def assign(user)
    update_attributes!(
      user: user,
      assigned_at: Time.now.utc
    )
    self
  end

  def duplicate_and_mark_complete!
    transaction do
      EstablishClaim.create!(appeal_id: appeal_id)
      completed!(self.class.completion_status_code("Expired"))
    end
  end

  def assigned?
    assigned_at
  end

  def progress_status
    if completed_at
      "Complete"
    elsif started_at
      "In Progress"
    elsif assigned_at
      "Not Started"
    else
      "Unassigned"
    end
  end

  def complete?
    completed_at
  end

  # completion_status is 0 for success, or non-zero to specify another completed case
  def completed!(status)
    update_attributes!(
      completed_at: Time.now.utc,
      completion_status: status
    )
  end

  def completion_status_text
    COMPLETION_STATUS_MAPPING.key(completion_status).to_s.titleize
  end
end
