class AddReplayParsedToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :replay_parsed, :boolean
  end
end
