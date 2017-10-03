class AddTitleColumn < ActiveRecord::Migration[5.1]
  def change
    add_column(:apartments, :title, :string)
  end
end
