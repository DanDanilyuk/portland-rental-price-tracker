def change
  add_column(:apartments, :date_posted, :string)
  add_column(:apartments, :garage, :boolean)
end
