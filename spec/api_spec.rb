require 'spec_helper'

describe Transitmix::API do
  include Rack::Test::Methods

  def app
    Transitmix::API
  end

  describe 'GET /api/lines/:id' do
    let(:line) { create(:line) }

    it 'returns 200 OK status' do
      get "/api/lines/#{line.id}"
      expect(last_response.status).to eq 200
    end

    it 'returns the record' do
      get "/api/lines/#{line.id}"
      expect(last_response.body).to eq line.to_json
    end
  end

  describe 'POST /api/lines' do
    let(:params) { attributes_for(:line) }

    it 'returns 201 CREATED status' do
      post '/api/lines', params
      expect(last_response.status).to eq 201
    end

    it 'creates a new record' do
      expect { post '/api/lines', params }.to change{ Line.count }.by(+1)
    end
  end

  describe 'GET /api/lines' do
    it 'returns 200 OK status' do
      get '/api/lines'
      expect(last_response.status).to eq 200
    end

    it 'returns the list of lines' do
      lines = create_list(:line, 5)
      get '/api/lines', per: 2
      expect(last_response.body).to eq [lines[4], lines[3]].to_json
    end
  end
end
