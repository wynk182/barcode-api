require_relative 'barby_loader'

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
      {
        format => output,
        data: data,
        format: format,
        type: type
      }
    end

    private

    def encoder
      case @type
      when 'code_128a'
        Barby::Code128A
      when 'code_128b'
        Barby::Code128B
      when 'code_128c'
        Barby::Code128C
      when 'qr_code'
        Barby::QrCode
      when 'code_25'
        Barby::Code25
      when 'code_25_interleaved'
        Barby::Code25Interleaved
      when 'code_25_iata'
        Barby::Code25IATA
      when 'code_39'
        Barby::Code39
      when 'code_93'
        Barby::Code93
      when 'ean_13'
        Barby::EAN13
      when 'ean_8'
        Barby::EAN8
      when 'gs1_128'
        Barby::GS1128
      else
        raise NotImplementedError, "#{@type} is not an implemented encoder"
      end
    end

    def outputter(code)
      case @format
      when 'png'
        "data:image/png;base64,#{to_64(code.to_png)}"
      when 'raw_base_64'
        to_64(code.to_png)
      when 'svg'
        code.to_svg
      when 'html'
        code.to_html
      else
        raise NotImplementedError, "#{@format} is not an implemented format"
      end
    end

    def to_64(str)
      Base64.strict_encode64(str).force_encoding('UTF-8')
    end
  end
end
