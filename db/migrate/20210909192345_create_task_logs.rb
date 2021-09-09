class CreateTaskLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :task_logs do |t|
      t.references :task, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.decimal :duration_minutes

      t.timestamps
    end
  end
end
