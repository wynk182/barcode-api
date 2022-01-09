module Encoded
  class ApiController < ActionController::Base
    skip_before_action :verify_authenticity_token
    before_action :authenticate_request!

    def index
      render json: [], status: :ok
    end

    def create
      assert_limit!

      encoded =
        Rails.cache.fetch(cache_key, expires_in: 1.hour) do
          Encoded::Generator.generate(permitted_params)
        end
      render json: encoded, status: :ok
    rescue NotImplementedError => e
      render json: { error: e.message }, status: :not_implemented
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    private

    def assert_limit!
      request_size = permitted_params[:codes].length
      request_limit = ENV.fetch('ENCODED_REQUEST_LIMIT') { 100 }.to_i
      if request_size > request_limit
        return render json: {
          error: "#{request_size} codes is greater than the request limit of #{request_limit}",
          status: :unprocessable_entity
        }
      end
    end

    def authenticate_request!
      return head :forbidden unless headers_present?

      ENV['ENCODED_API_KEY'] == request.headers['x-encoded-api-key']
    end

    def cache_key
      [
        request.headers['x-rapidapi-key'],
        permitted_params[:codes].map { |r| r[:data][0..5] }
      ].hash
    end

    def headers_present?
      request.headers['x-rapidapi-key'].present? &&
        request.headers['x-encoded-api-key'].present?
    end

    def permitted_params
      params.permit(codes: [:data, :type, :format])
    end
  end
end
