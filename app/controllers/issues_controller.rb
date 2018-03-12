class IssuesController < ApplicationController
  before_action :verify_queue_phase_two

  rescue_from ActiveRecord::RecordInvalid, IssueRepository::IssueError do |e|
    Rails.logger.error "IssuesController failed: #{e.message}"
    Raven.capture_exception(e)
    render json: { "errors": ["title": e.class.to_s, "detail": e.message] }, status: 400
  end

  def create
    return record_not_found unless appeal

    record = Issue.create_in_vacols!(
      css_id: current_user.css_id,
      issue_attrs: create_params
    )
    render json: { issue: record }, status: :created
  end

  def update
    return record_not_found unless appeal

    record = Issue.update_in_vacols!(
      css_id: current_user.css_id,
      vacols_id: appeal.vacols_id,
      vacols_sequence_id: params[:vacols_sequence_id],
      issue_attrs: issue_params
    )
    render json: { issue: record }, status: :ok
  end

  private

  def appeal
    @appeal ||= Appeal.find(params[:appeal_id])
  end

  def issue_params
    params.require("issues").permit(:note,
                                    :program,
                                    :issue,
                                    :level_1,
                                    :level_2,
                                    :level_3)
  end

  def create_params
    issue_params.merge(vacols_id: appeal.vacols_id)
  end

  def record_not_found
    render json: {
      "errors": [
        "title": "Record Not Found",
        "detail": "Record with that ID is not found"
      ]
    }, status: 404
  end
end
