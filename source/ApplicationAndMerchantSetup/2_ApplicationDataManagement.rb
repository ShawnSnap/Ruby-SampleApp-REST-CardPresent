require 'time'
require 'open-uri'

module Evo
class ApplicationManagement

    def self.save_application_data(evo_cws_client)
        defaults = {
      "ApplicationAttended" => RbConfig::ApplicationAttended,
      "ApplicationLocation" => RbConfig::ApplicationLocation,
      "ApplicationName" => RbConfig::ApplicationName,
      "EncryptionType" => RbConfig::EncryptionType,
      "HardwareType" => Evo::HardwareType::PC,
      "PINCapability" => RbConfig::PINCapability,
      "PTLSSocketId" => RbConfig::PTLSSocketId, 
      "ReadCapability" => RbConfig::ReadCapability,
      "SerialNumber" => 208093707,
      "SoftwareVersion" => RbConfig::SoftwareVersion,
      "SoftwareVersionDate" => RbConfig::SoftwareVersionDate
        };
    

        request = defaults; #Evo.recursive_merge(defaults, request);

    evo_cws_client.last_call = self.name + "::" + __method__.to_s;
        evo_cws_client.send(RbConfig::BasePath + '/svcinfo/appprofile', request, Net::HTTP::Put, RbConfig::BaseURL);
    end

    def self.get_application_data(evo_cws_client, app_id)

    if (app_id == "") then
      app_id = evo_cws_client.application_profile_id;
      return
    end
    app_id=URI::encode(app_id);
    evo_cws_client.last_call = self.class + self.method
    
    evo_cws_client.last_call = self.name + "::" + __method__.to_s;
        evo_cws_client.send('/svcinfo/appprofile/'+app_id, nil, Net::HTTP::Get);
    end

    def self.delete_application_data(evo_cws_client, app_id)
        
    if (app_id == "") then
      #false;
      # We wont just default to deleting the main application profile.
      return;
    end
    app_id=URI::encode(app_id);

    evo_cws_client.last_call = self.name + "::" + __method__.to_s;
        evo_cws_client.send(RbConfig::BasePath + '/svcinfo/appprofile/'+app_id, nil, Net::HTTP::Delete, RbConfig::BaseURL);
    end

    def self.get_service_info(evo_cws_client)
        
    evo_cws_client.last_call = self.name + "::" + __method__.to_s;
        evo_cws_client.send(RbConfig::BasePath + '/svcinfo/serviceinformation', nil, Net::HTTP::Get, RbConfig::BaseURL);
    end
    
    
end
end

