class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :module
      t.string :task_title
      t.datetime :started
      t.datetime :finished
      t.string :done_by
      t.string :test_by
      t.string :status

      t.timestamps
    end
  end
end
