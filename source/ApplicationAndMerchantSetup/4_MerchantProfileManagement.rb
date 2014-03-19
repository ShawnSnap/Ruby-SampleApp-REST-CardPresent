require 'time'
require 'open-uri'

module Evo
class MerchantManagement

    def self.get_merchant_profiles(evo_cws_client, workflow_id="")
    
    if (workflow_id == "") then
      workflow_id = evo_cws_client.workflow_id;
    end
    if (workflow_id != "") then
      params="serviceId="+URI::encode(workflow_id);
    else
        params=""
    end
        
    evo_cws_client.last_call = self.name + "::" + __method__.to_s;
        evo_cws_client.send(RbConfig::BasePath + '/svcinfo/merchprofile?'+params, nil, Net::HTTP::Get, RbConfig::BaseURL);
    end
    
    def self.get_merchant_profile(evo_cws_client, merchant_profile_id="", workflow_id="")
    
    if (workflow_id == "") then
      workflow_id = evo_cws_client.workflow_id;
    end
    if (workflow_id != "") then
      params="serviceId="+URI::encode(workflow_id);
    else
        params=""
    end
    
    if (merchant_profile_id == "") then
      merchant_profile_id = evo_cws_client.merchant_profile_id;
    end
    merchant_profile_id = URI::encode(merchant_profile_id);

    evo_cws_client.last_call = self.name + "::" + __method__.to_s;
        evo_cws_client.send(RbConfig::BasePath + '/svcinfo/merchprofile/'+merchant_profile_id+'?'+params, nil, Net::HTTP::Get, RbConfig::BaseURL);
    end
    
    
    
    def self.is_merchant_profile_initialized(evo_cws_client, merchant_profile_id = "", workflow_id="")
      
    if (workflow_id == "") then

      workflow_id = evo_cws_client.workflow_id;
    end
    if (workflow_id != "") then
      params="serviceId="+URI::encode(workflow_id);
    else
        params=""
    end
    
    if (merchant_profile_id == "") then
      merchant_profile_id = evo_cws_client.merchant_profile_id;
    end
    merchant_profile_id = URI::encode(merchant_profile_id);
    
    evo_cws_client.last_call = self.name + "::" + __method__.to_s;
        result= evo_cws_client.send(RbConfig::BasePath + '/svcinfo/merchprofile/'+merchant_profile_id+'/OK?'+params, nil, Net::HTTP::Get, RbConfig::BaseURL);

        if (result.data["RuleMessage"] == "true")
            result.data["Success"] = true;
        end
        result
    end
    
    def self.delete_merchant_profile(evo_cws_client, merchant_profile_id = "", workflow_id="")
    if (workflow_id == "") then
      workflow_id = evo_cws_client.workflow_id;
    end
    if (workflow_id != "") then
      params="serviceId="+URI::encode(workflow_id);
    else
        params=""
    end
    if (merchant_profile_id == "") then
      #false
      return
    end
    
    merchant_profile_id = URI::encode(merchant_profile_id);

    evo_cws_client.last_call = self.name + "::" + __method__.to_s;
        evo_cws_client.send(RbConfig::BasePath + '/svcinfo/merchprofile/'+merchant_profile_id+'?'+params, nil, Net::HTTP::Delete, RbConfig::BaseURL);
    end
    
    def self.save_merchant_profiles(evo_cws_client, merchant_profiles, workflow_id = "")
      
    if (workflow_id == "") then
      workflow_id = evo_cws_client.workflow_id;
    end
    if (workflow_id != "") then
      params="serviceId="+URI::encode(workflow_id);
    else
        params=""
    end
    merchant_profile_id = URI::encode(merchant_profile_id);
        
    evo_cws_client.last_call = self.name + "::" + __method__.to_s;
        evo_cws_client.send(RbConfig::BasePath + '/SvcInfo/merchProfile?'+params, merchant_profiles, Net::HTTP::Put, RbConfig::BaseURL);
    end
    
    def self.save_merchant_profile(evo_cws_client, merchant_profile, workflow_id = "")
      defaults= {
      "ProfileId" => "TestMerchant_" + workflow_id, #"Unique Value Created by your application goes here", 
      "WorkflowId" => "", # aka ServiceId
      "MerchantData" => {
        "CustomerServiceInternet" => "",
        "CustomerServicePhone" => "555 5550123",
        "Language" => "ENG",
        "Address" => {
          "Street1" => "123 Main Street",
          "Street2" => "",
          "City" => "Denver",
          "StateProvince" => "CO",
          "PostalCode" => "80202",
          "CountryCode" => "USA"
        },
        "MerchantId" => "123456789012",
        "Name" => "TestMerchant", #Business name for merchant
        "Phone" => "720 3773700",
        "TaxId" => "",
        "BankcardMerchantData" => {
          "IndustryType" => RbConfig::IndustryType,
          "SIC" => "5734",
          "TerminalId" => "123"
          
        }
      },
      "TransactionData" => {
        "BankcardTransactionDataDefaults" => {
          "CurrencyCode" => Evo::TypeISOCurrencyCodeA3::USD,
          "CustomerPresent" => RbConfig::CustomerPresent,
          "EntryMode" => RbConfig::EntryMode,
          "RequestACI" => RbConfig::RequestACI,
          "RequestAdvice" => Evo::RequestAdvice::Capable
        }
      }
    };
      
     if (workflow_id == "") then
      workflow_id = evo_cws_client.workflow_id;
    end
    if (workflow_id != "") then
      params="serviceId="+URI::encode(workflow_id);
    else
        params=""
    end  
    
    defaults["WorkflowId"] = evo_cws_client.workflow_id;
        
        merchant_profiles = Array.new
    merchant_profiles = [Evo.recursive_merge(defaults, merchant_profile)];
    
   p "WorkflowId = " + workflow_id;
            
    evo_cws_client.last_call = self.name + "::" + __method__.to_s;
        response = evo_cws_client.send(RbConfig::BasePath + '/SvcInfo/merchProfile?'+params, merchant_profiles, Net::HTTP::Put, RbConfig::BaseURL);
      
     
    end

end
end

