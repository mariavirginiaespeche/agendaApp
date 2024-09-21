class ChangeWorkerIdTypeInEvents < ActiveRecord::Migration[7.2]
  def change
    change_column :events, :worker_id, :string, null: true  # Permitir nulos
  end
end
