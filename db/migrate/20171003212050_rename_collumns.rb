class RenameCollumns < ActiveRecord::Migration[5.1]
  def change
    drop_table(:apartments)
    create_table(:apartments) do |t|
      t.column(:name, :string)
      t.column(:url, :string)
      t.column(:price, :int)
      t.column(:bed, :int)
      t.column(:bath, :int)
      t.column(:sqft, :int)
      t.column(:address, :string)
      t.column(:cat, :boolean)
      t.column(:dog, :boolean)
      t.column(:washer, :boolean)
      t.column(:smoke, :boolean)
      t.column(:garage, :boolean)
      t.column(:description, :string)
      t.column(:section, :string)
      t.column(:posted, :date)
    end
  end
end
