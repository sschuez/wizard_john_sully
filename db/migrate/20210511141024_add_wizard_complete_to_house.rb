class AddWizardCompleteToHouse < ActiveRecord::Migration[6.1]
  def change
    add_column :houses, :wizard_complete, :boolean, null: false, default: false
  end
end
