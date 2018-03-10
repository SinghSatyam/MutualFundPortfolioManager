class Investment < ActiveRecord::Base
	validates_presence_of :scheme_code,:amount,:investment_date
	after_create :calculate_unit_allotted
	
	def calculate_unit_allotted
		if(nav_on_investment_date.present?)
			units=amount/nav_on_investment_date
			self.update(:units_allotted=>units)
		end
	end

	def scheme_name
		MutualFundNavMaster.find_by(:scheme_code=>self.scheme_code).scheme_name
	end

	def self.present_investment_value
		Investment.all.map(&:current_value).sum
	end

	def current_value
		begin
			(self.units_allotted*present_nav).round(2)
		rescue
			0
		end
	end

	def present_nav
		MutualFundNavMaster.where(:scheme_code=>self.scheme_code).order('date ASC').last.nav
	end

	def nav_on_investment_date
		nav=MutualFundNavMaster.find_by(:date=>self.investment_date,:scheme_code=>self.scheme_code).try(:nav)
		unless nav.present?
			if nav_of_greater_date.present?
				nav=nav_of_greater_date.order('date ASC').first.nav
			else
				nav=try_fetching_and_retry_getting_nav
			end
		end
		return nav
	end

	def nav_of_greater_date
		MutualFundNavMaster.where(:scheme_code=>self.scheme_code).where("date > ?", self.investment_date)
	end

	def try_fetching_and_retry_getting_nav
		try_fetching_nav
		nav=nil
		if nav_of_greater_date.present?
				nav=nav_of_greater_date.order('date ASC').first.nav
		else
			mark_as_unprocessed
		end
		return nav
	end

	def try_fetching_nav
		FetchDataService.new.fetch_data(MutualFundNavMaster.where(:scheme_code=>self.scheme_code).order('date ASC').last.date,DateTime.now)
	end

	def mark_as_unprocessed
		self.update(:processed=>false)
	end

end
