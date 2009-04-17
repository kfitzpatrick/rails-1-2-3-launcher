# add rspec and rspec-rails gem dependencies in config/environments/test.rb
gem('rspec', :lib => false, :version => ">= 1.2.4", :env => 'test')
gem('rspec-rails', :lib => false, :version => ">= 1.2.4", :env => 'test')

rake("gems", :env => "test")
generate("rspec")



#gem install term-ansicolor treetop diff-lcs nokogiri builder

# gem cucumber-0.3.0
# gem webrat-0.4.4 - http://gitrdoc.com/brynary/webrat/tree/master/

# generate("cucumber")

# config.gem "remarkable_rails", :lib => false, :version => ">= 3.0.3"
# gem remarkable_rails-3.0.3 http://github.com/carlosbrando/remarkable/tree/master

# And then require remarkable inside your spec_helper.rb, after "spec/rails":
# require 'spec/rails'
# require 'remarkable_rails'

# sudo gem install notahat-machinist --source http://gems.github.com

# faker-0.3.1 - http://faker.rubyforge.org/rdoc/
# gem install populator-0.2.5 - http://github.com/ryanb/populator/tree/master


