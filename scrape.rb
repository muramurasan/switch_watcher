# ref: http://blog.takuros.net/entry/2015/02/14/135255

require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'

class Scrape
  #DSLのスコープを別けないと警告がでます
  include Capybara::DSL

  def initialize
    Capybara.register_driver :poltergeist_debug do |app|
      Capybara::Poltergeist::Driver.new(app, { inspector: true, js_errors: false })
    end

    Capybara.default_driver = :poltergeist
    Capybara.javascript_driver = :poltergeist
  end

  def visit_site
    visit('https://store.nintendo.co.jp/category/NINTENDOSWITCH/')

    #スクリーンショットで保存
    # page.save_screenshot("screenshots/screenshot_#{Date.today.strftime('%Y%m%d-%H%M%S')}.png", full: true)

    html = Nokogiri::HTML.parse(page.html)
    puts "Now on sale!" unless html.css('.soldout').count > 0
  end
end

scrape = Scrape.new
scrape.visit_site
