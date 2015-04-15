# Paperclip::Storage::EncryptedFilesystem

This gem extends Paperclip with automatic attachment encryption using the regular filesystem storage provider and ActiveRecord.

## Installation

Add this line to your application's Gemfile:

    gem 'paperclip-storage-encrypted_filesystem', git: 'https://github.com/daftcode/paperclip-storage-encrypted_filesystem.git'

And then execute:

    $ bundle

Your Paperclip models will need two additional binary columns: `paperclip_encryption_key` and `paperclip_encryption_iv` to store encryption secrets.

    class AddPaperclipEncryptionKeyAndPaperclipEncryptionIvToMyModel < ActiveRecord::Migration
      def change
        change_table :my_models do |t|
          t.binary :paperclip_encryption_iv
          t.binary :paperclip_encryption_key
      end
    end

Optionally, you can skip the migration part and define getter methods for the key and iv fields in your models.

## Usage

Configure your Paperclip attachments to use the `storage: :encrypted_filesystem` option. Remember to include helper modules.

    class MyModel < ActiveRecord::Base
      include Paperclip::Storage::EncryptedFilesystem::Helpers
      include Paperclip::Storage::EncryptedFilesystem::FileDecryptor
      
      has_attached_file :photo,
                        :storage => :encrypted_filesystem,
                        :styles => {thumb: '303x224#', original: '2800x2800>'}
                        # other options
    end

When you save or update your attachments, Paperclip will encrypt them automatically.
In order to decrypt your data, you have to use the `decrypt` method that comes with `FileDecryptor` mix-in.

    binary_image = model_instance.decrypt(:attachment_name)
    thumb = model_instance.decrypt(:attachment_name, type: :thumb)

If you need to process the encryption key in any way before saving the attachment (i.e. encrypt it asymmetrically),
there is an option to pass a block in configuration:

    # app/config/initializers/paperclip_encryption.rb

    Paperclip::Storage::EncryptedFilesystem.configure do |conf|
      conf.process_key_proc = -> (key, instance) { OpenSSL::PKey::RSA.new(4096).public_encrypt(key) }
    end

## Contributing

1. Fork it ( https://github.com/[my-github-username]/paperclip-storage-encrypted_filesystem/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
