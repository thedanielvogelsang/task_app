class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email
      t.integer :user_role

      t.timestamps
    end
  end
end
