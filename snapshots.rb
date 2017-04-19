# require 'bundler/setup'
require 'json'
require 'percy/capybara/anywhere'
require 'phantomjs'
require 'uri'
ENV['PERCY_DEBUG'] = '1'  # Enable debugging output.

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, :phantomjs => Phantomjs.path, :js_errors => false)
end

# Start up the static storybook build with a webserver of your choice
# Do not use the storybook dev server for this
# assets will not be guaranteed stable/stay in sync and it takes a while to boot
# up, which you need to wait for before running percy
pid = fork { require './serve.rb' }
at_exit { Process.kill('INT', pid) }

# Configuration.
server = 'http://localhost:9099'
assets_dir = File.expand_path('./storybook-static', __dir__)
assets_base_url = '/'


storybook_descriptor_file = File.read(File.expand_path('./storybook-index.json', __dir__))
storybooks = JSON.parse(storybook_descriptor_file)

Percy::Capybara::Anywhere.run(server, assets_dir, assets_base_url) do |page|
  storybooks.each do |storybook|
    selected_kind = URI::encode_www_form_component(storybook['kind'])
    storybook['stories'].each do |story|
      selected_story = URI::encode_www_form_component(story['name'])
      page.visit("/iframe.html?selectedKind=#{selected_kind}&selectedStory=#{selected_story}")
      Percy::Capybara.snapshot(page, name: "#{storybook['kind']} - #{story['name']}")
    end
  end
end
