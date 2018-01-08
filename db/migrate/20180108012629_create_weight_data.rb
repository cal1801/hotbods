class CreateWeightData < ActiveRecord::Migration
  def change
    create_table :weight_data do |t|
      t.float :weight
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
