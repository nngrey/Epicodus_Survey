class ChangeQuestionIdToAnswerId < ActiveRecord::Migration
  def change
    rename_column :responses, :question_id, :answer_id
  end
end
