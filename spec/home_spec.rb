require 'spec_helper'

describe Transitmix::Home do
  include Rack::Test::Methods

  def app
    Transitmix::Home
  end

  describe 'GET /' do
    it 'returns 200 OK status' do
      get '/'
      expect(last_response.status).to eq 200
    end

    it 'has a response body' do
      get '/'
      expect(last_response.body).not_to be_empty
    end
  end
end
