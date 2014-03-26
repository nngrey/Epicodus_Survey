class UpdateKeyNamesPluralToSingular < ActiveRecord::Migration
  def change
    rename_column :responses, :questions_id, :question_id
    rename_column :responses, :respondents_id, :respondent_id
    rename_column :questions, :surveys_id, :survey_id
    rename_column :answers, :questions_id, :question_id
  end
end
