require 'active_record'
require './lib/survey.rb'
require './lib/question.rb'
require './lib/answer.rb'
require './lib/response.rb'
require './lib/respondent.rb'

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["development"])

def welcome
  system('clear')
  puts "*************** Welcome to the Survey Maker *************"
  main_menu
end

 def main_menu
  choice = nil
  until choice == 'x'
    puts "SURVEY MAKER CHOICES:"
    puts "1.  Add a new survey."
    puts "2.  Add questions to a survey."
    puts "Please enter your choice or 'x' to exit."
    user_choice = gets.chomp
    case user_choice
    when '1'
      add_survey
    when '2'
      select_survey
      add_question
    when 'x'
      puts "Good-bye!!"
      exit
    else
      puts "That was an invalid selection.  Please try again."
    end
  end
end

def add_survey
  puts "\nEnter a name for your new survey:"
  survey_name = gets.chomp
  new_survey = Survey.new(:name => survey_name)
  new_survey.save
  puts "\n#{new_survey.name} was added!\n\n"
end

def select_survey
  puts "Select a survey to add a question"
  surveys = Survey.all
  surveys.each_with_index { |survey, index| puts "#{index + 1}. #{survey.name}"}
  selection = gets.chomp.to_i
  @current_survey = surveys[selection - 1]
end

def add_question
  puts "Please enter your question"
  question = gets.chomp
  new_question = Question.new(:name => question, :survey_id => @current_survey.id)
  new_question.save
  puts "You have added #{question} to #{@current_survey.name}\n"
  add_another("add_question")
end

def add_another(method_name)
  puts "Would you like to add another (y/n)?"
  user_choice = gets.chomp
  if user_choice == 'y'
    method(method_name).call
  else
    main_menu
  end
end
welcome
