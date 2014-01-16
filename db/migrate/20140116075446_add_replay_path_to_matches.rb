class AddReplayPathToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :replay_path, :string
  end
end
