RSpec.describe 'Session', type: :request do
  it 'makes a request' do
    get '/'
    expect(response.body).to include 'Rails'
  end
end