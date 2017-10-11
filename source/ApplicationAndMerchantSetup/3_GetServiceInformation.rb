require 'time'
require 'open-uri'

module Evo
  class ServiceInformation
    def self.get_service_info(evo_cws_client)
      evo_cws_client.last_call = name + '::' + __method__.to_s
      service_response = evo_cws_client.send(RbConfig::BasePath + '/SIS.svc/serviceinformation', nil, Net::HTTP::Get, RbConfig::BaseURL)
           end
        end
    end
