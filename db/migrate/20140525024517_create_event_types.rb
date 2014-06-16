class CreateEventTypes < ActiveRecord::Migration
  def change
    create_table :event_types do |t|
      t.string :name
      t.string :description
      t.string :css_class

      t.timestamps
    end
  end
end
