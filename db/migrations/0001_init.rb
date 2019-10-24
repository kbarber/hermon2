Sequel.migration do
  change do
    create_table(:states) do
      primary_key :id
      String :url, null: false, unique: true
      DateTime :last_state_change
      # 0 = down, 1 = up
      Integer :state
    end

    create_table(:outages) do
      primary_key :id
      foreign_key :state_id, :states
      DateTime :start_time
      DateTime :end_time
    end
  end
end
