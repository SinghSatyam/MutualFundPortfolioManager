module PortfolioHelper
	def get_scheme_name_code
		MutualFundNavMaster.group(:scheme_code).collect {|m| [ m.scheme_name, m.scheme_code ] }
	end
end
