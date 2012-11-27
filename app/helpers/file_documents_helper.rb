module FileDocumentsHelper
  
  def link_to_file(id="", link_text="File", file_type="document", mouse_over=nil, is_required=false, required_path=nil, lookup_file_type=true)
    if id.blank? or (id.to_i < 1)
      if is_required.blank? or is_required == false
        return "" 
      elsif required_path.blank?
        return image_tag( "warning_16.png", :width=>"16px", :height=>"16px" )
      else
        mouse_over||=""
        return link_to( link_text+image_tag( "warning_16.png", :width=>"16px", :height=>"16px" ), required_path, :title=>"Please upload #{link_text+mouse_over}")
      end
    end
    if lookup_file_type then
      file_name = FileDocument.find(id).file_file_name
      file_format = file_name.gsub(/(.*)\.([^\.+])/,'\2')
      file_format = "txt" if file_format == file_name
      file_type = "pdf" if file_format == "pdf" or file_format == :pdf
    else
      file_type = 'speed'
      file_format = "txt"
    end
    image_name = case file_type 
      when :document, "document", "txt" then "page_white_put.png"
      when :spreadsheet, "spreadsheet" then "page_excel.png"
      when :pdf, "pdf" then "page_white_acrobat.png"
      else "documenticon.gif"
    end
    mouse_over = link_text if mouse_over.nil?
    mouse_over = file_name if mouse_over.blank?
    link_to( link_text+image_tag( image_name, :width=>"16px", :height=>"16px" ), file_document_path(id, :format=>file_format), :title=>"Download "+mouse_over, :target => '_blank' )
  end
  
end
