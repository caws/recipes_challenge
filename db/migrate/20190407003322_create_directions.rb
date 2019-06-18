class CreateDirections < ActiveRecord::Migration[5.2]
  def change
    create_table :directions do |t|
      t.integer :step
      t.string :description
      t.references :recipe, foreign_key: true

      t.timestamps
    end
  end
end
