
def generate_csv(data, use_update_date=false)
  data_hash = Hash.new(0)
  data.each do |x|
    if use_update_date
      the_date = x.updated_at.to_date.to_s(:db)
    else
      the_date = x.created_at.to_date.to_s(:db)
    end
    if data_hash.has_key?(the_date) then
      data_hash[the_date]=data_hash[the_date]+1
    else
      data_hash[the_date] = 1
    end
  end
  data_hash.sort 
end

def generate_csv_from_array(array_of_arrays, use_update_date=false)
  # for each date we will store as a hash. The hash key will point to an array
  data_hash = Hash.new(0)
  array_len = array_of_arrays.length
  array_of_arrays.each_with_index do |data, i|
    data.each do |x|
      if use_update_date
        the_date = x.updated_at.to_date.to_s(:db)
      else
        the_date = x.created_at.to_date.to_s(:db)
      end
      if data_hash.has_key?(the_date) then
        data_hash[the_date][i]=data_hash[the_date][i]+1
      else
        data_hash[the_date] = Array.new(array_len, 0)
        data_hash[the_date][i] = 1
      end
    end
  end
  data_hash.sort 
end

def redirect_stdout
  orig_defout = $stdout
  $stdout = StringIO.new
  yield
  $stdout.string
ensure
  $stdout = orig_defout
end

def parse_svg(string, add_string)
  string=string.gsub(/\s/,' ')
  string=string.sub(/^.*<\?xml/,'<?xml')
  string=string.sub(/(<svg[^>]*>)/,'\1'+add_string)
  string=string.gsub(/>/,">\n")
  string=string.sub(/svg>.*$/,'svg>')
end

