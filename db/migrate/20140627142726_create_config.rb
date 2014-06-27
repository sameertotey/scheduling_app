class CreateConfig < ActiveRecord::Migration
  def change
    create_table :configs do |t|
      t.integer :num_docs_friday
      t.integer :max_num_full_days
      t.integer :max_initial_shifts
      t.boolean :friday_full_shift
    end
  end
end
