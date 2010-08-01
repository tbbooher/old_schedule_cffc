class CreateSchedules < ActiveRecord::Migration
  def self.up
    create_table :schedules do |t|
      t.integer :trainer_id
      t.integer :event_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :schedules
  end
end
