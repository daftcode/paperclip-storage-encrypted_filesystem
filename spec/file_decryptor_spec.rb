require 'spec_helper'

describe Paperclip::Storage::EncryptedFilesystem::FileDecryptor do

  context 'when included module' do
    let(:klass) { Struct.new(:paperclip_encryption_iv, :paperclip_encryption_key) }
    let(:path) { 'sample/file/path/000/photo.jpg' }
    let(:attr) { :photo }
    let(:mock_attr) { double() }
    let(:type) { :original }
    let(:obj) { klass.new('random-iv', 'aes-key') }

    before do
      klass.send(:include, Paperclip::Storage::EncryptedFilesystem::FileDecryptor)
    end

    it 'has decrypt method' do
      expect(obj).to respond_to :decrypt
    end

    context 'without options' do
      it 'decrypts file using aes_key and iv from model' do
        args = [path, iv: obj.paperclip_encryption_iv, key: obj.paperclip_encryption_key]

        expect(obj).to receive(attr).and_return(mock_attr)
        expect(mock_attr).to receive(:path).with(type).and_return(path)
        expect(Encryptoid).to receive(:decrypt_file).with(*args)
        obj.decrypt(attr, type: type)
      end
    end

    context 'with options' do
      it 'decrypts file using passed aes_key and iv' do
        iv = 'qwerty'
        key = '123456789'

        expect(obj).to receive(attr).and_return(mock_attr)
        expect(mock_attr).to receive(:path).with(type).and_return(path)
        expect(Encryptoid).to receive(:decrypt_file).with(path, iv: iv, key: key)
        obj.decrypt(attr, type: type, iv: iv, key: key)
      end
    end
  end
end