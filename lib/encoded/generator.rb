require 'barby'
require 'barby/barcode/code_128'
require 'barby/barcode/code_25'
require 'barby/barcode/qr_code'
require 'barby/outputter/png_outputter'

module Encoded
  class Generator
    attr_reader :data, :type, :format

    class << self
      def generate(args)
        args['codes'].map do |code|
          new(
            data: code['data'],
            type: code['type'],
            format: code['format'].presence || 'png'
          ).generate
        end
      end
    end

    def initialize(data:, type:, format:)
      @data = data
      @type = type
      @format = format
    end

    def generate
      code = encoder.new(@data)
      output = outputter(code)
      raw64 = Base64.strict_encode64(output).force_encoding('UTF-8')
      {
        base_64: raw64,
        data: data,
        format: format,
        type: type
      }
    end

    private

    def encoder
      case @type
      when 'code_128'
        Barby::Code128B
      when 'qr_code'
        Barby::QrCode
      when 'code_25'
        Barby::Code25
      else
        raise NotImplementedError, "#{@type} is not an implemented encoder"
      end
    end

    def outputter(code)
      case @format
      when 'png'
        code.to_png
      else
        raise NotImplementedError, "#{@format} is not an implemented format"
      end
    end
  end
end
