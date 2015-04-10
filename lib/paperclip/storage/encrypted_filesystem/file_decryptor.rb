module Paperclip
  module Storage
    module EncryptedFilesystem
      module FileDecryptor

        def decrypt(attribute, options={})
          path = options[:path] || attribute.path(options[:type])
          options[:key] ||= paperclip_encryption_key
          options[:iv]  ||= paperclip_encryption_iv
          Encryptoid.decrypt_file(path, key: options[:key], iv: options[:iv])
        end

      end
    end
  end
end