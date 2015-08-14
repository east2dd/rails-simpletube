class CreatePlays < ActiveRecord::Migration
  def change
    create_table :plays do |t|
      t.string :name
      t.integer :playable_id
      t.string :playable_type

      t.timestamps
    end
  end
end
