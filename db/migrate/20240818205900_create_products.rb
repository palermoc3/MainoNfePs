class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.references :document, null: false, foreign_key: true
      t.string :name
      t.string :NCM
      t.string :CFOP
      t.string :uCom
      t.decimal :qCom
      t.decimal :vUnCom

      t.timestamps
    end
  end
end
