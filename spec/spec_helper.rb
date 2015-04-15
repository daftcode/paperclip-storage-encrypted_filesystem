$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'paperclip/storage/encrypted_filesystem'
require 'active_record'
require 'encryptoid'

require 'support/test_model'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'
ActiveRecord::Base.raise_in_transactional_callbacks = true

RSpec.configure do |c|
  c.after do
    Paperclip::Storage::EncryptedFilesystem.reset_config!
  end
end