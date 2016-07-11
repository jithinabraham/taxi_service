class CreateCabs < ActiveRecord::Migration[5.0]
  def change
    create_table :cabs do |t|
      t.string :name
      t.string :color
      t.float :latitude
      t.float :longitude
      t.boolean :is_available,default:false
      t.boolean :is_deleted,default:false

      t.timestamps
    end
  end
end
