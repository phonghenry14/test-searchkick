class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.integer :age
      t.integer :product_id
      t.integer :position_id
      t.integer :skill_id
      t.integer :school_id
      t.integer :project_id
      t.integer :city_id

      t.timestamps null: false
    end
  end
end
