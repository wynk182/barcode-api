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
      render json: { codes: encoded }, status: :ok
    rescue NotImplementedError => e
      render json: { error: e.message }, status: :not_implemented
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def download
      encoded =
        Rails.cache.fetch(cache_key, expires_in: 1.hour) do
          Encoded::Generator.new(
            data: download_params[:data],
            type: download_params[:type],
            size: download_params[:size],
            format: 'raw_base_64',
            css_class: nil
          ).generate
        end
      send_data Base64.strict_decode64(encoded['raw_base_64']).force_encoding('UTF-8'),
        type: 'image/png',
        filename: "#{SecureRandom.hex(4)}.png",
        disposition: 'attachment'
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
      return head :forbidden unless valid_proxy_secret? || valid_api_key?
    end

    def cache_key
      request.body.to_s.hash
    end

    def download_params
      params.permit(:data, :type, :format, :size, :css_class)
    end

    def permitted_params
      params.permit(codes: %i[data type format size css_class])
    end

    def valid_api_key?
      request.headers['x-encoded-api-key'].present? &&
        ENV['ENCODED_API_KEY'] == request.headers['x-encoded-api-key']
    end

    def valid_proxy_secret?
      request.headers['X-RapidAPI-Proxy-Secret'].present? &&
        request.headers['X-RapidAPI-Proxy-Secret'] == ENV['ENCODED_PROXY_SECRET']
    end
  end
end
