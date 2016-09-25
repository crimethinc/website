class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :username, :email, :display_name, :password, :password_digest
      t.text :avatar

      t.timestamps
    end
  end
end
