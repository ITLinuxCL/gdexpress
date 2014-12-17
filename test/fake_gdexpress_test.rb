require 'test_helper'

class GdexpressTest < MiniTest::Test
  
  def setup
    @api_host = "gdbox.itlinux.cl"
    @api_key = "123456"
    stub_request(:any, /#{@api_host}/).to_rack(FakeGdExpress)
    
    @gd_client = Gdexpress::Client.new(
          api_token: "42AD15D8-5104-46E5-A772-6D7A52D02DF4",
          dte_box: @api_host,
          environment: :testing
        )
    @rut_emisor = "76424135-5"
    @tipo_dte = 33
  end
  
  def test_should_return_access_denid_if_not_authkey_present
    uri = URI("http://#{@api_host}/api/Core.svc/Core/FiscalStatus/T/76424135-5/33/28")
    response = Nokogiri::XML(open(uri))
    assert_equal("1", response.at_css("Result").children.text)
    assert_equal("AccesoDenegado", response.at_css("Description").children.text)
  end
  
  def test_should_return_access_denid_if_authkey_incorrect
    uri = URI("http://#{@api_host}/api/Core.svc/Core/FiscalStatus/T/76424135-5/33/28")
    response = Nokogiri::XML(open(uri, "AuthKey" => "122"))
    assert_equal("1", response.at_css("Result").children.text)
    assert_equal("AccesoDenegado", response.at_css("Description").children.text)
  end
  
  def test_fake_gdexpress_works
    uri = URI("http://#{@api_host}/api/Core.svc/Core/FiscalStatus/T/76424135-5/33/28")
    response = Nokogiri::XML(open(uri, "AuthKey" => "123456"))
    assert_equal("0", response.at_css("Status").children.text)
  end
  
  def test_fake_gdexpress_return_not_found
    uri = URI("http://#{@api_host}/api/Core.svc/Core/FiscalStatus/T/76424135-5/33/55")
    response = Nokogiri::XML(open(uri, "AuthKey" => "123456"))
    assert_equal("14", response.at_css("Result").children.text)
  end
  
end