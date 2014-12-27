module Gdexpress
  class Dte
    attr_accessor :rut_emisor, :tipo_dte, :folio
    
    def initialize(params = {})
      set_config params
      normalize_rut
    end
    
    private
    
    def set_config(config)
      raise ArgumentError, "Missing config param" unless config_params_valid?(config, [:rut_emisor, :tipo_dte, :folio])
      config.each do |k,v|
        instance_variable_set "@#{k}".to_sym, v
      end
    end
    
    def config_params_valid?(config, requirements)
      options = requirements.clone
      options.keep_if {|o| !config[o].nil? }
      options.size == requirements.size
    end
    
    def normalize_rut
      tmp_rut = rut_emisor.gsub(/\./,"")
      tmp_rut.gsub(/k$/, "K")
    end
    
  end
end