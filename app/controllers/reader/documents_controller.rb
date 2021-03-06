class Reader::DocumentsController < Reader::ApplicationController
  EXCEPTIONS = [Caseflow::Error::DocumentRetrievalError, Caseflow::Error::EfolderAccessForbidden].freeze

  # rubocop:disable Metrics/MethodLength
  def index
    respond_to do |format|
      format.html { return render "reader/appeal/index" }
      format.json do
        AppealView.find_or_create_by(
          appeal_id: appeal.id,
          user_id: current_user.id
        ).tap do |t|
          t.update!(last_viewed_at: Time.zone.now)
        end
        MetricsService.record "Get appeal #{appeal_id} document data" do
          render json: {
            appealDocuments: documents,
            annotations: annotations,
            manifestVbmsFetchedAt: manifest_vbms_fetched_at,
            manifestVvaFetchedAt: manifest_vva_fetched_at
          }
        end
      end
    end
  rescue *EXCEPTIONS => e
    respond_to_doc_retrieval_error(e)
  end
  # rubocop:enable Metrics/MethodLength

  def show
    render "reader/appeal/index"
  end

  private

  def appeal
    @appeal ||= Appeal.find_or_create_by_vacols_id(appeal_id)
  end
  helper_method :appeal

  def annotations
    appeal.saved_documents.flat_map(&:annotations).map(&:to_hash)
  end

  def fetched_at_format
    "%D %l:%M%P %Z"
  end

  # Expect appeal.manifest_(vva|vbms)_fetched_at to be either nil or a Time objects
  def manifest_vva_fetched_at
    appeal.manifest_vva_fetched_at.strftime(fetched_at_format) if appeal.manifest_vva_fetched_at
  end

  def manifest_vbms_fetched_at
    appeal.manifest_vbms_fetched_at.strftime(fetched_at_format) if appeal.manifest_vbms_fetched_at
  end

  def documents
    document_ids = appeal.saved_documents.map(&:id)

    # Create a hash mapping each document_id that has been read to true
    read_documents_hash = current_user.document_views.where(document_id: document_ids)
      .each_with_object({}) do |document_view, object|
      object[document_view.document_id] = true
    end

    @documents = appeal.saved_documents.map do |document|
      document.to_hash.tap do |object|
        object[:opened_by_current_user] = read_documents_hash[document.id] || false
        object[:tags] = document.tags
      end
    end
  end

  def respond_to_doc_retrieval_error(e)
    render json: { "errors": ["status": e.message, "title": e.to_s, "detail": e.message] }, status: e.message
  end

  def appeal_id
    params[:appeal_id]
  end
end
