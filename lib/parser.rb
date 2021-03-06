# Load data from outer resources
#
class Parser
  # Create records array from obtained information
  # (load data => split it on records => put records in array => normalize it)
  #
  # if(class_col_num == -1) => Records ( [ [" text full of words "], [" ... "], ... ] )
  # else => Records ( [ ["class_name", " text full of words "], [" ... "], ... ] )
  def read_stop_words_from(file_name)
    stop_words_list = [""]
    File.open(file_name, "r+") do |text|
      text.each_line do |line|
        stop_words_list.push( line )
      end
    end
    stop_words_list
  end

  def read_csv(file_name, text_col_num, separator, class_col_num = -1)
    total_records = []
    if ( class_col_num == -1 )
      File.open(file_name, "r+") do |text|
        text.each_line do |line|

          line = line.split(separator)
          total_records.push( line[text_col_num] )

        end
      end
    else
      File.open(file_name, "r+") do |text|
        text.each_line do |line|

          line = line.split(separator)
          total_records.push( {class: line[class_col_num], text: line[text_col_num]} )

        end
      end
    end
    total_records
  end

  # Create classifier in memor by loading prepeared data
  # or classifier dump
  #
  # => Classifier
  def load_classifier

  end

  def read_csv_with_words_vector(file_name, vector_col_num, separator, class_col_num)
    unless ( class_col_num == -1 )

    else

    end
  end
end