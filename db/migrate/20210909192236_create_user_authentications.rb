class CreateUserAuthentications < ActiveRecord::Migration[6.1]
  def change
    create_table :user_authentications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :password_digest
      t.integer :login_count, default: 0

      t.timestamps
    end
  end
end
