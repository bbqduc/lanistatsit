class AddAvgGpmToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :avg_gpm, :integer, default: 0
  end
end
