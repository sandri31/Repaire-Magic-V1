class RenameUsernameToPseudoInUsers < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :username, :pseudo
  end
end
