require 'test_helper'

class GdexpressTest < MiniTest::Test
  
  def setup
    @api_host = "gdbox.itlinux.cl"
    stub_request(:any, /#{@api_host}/).to_rack(FakeGdExpress)
    
    @gd_client = Gdexpress::Client.new(
          api_token: "123456",
          dte_box: @api_host,
          environment: :testing
        )
    @rut_emisor = "76424135-5"
    @tipo_dte = 33
    @dte = Gdexpress::Dte.new(rut_emisor: @rut_emisor, tipo_dte: @tipo_dte, folio: 28)
  end
  
  def test_requests_should_raise_AccessDenied_we_are_not_allowed
    @gd_client.api_token = "123"
    assert_raises(AccessDenied) { @gd_client.fiscal_status(@dte) }
  end
  
  def test_requests_should_raise_DTENotFound_if_dte_is_not_found
    @dte.folio = 1022
    assert_raises(DTENotFound) { @gd_client.fiscal_status(@dte) }
    assert_raises(DTENotFound) { @gd_client.tracking(@dte) }
    #assert_raises(DTENotFound) { @gd_client.recover_pdf_base64(@dte) }
    #assert_raises(DTENotFound) { @gd_client.recover_xml(@dte) }
  end
  
  def test_processed_should_return_true_or_false_based_on_fiscal_status
    assert(@gd_client.processed?(@dte), "Deberia ser verdadero")
    @dte.folio = 27 # DTE malo
    assert(@gd_client.processed?(@dte), "Deberia ser verdadero")
    @dte.folio = 40 # No lo tenemos
    assert(!@gd_client.processed?(@dte), "Deberia ser falso")
  end
  
  def test_if_processed_is_true_we_have_to_check_if_it_got_accepted
    assert(@gd_client.accepted?(@dte), "Deberia haberla aceptado")
    @dte.folio = 27 # DTE malo
    assert(!@gd_client.accepted?(@dte), "Deberia ser rechazado")
  end
  
  def test_raise_api_call_failled
    gd_client = Gdexpress::Client.new(
          api_token: "123456",
          dte_box: @api_host,
          environment: :not_valid
        )
    
    assert_raises(GDEFailledCall) { gd_client.fiscal_status(@dte) }
  end
  
end