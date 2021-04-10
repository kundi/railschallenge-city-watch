class CreateEmergency < ActiveRecord::Migration
  def change
    create_table :emergencies, id: false do |t|
      t.string :code, null: false, unique: true, index: true
      t.integer :fire_severity, null: false
      t.integer :police_severity, null: false
      t.integer :medical_severity, null: false
    end
  end
end
