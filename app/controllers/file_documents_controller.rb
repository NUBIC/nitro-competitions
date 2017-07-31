# -*- coding: utf-8 -*-
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
