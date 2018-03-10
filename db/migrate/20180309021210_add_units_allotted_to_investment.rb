class AddUnitsAllottedToInvestment < ActiveRecord::Migration
  def change
  	add_column :investments, :units_allotted, :float
  end
end
