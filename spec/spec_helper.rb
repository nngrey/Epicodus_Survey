require 'active_record'
require 'rspec'
require 'shoulda-matchers'
require 'pry'

require './lib/survey.rb'
require './lib/question.rb'
require './lib/answer.rb'
require './lib/response.rb'
require './lib/respondent.rb'

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["test"])

RSpec.configure do |config|
  config.after(:each) do
    Survey.all.each { |survey| survey.destroy }
    Question.all.each { |question| question.destroy }
    Answer.all.each { |answer| answer.destroy }
    Response.all.each { |response| response.destroy }
    Respondent.all.each { |respondent| respondent.destroy }
  end
end
