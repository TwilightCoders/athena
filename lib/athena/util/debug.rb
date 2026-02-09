# frozen_string_literal: true

module Athena
  module Util
    module Debug
      def self.enabled?
        !!$athena_debug
      end

      def self.enable!
        $athena_debug = true
      end

      def self.disable!
        $athena_debug = false
      end

      def self.log(message)
        return unless enabled?
        $stderr.puts "[Athena DEBUG] #{message}"
      end
    end
  end
end
