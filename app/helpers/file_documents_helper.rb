# -*- coding: utf-8 -*-

# Module for FileDocument models
module FileDocumentsHelper

  def link_to_file(id = '', link_text = 'File', file_type = 'document', mouse_over = nil, is_required = false, required_path = nil, lookup_file_type = true)
    if id.blank? || (id.to_i < 1)
      if is_required.blank? || is_required == false
        return ''
      elsif required_path.blank?
        return image_tag('warning_16.png', width: '16px', height: '16px')
      else
        mouse_over ||= ''
        return link_to(link_text, required_path, title: "Please upload #{link_text + mouse_over}", class: 'warning_16')
      end
    end
    if lookup_file_type
      file_name = FileDocument.find(id).file_file_name
      file_format = file_name.gsub(/(.*)\.([^\.+])/, '\2')
      file_format = 'txt' if file_format == file_name
      file_type = 'pdf' if file_format.to_s == 'pdf'
    else
      file_type = 'speed'
      file_format = 'txt'
    end
    mouse_over = link_text if mouse_over.nil?
    mouse_over = file_name if mouse_over.blank?
    link_to(link_text, file_document_path(id, format: file_format), title: 'Download ' + mouse_over, target: '_blank', class: determine_image_class(file_type)).html_safe
  end

  def determine_image_class(file_type)
    case file_type
    when :document, 'document', 'txt'
      'page_white_put'
    when :spreadsheet, 'spreadsheet'
      'page_excel'
    when :pdf, 'pdf'
      'page_white_acrobat'
    else
      'documenticon'
    end
  end

end
