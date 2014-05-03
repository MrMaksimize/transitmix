require 'spec_helper'

describe Transitmix::StatusAPI do
  include Rack::Test::Methods

  def app
    Transitmix::StatusAPI
  end

  describe 'GET /.well-known/status' do
    it 'returns 200 OK status' do
      get '/.well-known/status'
      expect(last_response.status).to eq 200
    end

    it 'returns the status of the application' do
      get '/.well-known/status'
      expect(last_response.body).to eq Status.new.to_json
    end
  end
end
