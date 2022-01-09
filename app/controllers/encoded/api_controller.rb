module Encoded
  class ApiController < ActionController::Base
    skip_before_action :verify_authenticity_token
    before_action :authenticate_request!

    def index
      render json: [], status: :ok
    end

    def create
      assert_request_body! and return
      assert_limit! and return

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
        render(
          json: {
            error: "#{request_size} codes is greater than the request limit of #{request_limit}"
          },
          status: :unprocessable_entity
        )
      end
    end

    def assert_request_body!
      if permitted_params[:codes].blank?
        render(
          json: {
            error: "Invalid request body"
          },
          status: :unprocessable_entity
        )
      end
    end

    def authenticate_request!
      return head :forbidden unless request.headers['x-encoded-api-key'].present?
      return head :forbidden unless ENV['ENCODED_API_KEY'] == request.headers['x-encoded-api-key']
    end

    def cache_key
      request.body.to_s.hash
    end

    def permitted_params
      params.permit(codes: %i[data type format])
    end
  end
end
