class CreateConsumptions < ActiveRecord::Migration[8.1]
  def change
    create_table :consumptions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :consumption_type
      t.float :value
      t.string :measure
      t.datetime :date

      t.timestamps
    end
  end
end
