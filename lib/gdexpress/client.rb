require 'nokogiri'

module Gdexpress
  class Client
    
    CONFIG_OPTIONS = [:api_token, :dte_box, :environment]
    API_ENDPOINTS = {
      fiscal_status: "/api/Core.svc/Core/FiscalStatus/",
      tracking: "/api/Core.svc/Core/Tracking/",
      recover_pdf: "/api/Core.svc/Core/RecoverPdf/",
      recover_xml: "/api/Core.svc/Core/RecoverXml/",
    }
    
    GDE_STATUS_CODES = {
      processed: 0,
      processing_dte: 1,
    }
    
    attr_accessor :api_token, :dte_box, :environment
    
    def initialize(config = {})
      set_config(config)
    end
    
    def find_dte(params = {})      
      raise ArgumentError, "Missing config param" unless config_params_valid?(params, [:rut_emisor, :tipo_dte, :folio])
      Gdexpress::Dte.new params
    end
    
    def processed?(dte)
      begin
        response = fiscal_status dte  
      rescue DTENotFound => e
        # Si no lo encontramos puede que aun haya llegado a
        # GDexpress Cloud, por eso decimos que no se ha procesado
        return false
      end
      
      # Estamos confiando que GDexpress devuelve Status = 1
      # mientras se espera respuesta de SII
      return false if response[:status].to_i == GDE_STATUS_CODES[:processing_dte]
      true
    end
    
    def accepted?(dte)
      response = fiscal_status(dte)
      response[:status].to_i == GDE_STATUS_CODES[:processed]
    end
    
    def fiscal_status(dte)
      response = get "fiscal_status", dte
      response
    end
    
    def tracking(dte)
      response = get "tracking", dte
      response
    end
    
    def recover_pdf_base64(dte)
      response = get "recover_pdf", dte
      response[:data]
    end
    
    def recover_xml(dte)
      response = get "recover_xml", dte
      response
    end
    
    private
    
    def set_config(config)
      raise ArgumentError, "Missing config param" unless config_params_valid?(config, CONFIG_OPTIONS)
      config.each do |k,v|
        instance_variable_set "@#{k}".to_sym, v
      end
    end
    
    def config_params_valid?(config, requirements)
      options = requirements.clone
      options.keep_if {|o| !config[o].nil? }
      options.size == requirements.size
    end
    
    def get(method, dte)
      uri = make_uri dte, method
      response = parse_xml Nokogiri::XML(open(uri, "AuthKey" => api_token))
      raise AccessDenied, "Invalid AuthKey" if response[:description] == "AccesoDenegado"
      raise DTENotFound, "DTE Not Found" if response[:result] == "14"
      raise GdeFailledCall, "API Call failed" if response[:result] != "0"
      response
    end
    
    def make_uri(dte, method)
      base_uri = "http://#{dte_box}#{API_ENDPOINTS[method.to_sym]}/#{environment}/"

      # Se tiene que poner 2 veces el rut cuando se pide PDF o XML
      # según lo que sale en http://IP_GD_BOX/api/Core.svc/core/help
      base_uri << dte.rut_emisor if method.match(/^recover_/)
      base_uri << "#{dte.rut_emisor}/#{dte.tipo_dte}/#{dte.folio}"
      URI base_uri
    end
    
    def parse_xml(nokogiri_xml)
      hash = {}
      [:status, :result, :description, :data].each do |field|
         next if nokogiri_xml.at_css(field.to_s.capitalize).nil?
         hash[field] = nokogiri_xml.at_css(field.to_s.capitalize).children.text
      end
      hash
    end
    
  end
end