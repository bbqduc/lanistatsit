class AddUsersFromJson < ActiveRecord::Migration
  def change
    s = IO.read Rails.root.join('db', 'users.json')
    users = JSON.parse s
    users["users"].each do |u|
      p = Player.find_by_name u["name"] 
      if p
        p.password = u["password"]
        p.salt = u["salt"]
        p.save
      end
    end
  end
end
