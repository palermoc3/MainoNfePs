class CreateDocuments < ActiveRecord::Migration[7.2]
  def change
    create_table :documents do |t|
      t.string :serie
      t.string :nNF
      t.datetime :dhEmi
      t.string :emit_cnpj
      t.string :emit_xNome
      t.string :dest_cnpj
      t.string :dest_xNome

      t.timestamps
    end
  end
end
