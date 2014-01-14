class AddPasswordAndSaltToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :password, :string
    add_column :players, :salt, :string
  end
end
