class CreateEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :events do |t|
      t.string :title
      t.datetime :start_time
      t.datetime :end_time
      t.string :location
      t.string :weather_info
      t.references :worker, null: true, foreign_key: true  # Permitir nulos

      t.timestamps
    end
  end
end

