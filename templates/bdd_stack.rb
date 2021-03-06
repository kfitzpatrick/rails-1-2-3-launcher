# All gems are added to config/environments/test.rb and installed to the system if not already installed.

gem 'annotate-models', :version => '>=1.0.4', :lib => false, :env => 'development'

gem 'ZenTest', :version => ">=4.1.4", :env => 'test'
gem 'mocha', :version => '>=0.9.5', :env => 'test'

gem 'rspec', :lib => false, :version => ">= 1.2.9", :env => 'test'
gem 'rspec-rails', :lib => false, :version => ">= 1.2.9", :env => 'test'


rake "gems:install", :env => "test", :sudo => true
generate "rspec"

git :add => "."
git :commit => "-m 'added rspec dependency to test environment'"

# Cucumber gem dependencies
gem 'term-ansicolor', :lib => false, :version =>  ">=1.0.4", :env => "test"
%w{treetop diff-lcs nokogiri builder}.each do |package|
  gem package, :lib => false, :env => 'test'
end

gem 'cucumber', :version => ">= 0.4.2", :env => 'test'
gem 'webrat', :version => ">= 0.5.3", :env => 'test'
rake "gems:install", :env => "test", :sudo => true
generate "cucumber" 

gsub_file('features/support/env.rb', 'ENV["RAILS_ENV"] ||= "cucumber"', 'ENV["RAILS_ENV"] ||= "test"') 

git :add => "."
git :commit => "-m 'added cucumber and webrat dependencies to test environment'"

gem 'remarkable_rails', :lib => false, :version => ">= 3.1.11", :env => 'test'
file_inject 'spec/spec_helper.rb', "require 'spec/rails'", "require 'remarkable_rails'"

git :add => "."
git :commit => "-m 'added remarkable-rails to test environment'"

gem 'bmabey-email_spec', :version => '>= 0.3.4', 
                         :lib => 'email_spec', 
                         :source => 'http://gems.github.com',
                         :env => 'test'
file_inject 'features/support/env.rb', "require 'cucumber/rails/world'", "require 'email_spec/cucumber'"                          
file_inject 'spec/spec_helper.rb', 
            "require 'remarkable_rails'", 
            "require 'email_spec/helpers' \nrequire 'email_spec/matchers'"
file_inject 'spec/spec_helper.rb', 
            'Spec::Runner.configure do |config|',  
            "  config.include(EmailSpec::Helpers) \n  config.include(EmailSpec::Matchers)"           

rake "gems:install", :env => "test", :sudo => true                         
generate :email_spec

git :add => "."
git :commit => "-m 'added email_spec dependency to test environment'"

gem 'random_data', :version => '>=1.5.0', :env => 'test'
gem 'faker', :version => '>=0.3.1', :env => 'test'
rake "gems:install", :env => "test", :sudo => true

git :add => "."
git :commit => "-m 'added faker and random_data as dependencies to test environment'"


gem 'machinist', :lib => 'machinist', :source => "http://gems.github.com", :env => 'test', :version => ">=1.0.5"
rake "gems:install", :env => "test", :sudo => true
file_inject 'spec/spec_helper.rb', 
            "require 'email_spec/matchers'", 
            "require File.expand_path(File.dirname(__FILE__) + '/blueprints')"
file_inject 'spec/spec_helper.rb',
            'config.include(EmailSpec::Matchers)', 
            '  config.before(:each) { Sham.reset(:before_each) }'
file_inject 'features/support/env.rb',
            "require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')",
            "require File.join(RAILS_ROOT, 'spec', 'blueprints')"
file_append('config/environments/cucumber.rb', "config.gem 'bmabey-email_spec', :lib => 'email_spec', :version => '>= 0.3.4'")             
            
file 'spec/blueprints.rb' do
<<-CODE
# encoding: utf-8
require 'machinist/active_record'
require 'sham'
require 'faker'
require 'random_data'

# In Textmate use: http://github.com/drnic/ruby-machinist-tmbundle/
# Consider a BlogPost that has many BlogComments in a blog app. If you go to your blueprints.rb file, type "BlogPost" 
# and press "Cmd+B" the bundle will load up the BlogPost class, inspect it, and generate the following a blueprint.

# Shams
# We use faker to make up some test data

Sham.define do
  name                               { Faker::Name.name } 
  first_name                         { Faker::Name.first_name } 
  last_name                          { Faker::Name.last_name }
  login                              { Faker::Internet.user_name.gsub('.', '') }
  username                           { Faker::Internet.user_name.gsub('.', '') }
  email                              { Faker::Internet.email }
  company_name                       { Faker::Company.name } 
  title                              { Faker::Lorem.sentence }
  text                               { Faker::Lorem.paragraphs.join('\\n\\n') }
  body                               { Faker::Lorem.paragraphs.join('\\n\\n') }
#  picture                            { File.open Dir.glob(File.join(File.dirname(__FILE__), 'fixtures/*.jpg')).to_a.rand }
  time                               { DateTime.civil(1990 + rand(20), rand(12)+1, rand(28)+1, rand(24), rand(60), rand(60)) }
  date                               { Date.civil(1990 + rand(20), rand(12)+1, rand(28)+1) }
  percentage(:unique => false)       { rand(100) }
  price(:unique => false)            { BigDecimal.new("#{rand(1000)}.00") }
  corporate_identity_number          { ("%010d" % rand(10000000000)) }
  quantity(:unique => false)         { rand(10) + 1 }
  password(:unique => false)              { 'test1234' }
  bit(:unique => false) { rand(2) }
end
 
# Blueprints 
User.blueprint do
  email                 { Sham.email }
  password              { Sham.password }
  password_confirmation { Sham.password }
end

# Example
# User.blueprint do
#   name
#   email
# end
# 
# User.blueprint(:admin) do
#   name  { Sham.name + " (admin)" }
#   admin { true }
# end
# 
# Calling:
# User.make(:admin)
# Named blueprints call the default blueprint to set any attributes not specifically provided, so in this example 
# the email attribute will still be generated even for an admin user.

CODE
end            

git :add => "."
git :commit => "-m 'added machinist dependency to test environment'"

plugin 'time_travel', :git => 'git://github.com/notahat/time_travel.git'
file_inject('vendor/plugins/time_travel/spec/time_travel_spec.rb', "require 'time'", "require 'rubygems'")

git :add => "."
git :commit => "-m 'added time_travel dependency to test environment'"

file 'lib/tasks/populate.rake' do
<<-CODE
# encoding: utf-8

# lib/tasks/populate.rake

module Populate
  extend self
  
  def log(model)
    puts "[populate] created: <\#{model.class} \#{model.id}>"
  end
end

namespace :db do

  desc "Erase and fill database"
  task :populate => [
    'db:populate:users'
  ]

  namespace :populate do

    task :setup => :environment do
      require File.join(Rails.root, 'spec', 'blueprints')
    end

    task :users => 'db:populate:setup' do
      puts "[populate] users"
      User.delete_all
      Populate.log User.make(:password => 'test1234', :password_confirmation => 'test1234', :email => "user@test.local").confirm_email!
    end
  end

end
CODE
end

git :add => "."
git :commit => "-m 'added lib/tasks/populate.rake'"

gem 'unboxed-be_valid_asset', :version => '>= 1.1.0', 
                              :lib => 'be_valid_asset', 
                              :source => 'http://gems.github.com',
                              :env => 'test'
                         
rake "gems:install", :env => "test", :sudo => true
file_inject 'spec/spec_helper.rb',
            'config.before(:each) { Sham.reset(:before_each) }',
            '  config.include BeValidAsset'

file_inject 'spec/spec_helper.rb',
            'config.include BeValidAsset',            
            %q{  BeValidAsset::Configuration.enable_caching = true
  BeValidAsset::Configuration.cache_path = File.join(RAILS_ROOT, %w(tm p be_valid_asset_cache))
  BeValidAsset::Configuration.display_invalid_content = false (default)
  BeValidAsset::Configuration.markup_validator_host = 'validator.w3.org'
  BeValidAsset::Configuration.markup_validator_path = '/check'
  BeValidAsset::Configuration.css_validator_host = 'jigsaw.w3.org'
  BeValidAsset::Configuration.css_validator_path = '/css-validator/validator'
  BeValidAsset::Configuration.feed_validator_host = 'validator.w3.org'
  BeValidAsset::Configuration.feed_validator_path = '/feed/check.cgi'}
  
git :add => "."
git :commit => "-m 'added gem dependency be_valid_asset (end of bdd_stack)'"  



 
# # sudo gem install fakeweb fakeweb-1.2.0
# 
# #Rspec has a similar function built in. You can get benchmark info on your 10 slowest test by adding:
# #--format profile
# #to spec/spec.opts (or passing it as a command line option to the spec script).
# #http://bitfission.com/blog/2009/02/profiling-rspec.html
# 
# 
# 
# # http://github.com/jeremy/ruby-prof/tree/master
# # gem install ruby-prof
# # http://snippets.aktagon.com/snippets/255-How-to-profile-your-Rails-and-Ruby-applications-with-ruby-prof

 
 
# # http://github.com/dchelimsky/rspec-rails/blob/master/generators/rspec/templates/script/spec_server
# # http://wiki.github.com/dchelimsky/rspec/spec_server-autospec-nearly-pure-bdd-joy
# 
# 
# 
# # Needs more investigation:
# 
# #1.
# #gem 'ianwhite-pickle', :version => '>= 0.1.12', 
# #                       :lib => 'pickle', 
# #                       :source => 'http://gems.github.com', 
# #                       :env => 'test'
# #rake "gems:install", :env => "test", :sudo => true
# #
# #generate :pickle, "paths email"
# 
# #2.
# # Mocka in cucumber
# # http://gist.github.com/80554
# # http://www.brynary.com/2009/2/3/cucumber-step-definition-tip-stubbing-time
# 
# #3.
# 
# # http://www.somethingnimble.com/bliki/deep-test-1_2_0
# # http://www.somethingnimble.com/bliki/deep-test
# # http://deep-test.rubyforge.org/
# # http://wiki.github.com/aslakhellesoy/cucumber/using-rcov-with-cucumber-and-rails
# # http://github.com/langalex/culerity/tree/master - Integrates Cucumber and Celerity to test Javascript in webapps.
# # http://github.com/brynary/testjour/tree/master
# 
# # references:
# # http://www.brynary.com/2009/4/22/rack-bug-debugging-toolbar-in-four-minutes
# # http://github.com/brynary/rack-bug/tree/master
# # http://wiki.github.com/bmabey/email-spec/use-cucumber-to-test-email
# # http://wiki.github.com/bmabey/email-spec/use-cucumber-to-test-mailers-in-rails
# # http://www.benmabey.com/2009/02/05/leveraging-test-data-builders-in-cucumber-steps/
# # http://themomorohoax.com/2009/03/08/rails-machinist-tutorial-machinist-with-cucumber-in-10-minutes
