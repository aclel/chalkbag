class CreateClimbs < ActiveRecord::Migration
  def change
    create_table :climbs do |t|
      t.string :content
      t.integer :grade
      t.integer :user_id

      t.timestamps
    end
    add_index :climbs, [:user_id, :created_at]
  end
end
