module RoroaHelper

	def children_loop hash = nil, type = nil
		
		abort '123123412'
	end

	def is_numeric?(obj) 
	   obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
	end


end