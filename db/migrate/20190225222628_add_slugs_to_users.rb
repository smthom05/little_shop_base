class AddSlugsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :slug, :string, null: false
  end
end
