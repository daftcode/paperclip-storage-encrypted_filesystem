module Paperclip
  module Storage
    # Overwrite flush_writes to save encrypted content.
    # The instance that includes the attachment has to implement
    # a getter method: paperclip_encryption_key and a string column
    # paperclip_encryption_iv for the initialization vector.
    module EncryptedFilesystem
      include Filesystem

      class << self
        attr_writer :configuration
      end

      def self.configuration
        @configuration ||= Configuration.new
      end

      def self.configure
        yield configuration
      end

      def self.reset_config!
        @configuration = nil
      end

      def flush_writes
        validate_instance_methods!
        @queued_for_write.each do |style_name, file|
          FileUtils.mkdir_p(File.dirname(path(style_name)))
          File.open(path(style_name), 'wb') do |new_file|
            data = file.read
            new_file.write encrypt!(data, instance.paperclip_encryption_iv)
          end
          if @options[:override_file_permissions]
            resolved_chmod = (@options[:override_file_permissions] &~0111) || (0666 &~File.umask)
            FileUtils.chmod(resolved_chmod, path(style_name))
          end
          file.rewind
        end
        after_flush_writes
        @queued_for_write = {}
      end

      def encrypt!(data, iv)
        @key_for_instance ||= Encryptoid.random_key
        processed_key = Paperclip::Storage::EncryptedFilesystem.configuration.process_key_proc.call(@key_for_instance, instance)
        instance.update_column(:paperclip_encryption_key, processed_key)
        Encryptoid.encrypt data, key: @key_for_instance, iv: iv
      end

      def validate_instance_methods!
        [:paperclip_encryption_key, :paperclip_encryption_iv].each do |method|
          msg = "The object using has_attached_file using encrypted_filesystem as storage should implement #{method}"
          raise ArgumentError.new(msg) unless instance.respond_to?(method)
        end
      end

    end
  end
end
