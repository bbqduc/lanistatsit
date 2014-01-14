class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :name
      t.text :password
      t.string :salt
      t.string :text

      t.timestamps
    end
  end
end
