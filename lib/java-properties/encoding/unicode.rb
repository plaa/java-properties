module JavaProperties
  module Encoding
    # Module to encode and decode unicode chars
    # @see JavaProperties::Encoding
    module Unicode

      # Marker for encoded unicode chars
      # @return [Regexp]
      UNICODE_MARKER  = /\\[uU]([0-9a-fA-F]{4,5}|10[0-9a-fA-F]{4})/

      # Escape char for unicode chars
      # @return [String]
      UNICODE_ESCAPE = "\\u"

      # Decodes all unicode chars from escape sequences in place
      # @param text [String]
      # @return [String] The encoded text for chaining
      def self.decode!(text)
        text.gsub!(UNICODE_MARKER) do
          unicode($1.hex)
        end
        text
      end

      # Decodes all unicode chars into escape sequences in place
      # @param text [String]
      # @return [String] The decoded text for chaining
      def self.encode!(text)
        buffer = StringIO.new
        text.each_char do |char|
          if char.ascii_only?
            buffer << char
          else
            buffer << UNICODE_ESCAPE
            buffer << hex(char.codepoints.first)
          end
        end
        text.replace buffer.string
        text
      end

      private

      def self.unicode(code)
        code.chr(::Encoding::UTF_8)
      end

      def self.hex(codepoint)
        hex  = codepoint.to_s(16)
        size = [4, hex.size].max
        target_size = size.even? ? size : size+1
        hex.rjust(target_size, '0')
      end

    end
  end
end
