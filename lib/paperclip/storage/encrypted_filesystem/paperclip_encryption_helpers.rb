module Paperclip
  module Storage
    module EncryptedFilesystem
      module PaperclipEncryptionHelpers

        def set_paperclip_encryption_iv
          self.paperclip_encryption_iv ||= Encryptoid.random_key
        end

      end
    end
  end
end