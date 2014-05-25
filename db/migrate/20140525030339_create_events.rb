class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :user, index: true
      t.date :date
      t.integer :shift
      t.string :comment
      t.references :event_type, index: true

      t.timestamps
    end
  end
end
