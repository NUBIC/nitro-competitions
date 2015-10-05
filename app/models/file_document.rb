# encoding: UTF-8
# == Schema Information
#
# Table name: file_documents
#
#  id                :integer          not null, primary key
#  created_id        :integer
#  created_ip        :string(255)
#  updated_id        :integer
#  updated_ip        :string(255)
#  file_file_name    :string(255)
#  file_content_type :string(255)
#  file_file_size    :integer
#  file_updated_at   :datetime
#  last_updated_at   :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class FileDocument < ActiveRecord::Base
  # Associations
  has_attached_file :file, :path => ":rails_root/public/system/:attachment/:id/:basename.:extension"

  # Callbacks
  before_validation(:on => :create) do |file|
    if file.file_content_type == 'application/octet-stream'
      mime_type = MIME::Types.type_for(file.file_file_name)
      file.file_content_type = mime_type.first.content_type if mime_type.first
    end
    true
  end

  after_validation :log_validation_errors
  before_create :set_on_create
  before_update :set_last_update

  # Validations
  validates_attachment_presence :file
  validates_attachment_content_type :file, :content_type => [/application\/zip/i, /application\/x-/i, /application\/x-zip/i, /application\/x-zip-compressed/i, /application\/pdf/i, /application\/x-pdf/i, /^application\/.*word/i, /pdf/i, /office/i, /excel/i, /rtf/i, /application\/oct/i, /^text/i, /openxml/i, /application\/x-download/i], :message => ' '
  validates_attachment_size :file, :less_than =>50.megabytes

  # this defines the connection between the model attribute exposed to the form (uploaded_file)
  # and the storage fields- file_name, content_type, photo
  def uploaded_file=(field)
    self.file = field
    # self.content_type = self.file_content_type
  end

  def file_exists?
    File.exist?(file.path)
  end

  protected

  def set_last_update
    self.last_updated_at = Time.now
  end

  def set_on_create
    if self.last_updated_at.blank?
      self.last_updated_at = self.updated_at
    end
  end

  def log_validation_errors
    if self.errors.any?
      self.errors.full_messages.each do |msg|
        begin
          logger.warn "File save validation error: #{msg}. file_type: #{self.file_content_type}; file_name: #{self.file_file_name}"
        rescue
          puts  "File save validation error: #{msg}. file_type: #{self.file_content_type}; file_name: #{self.file_file_name}"
        end
      end
    end
  end
end
