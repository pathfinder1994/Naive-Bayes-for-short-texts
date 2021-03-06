require File.dirname(__FILE__) + "/lib/parser.rb"
require File.dirname(__FILE__) + "/lib/helper.rb"
require File.dirname(__FILE__) + "/lib/classifier.rb"

stop_words_file_name = "data/stop-words-english.txt"

dump_file_name   = "nb.memory"
dump_file_exists = File.exist?(dump_file_name)
#dump_file_exists = false

file_name = "data/SMSSpamCollection.txt"
classes   = ["spam", "ham"]
separator = "\t"
text_col  = 1
class_col = 0

file_name = "data/input2.csv"
file_name = "data/input1.csv"
classes   = ["true", "false"]
separator = ","
text_col  = 0
class_col = 1

parser      = Parser.new
helper      = Helper.new
classifier  = Classifier.new

# Load stop words
stop_words = parser.read_stop_words_from(stop_words_file_name)
stop_words = helper.clear(stop_words)
stop_words.each{|stop_word|
  stop_word = (helper.split_record(stop_word) - [""])
}
stop_words = stop_words.compact
puts "\nLoaded stop words\n"

unless dump_file_exists
  records = parser.read_csv(file_name, text_col, separator, class_col)
  puts "\nLoaded from file\n\n"

  # total words
  spam = records.select{|hash| hash[:class] == classes[0] }.count
  ham  = records.select{|hash| hash[:class] == classes[1] }.count

  puts records.count
  puts ham.to_f / (records.count) * 100

  # normalizing and cleaning of records
  records = helper.normalize(records, *classes)
  puts "\nNormalized\n"

  records = helper.clear(records)
  puts "\nCleaned\n\n"

  spam = records.select{|hash| hash[:class] == classes[0] }.count
  ham  = records.select{|hash| hash[:class] == classes[1] }.count

  puts records.count
  puts ham.to_f / records.count * 100

  # split records to words and clear them from stop words
  records = helper.clear_stop_words(records, stop_words)
  puts "\nCleaned from stop words\n"

  # delete all nonuniq records
  #records.uniq!
  #puts "\nDeleted duplicates\n\n"

f

  spam = records.select{|hash| hash[:class] == classes[0] }.count
  ham  = records.select{|hash| hash[:class] == classes[1] }.count

  puts records.count
  puts ham.to_f / records.count * 100

  training_set, validation_set, test_set = helper.create_sets_of_records(records, 0.7, 0.2, 0.1)
  puts "\nCreated sets for classifier study\n\n"

  class_list = []
  records.each{|hash| class_list << hash[:class] }
  class_list.uniq!

  p class_list

  classifier.obtain_valid_classes(class_list)
  classifier.study_by training_set

  #spam = validation_set.select{|hash| hash[:class] == classes[0] }.count
  #ham  = validation_set.select{|hash| hash[:class] == classes[1] }.count

  #puts test_set.count
  #puts ham.to_f / validation_set.count * 100

  #puts "best laplas factor #{classifier.crossvalidation_by(validation_set, 1..10, 3)}"
  # classifier.save
  puts "=================================="
  spam = test_set.select{|hash| hash[:class] == classes[0] }.count
  ham  = test_set.select{|hash| hash[:class] == classes[1] }.count

  puts test_set.count
  puts ham.to_f / test_set.count * 100

  puts classifier.test_by  test_set
else
  classifier       = Classifier.load

  print "\n  Hello, please write down the message you want to classify.\n  Enter 'exit' to leave me.\n\n"
  while true
    print "\n #: "
    message = gets.chomp

    break if message == "exit"

    message = helper.clear([message])
    message = helper.clear_stop_words(message, stop_words)

    message = message.first

    p message

    class_name = classifier.classify message

    print " class: #{class_name}"
  end
end