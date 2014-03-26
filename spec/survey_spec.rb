require 'spec_helper'

describe Survey do
  it { should have_many :questions }

  describe "questions" do
    it 'should return all questions for a survey' do
      test_survey = Survey.create(:name => "Test")
      test_question = test_survey.questions.create(:name => "Test Question")
      test_survey.questions.should eq [test_question]
    end
  end
end
