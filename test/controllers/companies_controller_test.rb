require 'test_helper'

class CompaniesControllerTest < ActionDispatch::IntegrationTest
  test "should get scrape" do
    get companies_scrape_url
    assert_response :success
  end

end
