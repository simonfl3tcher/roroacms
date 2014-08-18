module Roroacms

	class InstallGenerator < Rails::Generators::Base

		def install 
			run 'bundle install'
			route %Q{mount Roroacms::Engine => '/'}
			rake 'db:create'
			rake 'roroacms:install:migrations'
			rake 'db:migrate'
			rake 'roroacms:db:seed'
			puts 'You are all setup! run "rails s" to check out your roroacms platform'
		end

	end

end