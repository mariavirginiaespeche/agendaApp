class ChangeWorkerIdNullConstraintInEvents < ActiveRecord::Migration[7.2]
  def change
    change_column_null :events, :worker_id, true
  end
end
