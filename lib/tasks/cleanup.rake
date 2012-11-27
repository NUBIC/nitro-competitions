namespace :cleanup do
  task :move_files => :environment do
    files = FileDocument.all
    puts "#{files.length} file records to process."
    saved = 0
    files.each do |file|
      saved +=1 if file.save_to_disk
    end
    puts "Processed #{files.length} records. Saved #{saved} files."
  end
  
  task :check_files_exist => :environment do
    files = FileDocument.all
    puts "#{files.length} file records to process."
    found=0
    files.each do |file|
      if file.blank?
        puts "file is blank. Shouldn't ever happen"
      elsif file.file.blank? 
        puts "file model in FileDocument is empty. id: #{file.id}."
      elsif file.file.path.blank?
        puts "file path in FileDocument is empty. id: #{file.id}. file_file_name: #{file.file_file_name}."
      elsif ! File.exist?(file.file.path)
        puts "file does not exist. id: #{file.id}; name: #{file.file_file_name}"
      else
        found+=1
      end
    end
    puts "Processed #{files.length} records. Found #{found} files."
  end
end