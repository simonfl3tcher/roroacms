module GoogleAnalyticsHelper

	def get_google_data

		ga = Gattica.new({
		     :email => 'simonfletcher0@gmail.com',
		     :password => 'cherylcole18'
		})

		# Get a list of accounts
		accounts = ga.accounts

		# Choose the first account
		ga.profile_id = accounts.first.profile_id

		# Get the data
		data = ga.get({
		    :start_date   => '2011-01-01',
		    :end_date     => '2013-04-01',
		    :dimensions   => ['month', 'year'],
		    :metrics      => ['visits'],
		})

		data = data.to_h['points']

		# Show the data
		return data.inspect
	end
#   Login
# # ga = Gattica.new({
# #     :email => 'simonfletcher0@gmail.com',
# #     :password => 'cherylcole18'
# # })

# # Get a list of accounts
# # accounts = ga.accounts

# # Choose the first account
# # ga.profile_id = accounts.first.profile_id

# # Get the data
# data = ga.get({
#     :start_date   => '2011-01-01',
#     :end_date     => '2011-04-01',
#     :dimensions   => ['month', 'year'],
#     :metrics      => ['visits', 'bounces'],
# })

# Show the data
#  puts data.inspect


# Sorting by number of visits in descending order (most visits at the top)
#  data = ga.get({
#      :start_date   => '2011-01-01',
#      :end_date     => '2011-04-01',
#      :dimensions   => ['month', 'year'],
#      :metrics      => ['visits'],
#      :sort         => ['-visits']
#  })


# Return visits and bounces for mobile traffic 
# (Google's default user segment gaid::-11)

#  mobile_traffic = ga.get({
#    :start_date   => '2011-01-01',
#    :end_date     => '2011-02-01',
#    :dimensions   => ['month', 'year'],
#    :metrics      => ['visits', 'bounces'],
#    :segment      => 'gaid::-11'
#  })


# Filter by Firefox users
#  firefox_users = ga.get({
#    :start_date   => '2010-01-01',
#    :end_date     => '2011-01-01',
#    :dimensions   => ['month', 'year'],
#    :metrics      => ['visits', 'bounces'],
#    :filters      => ['browser == Firefox']
#  })

# Filter where visits is >= 10000
#  lots_of_visits = ga.get({
#    :start_date   => '2010-01-01',
#    :end_date     => '2011-02-01',
#    :dimensions   => ['month', 'year'],
#    :metrics      => ['visits', 'bounces'],
#    :filters      => ['visits >= 10000']
#  })


# Get the top 25 keywords that drove traffic
#  data = ga.get({
#    :start_date => '2011-01-01',
#    :end_date => '2011-04-01',
#    :dimensions => ['keyword'],
#    :metrics => ['visits'],
#    :sort => ['-visits'],
#    :max_results => 25
#  })

# Output our results
#  data.points.each do |data_point|
#    kw = data_point.dimensions.detect { |dim| dim.key == :keyword }.value
#    visits = data_point.metrics.detect { |metric| metric.key == :visits }.value
#    puts "#{visits} visits => '#{kw}'"
#  end

# =>
#   19667 visits => '(not set)'
#   1677 visits => 'keyword 1'
#   178 visits => 'keyword 2'
#   165 visits => 'keyword 3'
#   161 visits => 'keyword 4'
#   112 visits => 'keyword 5'
#   105 visits => 'seo company reviews'
#   ...


end
