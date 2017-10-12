require 'json'

module Workflows
  def self.HostCapture(client)
    client.do_log = true

    # Get service information to see the avilable functions.

    service_response = EvoCWS_endpoint_svcinfo.get_service_info(client)
    test_assert(service_response.data['Success'] == true, client)

    pindebit_auth_template = {
      'Transaction' => {
        'TenderData' => {
          'CardData' => {
            'CardType' => Evo::TypeCardType::MasterCard,
            'CardholderName' => nil,
            'PAN' => '5454545454545454',
            'Expire' => '1215',
            'Track2Data' => '5454545454545454=15121010134988000010'
          },
          'CardSecurityData' => {
            'KeySerialNumber' => '12345678',
            'PIN' => '1234'
          }
        },
        'TransactionData' => {
          'AccountType' => Evo::AccountType::CheckingAccount,
          'EntryMode' => Evo::EntryMode::Keyed
        }
      }
    }

    unless service_response.data['BankcardServices'].empty?

      serviceId_found = false
      workflowId_found = false
      service_response.data['BankcardServices'].each do |service|
        next if service['ServiceId'] != client.workflow_id
        # if (service["ServiceId"] != "4CACF00001") then next; end
        serviceId_found = true
        # client.workflow_id = service["ServiceId"];
      end
      service_response.data['Workflows'].each do |workflow|
        next if workflow['WorkflowId'] != client.workflow_id
        workflowId_found = true
      end
      if serviceId_found || workflowId_found
        profiles_response = EvoCWS_endpoint_merchinfo.get_merchant_profiles(client, client.service_id)
        test_assert(profiles_response.data['Success'] == true, client)
        merchId = ''
        parsed_response = JSON.parse(profiles_response.body)
        merchId = parsed_response[0]['id']

        # if (merchId == nil )
        #	p ("\n\nFAILED: Need a merchant profile for the service id: " + client.service_id);

        # Skip the service if there aren't any merchant profiles defined.

        # We only need to test one merchant profile.
        # profiles_response.data["Results"].each { |the_merchant_profile|
        #	client.merchant_profile_id = the_merchant_profile["id"];
        #	if (client.merchant_profile_id[0..7] != "Default") then break; end
        # Avoid selecting a "Default" profile, generated by SaveMerchant profile in the basic testing.
        # Fallthrough is okay. It selects the most recently created profile.

        profile = EvoCWS_endpoint_merchinfo.is_merchant_profile_initialized(client, client.merchant_profile_id, client.service_id)
        test_assert(profile.data['Success'] == true, client)

        ####################

        if RbConfig::UseWorkflow == true
          authorized_response = EvoCWS_endpoint_txn.authorize_encrypted(client, {})
        else
          authorized_response = EvoCWS_endpoint_txn.authorize(client, {})
        end
        test_assert(authorized_response.data['Success'] == true, client)
        test_assert(authorized_response.data['Status'] != 'Failure', client)

        captured_response = EvoCWS_endpoint_txn.capture(client,
          'DifferenceData' => {
            "\type" => 'BankcardCapture,http://schemas.evosnap.com/CWS/v2.0/Transactions/Bankcard',
            'Amount' => '10.00',
            'TransactionId' => authorized_response.data['TransactionId'],
            'TipAmount' => '0.00'
          }
        )

        if RbConfig::UseWorkflow == true
          captured_response = EvoCWS_endpoint_txn.authorize_and_capture_encrypted(client, {})
        else
          captured_response = EvoCWS_endpoint_txn.authorize_and_capture(client, {})
        end
        captured_response = EvoCWS_endpoint_txn.authorize_and_capture(client, {})
        test_assert(captured_response.data['Success'] == true, client)
        test_assert(captured_response.data['Status'] != 'Failure', client)

        response = EvoCWS_endpoint_txn.return_by_id(client,
          'DifferenceData' => {
            'TransactionId' => captured_response.data['TransactionId']
          }
        )

        if RbConfig::UseWorkflow == true
          authorized_response = EvoCWS_endpoint_txn.authorize_encrypted(client, {})
        else
          authorized_response = EvoCWS_endpoint_txn.authorize(client, {})
        end
        test_assert(authorized_response.data['Success'] == true, client)
        test_assert(authorized_response.data['Status'] != 'Failure', client)

        response = EvoCWS_endpoint_txn.undo(client,
          'DifferenceData' => {
            'TransactionId' => authorized_response.data['TransactionId']
          }
        )

        if RbConfig::UseWorkflow == true
          response = EvoCWS_endpoint_txn.return_unlinked_encrypted(client, {})
        else
          response = EvoCWS_endpoint_txn.return_unlinked(client, {})
        end
        response = EvoCWS_endpoint_txn.return_unlinked(client, {})
      end
    end
  end
end
