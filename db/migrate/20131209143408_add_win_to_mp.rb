class AddWinToMp < ActiveRecord::Migration
  def change
    add_column :match_participations, :win, :boolean
  end
end
