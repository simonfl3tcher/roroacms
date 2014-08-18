# desc "Explaining what the task does"
namespace :roroacms do 
	namespace :db do 
		task :seed do
		  Roroacms::Engine.load_seed
		end
	end
end

