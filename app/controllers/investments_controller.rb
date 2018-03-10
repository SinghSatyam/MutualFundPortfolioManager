class InvestmentsController < ApplicationController
	
	def create
		@investment = Investment.create(investment_params)
		render json: {:scheme_name=>@investment.scheme_name,
					  :amount=>@investment.amount,
					  :investment_date=>@investment.investment_date,
					  :units_allotted =>@investment.units_allotted,
					  :current_value =>@investment.current_value,
					  :investment_amount=>Investment.sum(:amount),
					  :total_current_value=>Investment.all.collect{|x|x.current_value}.sum
					}.as_json
	end

	private

	def investment_params
		params.require(:investment).permit(:investment_date, :amount, :scheme_code)
	end

end
