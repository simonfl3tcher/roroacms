class Admin::Settings::MenuController < AdminController

	before_filter :authorize_admin

	def index

	end

	def sort

		abort(params.inspect)


	end


end