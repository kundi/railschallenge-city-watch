class CreateResponder < ActiveRecord::Migration
  def change
    create_table :responders, id: false do |t|
      t.string :name, null: false, unique: true, index: true
      t.string :type, null: false
      t.integer :capacity, null: false
      t.boolean :on_duty, null: false, default: false
      t.string :emergency_code
    end
  end
end
