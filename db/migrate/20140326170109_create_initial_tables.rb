class CreateInitialTables < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.column :name, :string

      t.timestamps
    end

    create_table :questions do |t|
      t.column :name, :string
      t.belongs_to :surveys

      t.timestamps
    end

    create_table :respondents do |t|
      t.column :name, :string

      t.timestamps
    end

    create_table :responses do |t|
      t.column :name, :string
      t.belongs_to :questions
      t.belongs_to :respondents

      t.timestamps
    end

    create_table :answers do |t|
      t.column :name, :string
      t.belongs_to :questions

      t.timestamps
    end
  end
end
