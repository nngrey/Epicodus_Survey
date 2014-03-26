class DeleteResponseName < ActiveRecord::Migration
  def change
    remove_column :responses, :name
  end
end
