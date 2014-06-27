class CreateHolidays < ActiveRecord::Migration
  def change
    create_table :holidays do |t|
      t.string :day_str
      t.string :description
    end
  end
end
