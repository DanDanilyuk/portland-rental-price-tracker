class DailyAverageTable < ActiveRecord::Migration[5.1]
  def change
    create_table(:averages) do |t|

      t.column(:avg_1br, :int)
      t.column(:avg_2br, :int)
      t.column(:avg_3br, :int)
      t.column(:avg_4br, :int)
      t.column(:section, :string)

      t.timestamps
    end
  end
end
