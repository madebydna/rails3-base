# rails new my_app -J -T -m http://github.com/madebydna/rails3-base/raw/master/app.rb

rvmrc = <<-RVMRC
rvm_gemset_create_on_use_flag=1
rvm gemset use #{app_name}
RVMRC

create_file ".rvmrc", rvmrc

empty_directory "lib/generators"
git :clone => "--depth 0 http://github.com/madebydna/rails3-base.git lib/generators"
remove_dir "lib/generators/.git"

gem "factory_girl_rails", ">= 1.0.0", :group => :test
gem "haml", ">= 3.0.12"
gem "rspec-rails", ">= 2.0.0.beta.12", :group => :test

generators = <<-GENERATORS
    config.generators do |g|
      g.template_engine :haml
      g.test_framework :rspec, :fixture => true, :views => false
      g.fixture_replacement :factory_girl, :dir => "spec/factories"
      g.stylesheets false
    end
GENERATORS

application generators

git :submodule => "add git://github.com/rails/jquery-ujs.git public/javascripts/jquery-ujs"
git :submodule => "init"
git :submodule => "update"
get "http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js",  "public/javascripts/jquery-1.4.2.js"

application "config.action_view.javascript_expansions[:defaults] = ['jquery-1.4.2', 'jquery-ujs/src/rails']"

layout = <<-LAYOUT
!!!
%html
  %head
    %title #{app_name.humanize}
    = stylesheet_link_tag :all
    = javascript_include_tag :defaults
    = csrf_meta_tag
  %body
    = yield
LAYOUT

remove_file "app/views/layouts/application.html.erb"
create_file "app/views/layouts/application.html.haml", layout

create_file "log/.gitkeep"
create_file "tmp/.gitkeep"

git :init
git :add => "."

docs = <<-DOCS

Run the following commands to complete the setup of #{app_name.humanize}:

% cd #{app_name}
% gem install bundler --pre
% bundle install
% script/rails generate rspec:install

DOCS

log docs
