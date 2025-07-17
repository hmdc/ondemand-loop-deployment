module Zenodo::Actions
  class UploadBundleCreate
    include LoggingCommon
    include DateTimeCommon

    def create(project, request_params)
      remote_repo_url = request_params[:object_url]
      url_data = Zenodo::ZenodoUrl.parse(remote_repo_url)

      if !url_data.deposition?
        return error(I18n.t('connectors.zenodo.actions.upload_bundle_create.message_url_not_supported', url: remote_repo_url))
      end

      if url_data.record?
        records_service = Zenodo::RecordService.new(url_data.zenodo_url)
        record = records_service.find_record(url_data.record_id)
        return error(I18n.t('connectors.zenodo.actions.upload_bundle_create.message_record_not_found', url: remote_repo_url)) unless record

        title = record.title
        concept_id = record.concept_id
      elsif url_data.deposition?
        repo_info = RepoRegistry.repo_db.get(url_data.zenodo_url)
        if repo_info.metadata.auth_key.present?
          deposition_service = Zenodo::DepositionService.new(url_data.zenodo_url, api_key: repo_info.metadata.auth_key)
          deposition = deposition_service.find_deposition(url_data.deposition_id)
          return error(I18n.t('connectors.zenodo.actions.upload_bundle_create.message_deposition_not_found', url: remote_repo_url)) unless deposition

          title = deposition.title
          bucket_url = deposition.bucket_url
          draft = deposition.draft?
        end

      end

      file_utils = Common::FileUtils.new
      upload_bundle = UploadBundle.new.tap do |bundle|
        bundle.id = file_utils.normalize_name(File.join(url_data.domain, UploadBundle.generate_code))
        bundle.name = bundle.id
        bundle.project_id = project.id
        bundle.remote_repo_url = remote_repo_url
        bundle.type = ConnectorType::ZENODO
        bundle.creation_date = now
        bundle.metadata = {
          zenodo_url: url_data.zenodo_url,
          title: title,
          record_id: url_data.record_id,
          concept_id: concept_id,
          deposition_id: url_data.deposition_id,
          bucket_url: bucket_url,
          draft: draft
        }
      end
      upload_bundle.save

      ConnectorResult.new(
        resource: upload_bundle,
        message: { notice: I18n.t('connectors.zenodo.actions.upload_bundle_create.message_success', name: upload_bundle.name) },
        success: true
      )
    end

    private

    def error(message)
      ConnectorResult.new(
        message: { alert: message },
        success: false
      )
    end
  end
end