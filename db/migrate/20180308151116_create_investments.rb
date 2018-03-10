class CreateInvestments < ActiveRecord::Migration
  def change
    create_table :investments do |t|
      t.integer :scheme_code
      t.float :amount
      t.date :investment_date
    end
  end
end
