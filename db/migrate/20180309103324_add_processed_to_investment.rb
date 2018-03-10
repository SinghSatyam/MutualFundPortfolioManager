class AddProcessedToInvestment < ActiveRecord::Migration
  def change
  	add_column :investments, :processed, :boolean, default: true
  end
end
