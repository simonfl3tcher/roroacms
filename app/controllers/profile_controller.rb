class ProfileController < ApplicationController

	before_filter :authorize
		
	def index
		# @profile = Time.now
	end

end