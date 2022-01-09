RSpec.describe 'Session', type: :request do
  let(:headers) do
    {
      'x-rapidapi-host' => 'test',
      'x-rapidapi-key' => 'test'
    }
  end

  it 'makes a request' do
    get '/encoded/api', headers: headers
    expect(JSON.parse(response.body)).to eq []
  end

  it 'creates a 128 code' do
    post '/encoded/api',
         params: {
           codes: [
             type: 'code_128',
             data: 'This is a test'
           ]
         },
         headers: headers
    body = JSON.parse(response.body)
    expect(response.status).to eq 200
    expect(Base64.strict_decode64(body.first['base_64']).force_encoding('UTF-8')).to \
      eq IO.read(file_fixture('test_128.png'))
  end

  it 'creates a qr code' do
    post '/encoded/api',
         params: {
           codes: [
             type: 'qr_code',
             data: 'This is a test'
           ]
         },
         headers: headers
    body = JSON.parse(response.body)
    expect(response.status).to eq 200
    expect(Base64.strict_decode64(body.first['base_64']).force_encoding('UTF-8')).to \
      eq IO.read(file_fixture('test_qr.png'))
  end

  it 'creates a 25 code' do
    post '/encoded/api',
         params: {
           codes: [
             type: 'code_25',
             data: '1234567890'
           ]
         },
         headers: headers
    body = JSON.parse(response.body)
    expect(response.status).to eq 200
    expect(Base64.strict_decode64(body.first['base_64']).force_encoding('UTF-8')).to \
      eq IO.read(file_fixture('test_25.png'))
  end

  it 'responds with error when asking for not implemented type' do
    post '/encoded/api',
         params: {
           codes: [
             type: 'foo',
             data: '12345'
           ]
         },
         headers: headers
    body = JSON.parse(response.body)
    expect(response.status).to eq 501
    expect(body['error']).to eq('foo is not an implemented encoder')
  end

  it 'responds with error when asking for not implemented format' do
    post '/encoded/api',
         params: {
           codes: [
             {
               type: 'code_128',
               data: '12345',
               format: 'png'
             },
             {
               type: 'code_128',
               data: '12345',
               format: 'foo'
             }
           ]
         },
         headers: headers
    body = JSON.parse(response.body)
    expect(response.status).to eq 501
    expect(body['error']).to eq('foo is not an implemented format')
  end
end

# File.open('test_qr.png', 'w') do |f|
#   f.write Base64.strict_decode64(body['base_64']).force_encoding('UTF-8')
# end
