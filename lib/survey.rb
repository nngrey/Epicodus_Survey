require "pry"

class Survey < ActiveRecord::Base
  has_many :questions
end

def list_questions
  binding.pry
  Question.where(survey_id: self.id)

end

