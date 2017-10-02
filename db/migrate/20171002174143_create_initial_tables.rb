class CreateInitialTables < ActiveRecord::Migration[5.1]
  def change
    create_table(:users) do |t|
      t.column(:email, :string)
      t.column(:password, :string)
      t.column(:username, :string)
    end
    create_table(:apartments_users) do |t|
      t.column(:apartment_id, :integer)
      t.column(:user_id, :integer)
    end
    create_table(:apartments) do |t|
      t.column(:url, :string)
      t.column(:location, :string)
      t.column(:quadrant, :string)
      t.column(:price, :integer)
      t.column(:rooms, :integer)
      t.column(:sq_ft, :integer)
      t.column(:date, :date)

      t.timestamp
    end
  end
end
