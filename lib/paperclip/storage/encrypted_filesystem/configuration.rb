module Paperclip
  module Storage
    module EncryptedFilesystem
      class Configuration
        attr_accessor :process_key_proc

        def initialize
          @process_key_proc = ->(key) { key }
        end

      end
    end
  end
end