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
    puts "*************** SURVEY MAIN MENU *****************"
    puts "SURVEY MAKER CHOICES:"
    puts "1.  Add a new survey."
    puts "2.  Add questions to a survey."
    puts "3.  Add an answer to an existing question."
    puts "4.  See a survey report.\n"
    puts "\nSURVEY TAKER CHOICES:"
    puts "5.  Take a survey."
    puts "Please enter your choice or 'x' to exit."
    user_choice = gets.chomp
    case user_choice
    when '1'
      add_survey
    when '2'
      select_survey
      add_question
    when '3'
      add_answer_existing_question
    when '4'
      survey_report
    when '5'
      find_respondent
      take_survey
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
  puts "Please enter your multiple choice question, then you will be prompted for possible answers"
  question = gets.chomp
  new_question = Question.new(:name => question, :survey_id => @current_survey.id)
  new_question.save
  @current_question = new_question
  add_answer
  add_another("add_question")
end

def add_answer
  puts "Please enter a possible answer for #{@current_question.name}"
  answer = gets.chomp
  new_answer = Answer.new(:name => answer, :question_id => @current_question.id)
  new_answer.save
  puts "You have added #{new_answer.name} to #{@current_question.name}"
  add_another('add_answer')
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

def add_answer_existing_question
  puts "To be built"
  # puts "First select a survey"
  # surveys = Survey.all
  # surveys.each_with_index { |survey, index| puts "#{index + 1}. #{survey.name}"}
  # selection = gets.chomp.to_i
  # @current_survey = surveys[selection - 1]

end

def survey_report
  puts "Select a survey to see the results"
  surveys = Survey.all
  surveys.each_with_index { |survey, index| puts "#{index + 1}. #{survey.name}"}
  selection = gets.chomp.to_i
  @current_survey = surveys[selection - 1]
  @current_survey.questions.each do |question|
    puts question.name
    puts "#{question.responses.length} respondents"
    question.answers.each do |answer|
      percent = (((answer.responses.length).to_f)/((question.responses.length).to_f) * 100).round.to_i

      puts "#{answer.name} #{percent}%"
    end
  end
end

def take_survey
  puts "Select a survey to take"
  surveys = Survey.all
  surveys.each_with_index { |survey, index| puts "#{index + 1}. #{survey.name}"}
  selection = gets.chomp.to_i
  @current_survey = surveys[selection - 1]
  survey_questions = Question.where(survey_id: @current_survey.id)
  survey_questions.each do |question|
    system('clear')
    puts "#{question.name}"
    answers = Answer.where(question_id: question.id)
    answers.each_with_index do |answer, index|
      puts "#{index + 1}. #{answer.name}"
    end
    user_answer = gets.chomp.to_i
    new_response = Response.new(:answer_id => answers[user_answer -1].id, :respondent_id => @current_respondent.id)
    new_response.save
  end
  if @current_survey.id == 6
    colors = ["vermillion", "magenta", "tangerine", "framboise", "amaryllis", "periwinkle", "fuschia", "lavender", "sienna", "teal", "plum", "charcoal"]
    puts "Your aura is #{colors[rand(colors.length)]} with a whisper of #{colors[rand(colors.length)]}\n\n"
  else
    puts "\n\n Thank you for taking the survey!"
  end
end

def find_respondent
  puts "Are you a new survey taker? (y/n)"
  user_input = gets.chomp
  puts "Please enter your name:"
  name_input = gets.chomp
  if user_input == 'y'
    new_respondent = Respondent.new(:name => name_input)
    new_respondent.save
    @current_respondent = new_respondent
  else
    @current_respondent = Respondent.where(name: name_input).take
  end
end

welcome
