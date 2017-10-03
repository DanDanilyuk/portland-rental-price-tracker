class ChangeApartmentsTable < ActiveRecord::Migration[5.1]
  def change
    add_column(:apartments, :bathrooms, :string)
    add_column(:apartments, :cats_allowed, :boolean)
    add_column(:apartments, :dogs_allowed, :boolean)
    add_column(:apartments, :wash_dry, :boolean)
    add_column(:apartments, :smoking_ok, :boolean)
    add_column(:apartments, :description, :string)
    add_column(:apartments, :bedrooms, :integer)

    remove_column(:apartments, :date, :date)
    remove_column(:apartments, :rooms, :integer)
  end
end
