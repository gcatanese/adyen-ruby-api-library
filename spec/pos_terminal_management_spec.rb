require "spec_helper"
require "json"

# rubocop:disable Metrics/BlockLength

RSpec.describe Adyen::PosTerminalManagement, service: "PosTerminalManagement" do
  before(:all) do
    @shared_values = {
      client: create_client(:api_key),
      service: "LegalEntityManagement",
    }
  end

  # must be created manually because every field in the response is an array
  it "makes a assign_terminals POST call" do
    request_body = JSON.parse(json_from_file("mocks/requests/Terminal/assign_terminals.json"))

    response_body = json_from_file("mocks/responses/Terminal/assign_terminals.json")

    url = @shared_values[:client].service_url(@shared_values[:service], "assignTerminals", @shared_values[:client].pos_terminal_management.version)
    WebMock.stub_request(:post, url).
      with(
        body: request_body,
        headers: {
          "x-api-key" => @shared_values[:client].api_key
        }
      ).
      to_return(
        body: response_body
      )

    result = @shared_values[:client].pos_terminal_management.assign_terminals(request_body)
    response_hash = result.response

    expect(result.status).
      to eq(200)
    expect(response_hash).
      to eq(JSON.parse(response_body))
    expect(response_hash).
      to be_a Adyen::HashWithAccessors
    expect(response_hash).
      to be_a_kind_of Hash
  end

end
