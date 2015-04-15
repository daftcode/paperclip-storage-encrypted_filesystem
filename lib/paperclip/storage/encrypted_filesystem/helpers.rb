module Paperclip
  module Storage
    module EncryptedFilesystem

      module Helpers
        extend ActiveSupport::Concern

        included do
          before_create :set_paperclip_encryption_iv
        end

        def set_paperclip_encryption_iv
          self.paperclip_encryption_iv ||= Encryptoid.random_key
        end

      end

    end
  end
end