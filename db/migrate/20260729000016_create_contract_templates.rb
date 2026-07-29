class CreateContractTemplates < ActiveRecord::Migration[7.1]
  def change
    create_table :contract_templates do |t|
      t.string :name, null: false
      t.text :content, null: false
      t.boolean :is_default, default: false
      t.text :description

      t.timestamps
    end
  end
end
