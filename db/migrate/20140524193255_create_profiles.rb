class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :first_name
      t.string :last_name
      t.string :description
      t.string :phone
      t.string :location
      t.string :urls
      t.string :image_loc
      t.string :role
      t.string :initials
      t.string :css_class

      t.references :user, index: true

      t.timestamps
    end
  end
end
