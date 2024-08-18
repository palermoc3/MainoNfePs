class CreateTaxes < ActiveRecord::Migration[7.2]
  def change
    create_table :taxes do |t|
      t.references :document, null: false, foreign_key: true
      t.decimal :vICMS
      t.decimal :vIPI
      t.decimal :vPIS
      t.decimal :vCOFINS

      t.timestamps
    end
  end
end
