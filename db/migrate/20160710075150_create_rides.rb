class CreateRides < ActiveRecord::Migration[5.0]
  def change
    create_table :rides do |t|
      t.integer :user_id
      t.integer :cab_id
      t.float :source_latitude
      t.float :source_longitude
      t.float :destination_latitude
      t.float :destination_longitude
      t.string :duration
      t.float :distance
      t.float :amount
      t.boolean :is_canceled,default:false
      t.boolean :is_done,default:false

      t.timestamps
    end
  end
end
