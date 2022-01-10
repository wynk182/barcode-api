require 'barby'
require 'barby/barcode'
require 'barby/barcode/code_128'
require 'barby/barcode/code_25'
require 'barby/barcode/qr_code'
require 'barby/barcode/code_39'
require 'barby/barcode/bookland'
require 'barby/barcode/codabar'
require 'barby/barcode/code_25_iata'
require 'barby/barcode/code_25_interleaved'
require 'barby/barcode/code_93'
require 'barby/barcode/ean_13'
require 'barby/barcode/ean_8'
require 'barby/barcode/gs1_128'
require 'barby/barcode/upc_supplemental'

require 'barby/outputter/png_outputter'
require 'barby/outputter/html_outputter'
require 'barby/outputter/svg_outputter'

module Encoded
  class Generator
    attr_reader :data, :type, :format, :size, :css_class

    class << self
      def generate(args)
        args['codes'].map do |code|
          new(
            css_class: code['css_class'],
            size: code['size'],
            data: code['data'],
            type: code['type'],
            format: code['format'].presence || 'png'
          ).generate
        end
      end
    end

    def initialize(data:, type:, format:, size:, css_class:)
      @data = data
      @type = type
      @format = format
      @size = size.nil? ? nil : size.to_i
      @css_class = css_class
    end

    def generate
      code = encoder
      # code.size = size.to_i if code.respond_to?(:size) && size.present?
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
        Barby::Code128A.new(data)
      when 'code_128b'
        Barby::Code128B.new(data)
      when 'code_128c'
        Barby::Code128C.new(data)
      when 'qr_code'
        Barby::QrCode.new(data)
      when 'code_25'
        Barby::Code25.new(data)
      when 'code_25_interleaved'
        Barby::Code25Interleaved.new(data)
      when 'code_25_iata'
        Barby::Code25IATA.new(data)
      when 'code_39'
        Barby::Code39.new(data)
      when 'code_93'
        Barby::Code93.new(data)
      when 'ean_13'
        Barby::EAN13.new(data)
      when 'ean_8'
        Barby::EAN8.new(data)
      when 'gs1_128'
        Barby::GS1128.new(data)
      else
        raise NotImplementedError, "#{@type} is not an implemented encoder"
      end
    end

    def outputter(code)
      opts = {}
      opts.merge!(xdim: size) if size.present? && @format != 'html'
      opts.merge!(class_name: css_class) if css_class.present? && @format == 'html'

      case @format
      when 'png'
        "data:image/png;base64,#{to_64(code.to_png(opts))}"
      when 'raw_base_64'
        to_64(code.to_png(opts))
      when 'svg'
        code.to_svg
      when 'html'
        code.to_html(opts)
      else
        raise NotImplementedError, "#{@format} is not an implemented format"
      end
    end

    def to_64(str)
      Base64.strict_encode64(str).force_encoding('UTF-8')
    end
  end
end
