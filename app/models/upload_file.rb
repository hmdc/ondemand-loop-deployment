# frozen_string_literal: true

class UploadFile < ApplicationDiskRecord
  include ActiveModel::Model

  ATTRIBUTES = %w[id project_id upload_bundle_id file_location filename status size creation_date start_date end_date].freeze

  attr_accessor *ATTRIBUTES

  validates_presence_of :id, :project_id, :upload_bundle_id, :file_location, :filename, :status, :size
  validates :size, file_size: { max: :max_file_size }

  def self.find(project_id, upload_bundle_id, file_id)
    return nil if project_id.blank? || upload_bundle_id.blank? || file_id.blank?

    filename = filename_by_ids(project_id, upload_bundle_id, file_id)
    return nil unless File.exist?(filename)

    load_from_file(filename)
  end

  def status=(value)
    raise ArgumentError, "Invalid status: #{value}" unless value.is_a?(FileStatus)

    @status = value
  end

  def save
    return false unless valid?

    store_to_file(self.class.filename_by_ids(project_id, upload_bundle_id, id))
  end

  def destroy
    filename = self.class.filename_by_ids(project_id, upload_bundle_id, id)
    FileUtils.rm(filename)
  end

  def upload_bundle
    @upload_bundle ||= UploadBundle.find(project_id, upload_bundle_id)
  end

  def project
    @project ||= Project.find(project_id)
  end

  def connector_status
    ConnectorClassDispatcher.upload_file_connector_status(upload_bundle, self)
  end

  def max_file_size
    Configuration.max_upload_file_size
  end

  private

  def self.filename_by_ids(project_id, upload_bundle_id, file_id)
    File.join(Project.upload_bundles_directory(project_id), upload_bundle_id, "files", "#{file_id}.yml")
  end
end
