require 'uri'
require 'csv'
class CompaniesController < ApplicationController
  before_action :set_driver, only: %i[scrape]
  def scrape
    @n = params[:records].to_i
    url = "#{base_url}/companies?#{query_params()}"
    @company_details = []
    $driver.get(url)
    $wait.until { $driver.execute_script("return document.readyState") == "complete" }
    sleep 2;
    doc = Nokogiri::HTML($driver.page_source)
    companies = doc.css('._section_86jzd_146 ._company_86jzd_338')
    companies.each do |company|
      data = scrape_attributes(company)
      details_url = base_url+company.attribute_nodes.last.value
      data = get_company_details(details_url,data)
      @company_details << data
      break if @company_details.size >= @n
    end
    $driver.quit
    if @company_details.any?
      render json: { download_csv_url:generate_csv(@company_details),company_details: @company_details,status:200 }, status: :ok
    else
      render json: { message:'Not Found Records',company_details: [],status:404 }, status: :not_found
    end
  end
  private
  def base_url
    "https://www.ycombinator.com"
  end
  def set_driver
    options = Selenium::WebDriver::Chrome::Options.new(args: ['headless'])
    $driver = Selenium::WebDriver.for(:chrome, options: options)
    # Set implicit wait, script timeout, and page load timeout to a minimum of 20 seconds
    timeout_duration = 10
    $driver.manage.timeouts.implicit_wait = timeout_duration
    $driver.manage.timeouts.script_timeout = timeout_duration
    $driver.manage.timeouts.page_load = timeout_duration
    $wait = Selenium::WebDriver::Wait.new(timeout: timeout_duration, interval: 2)
  end
  def query_params
    query_params = URI.encode_www_form(set_filters)
    return query_params
  end
  def scrape_attributes(company)
    {
      name: company.at_css('._coName_86jzd_453')&.text,
      location: company.at_css('._coLocation_86jzd_469')&.text,
      short_description: company.at_css('._coDescription_86jzd_478')&.text,
      yc_batch: company.at_css('._pillWrapper_86jzd_33 ._pill_86jzd_33')&.text
    }
  end
  def get_company_details(url,data)
    founder_arr = []
    $driver.get(url)
    $wait.until { $driver.execute_script("return document.readyState") == "complete" }
    sleep 1;
    doc = Nokogiri::HTML($driver.page_source)
    data['company_url'] = doc.css('.ycdc2')&.at_css('div section div.my-8.mb-4')&.at_css('div a.mb-2')&.children&.last&.text
    doc.css('div.mx-auto.max-w-ycdc-page div.shrink-0 div.flex').each do |founder|
      temp_data = { name: founder.children[1].children.first.text, linked_in_url:founder.children[1].children.last.children.last&.attribute_nodes&.first&.value}
      founder_arr << temp_data
    end
    data['founders'] = founder_arr
    return data
  end
  def set_filters
    params.require(:filters).permit(:batch,:industry,:region,:tags,:team_size,:highlight_women,:highlight_latinx,:highlight_black,:top_company,:isHiring,:nonprofit,:app_video_public,:demo_day_video_public,:app_answers).to_h
  end
  def generate_csv(data)
    time_stamp = Time.now.to_i
    csv_file_path = Rails.root.join('public', "company_details_#{time_stamp}.csv")
    CSV.open(csv_file_path, "wb") do |csv|
      csv << ["Name", "Location", "Short Description", "YC Batch", "Company URL", "Founders"]
      data.each do |company|
        founders = company['founders'].map { |founder| "#{founder[:name]} (LinkedIn: #{founder[:linked_in_url]})" }.join("; ")
        csv << [
          company[:name],
          company[:location],
          company[:short_description],
          company[:yc_batch],
          company['company_url'],
          founders
        ]
      end
    end
    "#{request.base_url}/company_details_#{time_stamp}.csv"
  end

end
