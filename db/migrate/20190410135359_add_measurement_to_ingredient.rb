class AddMeasurementToIngredient < ActiveRecord::Migration[5.2]
  def change
    add_column :ingredients, :measurement, :string
  end
end
