RSpec.describe 'Session', type: :request do
  let(:headers) do
    {
      'x-encoded-api-key' => ENV['ENCODED_API_KEY'],
      'X-RapidAPI-Proxy-Secret' => ENV['ENCODED_PROXY_SECRET']
    }
  end

  before(:each) do
    Rails.cache.clear
  end

  it 'creates a 128 code' do
    post '/encoded/api',
         params: {
           codes: [
             {
               type: 'code_128b',
               data: 'This is a test',
               format: 'raw_base_64'
             }
           ]
         },
         headers: headers
    expect(response.status).to eq 200
    body = JSON.parse(response.body)
    expect(Base64.strict_decode64(body['codes'].first['raw_base_64']).force_encoding('UTF-8')).to \
      eq IO.read(file_fixture('test_128.png'))
  end

  it 'creates a qr code' do
    post '/encoded/api',
         params: {
           codes: [
             {
               type: 'qr_code',
               data: 'This is a test',
               format: 'raw_base_64'
             }
           ]
         },
         headers: headers
    expect(response.status).to eq 200
    body = JSON.parse(response.body)
    expect(Base64.strict_decode64(body['codes'].first['raw_base_64']).force_encoding('UTF-8')).to \
      eq IO.read(file_fixture('test_qr.png'))
  end

  it 'creates a 25 code' do
    post '/encoded/api',
         params: {
           codes: [
             {
               type: 'code_25',
               data: '1234567890',
               format: 'raw_base_64'
             }
           ]
         },
         headers: headers
    expect(response.status).to eq 200
    body = JSON.parse(response.body)
    expect(Base64.strict_decode64(body['codes'].first['raw_base_64']).force_encoding('UTF-8')).to \
      eq IO.read(file_fixture('test_25.png'))
  end

  it 'responds with error when asking for not implemented type' do
    post '/encoded/api',
         params: {
           codes: [
             {
               type: 'foo',
               data: '12345'
             }
           ]
         },
         headers: headers
    expect(response.status).to eq 501
    body = JSON.parse(response.body)
    expect(body['error']).to eq('foo is not an implemented encoder')
  end

  it 'responds with error when asking for not implemented format' do
    post '/encoded/api',
         params: {
           codes: [
             {
               type: 'code_128b',
               data: '12345',
               format: 'png'
             },
             {
               type: 'code_128b',
               data: '12345',
               format: 'foo'
             }
           ]
         },
         headers: headers
    expect(response.status).to eq 501
    body = JSON.parse(response.body)
    expect(body['error']).to eq('foo is not an implemented format')
  end

  it 'responds with error when requsting more than limit' do
    limit = ENV['ENCODED_REQUEST_LIMIT'].to_i
    post '/encoded/api',
         params: {
           codes: (limit + 1).times.map do |_time|
             {
               type: 'code_128b',
               data: '12345',
               format: 'png'
             }
           end
         },
         headers: headers
    expect(response.status).to eq 422
    body = JSON.parse(response.body)
    expect(body['error']).to eq("#{limit + 1} codes is greater than the request limit of #{limit}")
  end

  it 'requests an html barcode' do
    post '/encoded/api',
         params: {
           codes: [
             {
               type: 'code_128b',
               data: 'This is a test 123456',
               format: 'html'
             }
           ]
         },
         headers: headers
    expect(response.status).to eq 200
    body = JSON.parse(response.body)
    expect(body['codes'].first['html']).to \
      eq IO.read(file_fixture('test_128.html'))
  end

  it 'requests an svg barcode' do
    post '/encoded/api',
         params: {
           codes: [
             {
               type: 'code_93',
               data: '1234567890',
               format: 'svg'
             }
           ]
         },
         headers: headers
    expect(response.status).to eq 200
    body = JSON.parse(response.body)
    expect(body['codes'].first['svg']).to \
      eq IO.read(file_fixture('test_93.svg'))
  end
end

# File.open('test_qr.png', 'w') do |f|
#   f.write Base64.strict_decode64(body['codes'].first['base_64']).force_encoding('UTF-8')
# end
