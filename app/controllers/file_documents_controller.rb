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

class FileDocumentsController < ApplicationController

  include FileDocumentsHelper

  # GET /file_documents/1
  # GET /file_documents/1.xml
  def show
    @file_document = FileDocument.find(params[:id])

    if @file_document.blank? or @file_document.file.blank? or !File.exist?(@file_document.file.path)
      logger.error "file does not exist!"
      send_data( "file does not exist!",
        :type        => "text/html",
        :disposition => "inline")
    else
      send_file @file_document.file.path
    end
  end

end
