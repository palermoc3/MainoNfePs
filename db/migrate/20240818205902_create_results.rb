class CreateResults < ActiveRecord::Migration[7.2]
  def change
    create_table :results do |t|
      t.references :document, null: false, foreign_key: true
      t.decimal :tax
      t.decimal :product_value

      t.timestamps
    end
  end
end
