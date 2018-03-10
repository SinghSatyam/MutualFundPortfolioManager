class PortfoliosController < ApplicationController
	def index
		@investment=Investment.new
	end
end
