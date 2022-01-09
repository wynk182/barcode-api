module Encoded
  class ApiController < ActionController::Base
    before_action :authenticate_request!

    def index
      render json: [], status: :ok
    end

    def create
      assert_limit!
      encoded = Encoded::Generator.generate(permitted_params)
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

    def permitted_params
      params.permit(codes: [:data, :type, :format])
    end

    def authenticate_request!
      return head :forbidden unless headers_present?
    end

    def headers_present?
      request.headers['x-rapidapi-host'].present? &&
        request.headers['x-rapidapi-key'].present?
    end
  end
end
