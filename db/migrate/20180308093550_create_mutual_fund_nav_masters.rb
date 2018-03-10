class CreateMutualFundNavMasters < ActiveRecord::Migration
  def change
    create_table :mutual_fund_nav_masters do |t|
      t.integer :scheme_code
      t.text :scheme_name
      t.float :nav
      t.date :date
    end
  end
end