class AddKillsToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :kills, :integer, default: 0
  end
end
