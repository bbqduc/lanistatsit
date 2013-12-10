class AddTapiWinToMatch < ActiveRecord::Migration
  def change
    add_column :matches, :tapiwin, :boolean
  end
end
