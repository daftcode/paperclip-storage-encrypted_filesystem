shared_context 'test_model' do
  before do
    Object.send(:remove_const, :Dummy) rescue nil
    klass = create_dummy_klass
    Object.const_set :Dummy, klass
    create_dummy_table
  end
end

def create_dummy_klass
  Class.new(ActiveRecord::Base) do
    include Paperclip::Glue
    include Paperclip::Storage::EncryptedFilesystem::PaperclipEncryptionHelpers
    has_attached_file :image, storage: :encrypted_filesystem, path: "spec/files/tmp/:class/:attachment/:style/:filename"
    do_not_validate_attachment_file_type :image
  end
end

def create_dummy_table
  ActiveRecord::Base.connection.create_table :dummies, force: true do |t|
    t.binary :paperclip_encryption_iv
    t.binary :paperclip_encryption_key
    t.attachment :image
  end
end