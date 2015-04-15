require 'spec_helper'

describe Paperclip::Storage::EncryptedFilesystem do
  it 'has a version number' do
    expect(Paperclip::Storage::EncryptedFilesystem::VERSION).not_to be nil
  end

  describe '.configure' do
    let(:proc) { ->(key, instance) { 'result' } }
    let(:key) { '1234567890' }

    before do
      Paperclip::Storage::EncryptedFilesystem.configure do |config|
        config.process_key_proc = proc
      end
    end

    it 'sets key processing procedure' do
      expect(Paperclip::Storage::EncryptedFilesystem.configuration.process_key_proc).to eq proc
      expect(Paperclip::Storage::EncryptedFilesystem.configuration.process_key_proc.call key, nil).to eq 'result'
    end
  end

  describe '.reset_config!' do
    it 'sets the configuration field to nil' do
      Paperclip::Storage::EncryptedFilesystem.configuration
      Paperclip::Storage::EncryptedFilesystem.reset_config!
      expect(Paperclip::Storage::EncryptedFilesystem.instance_variable_get(:@configuration)).to eq nil
    end
  end

  describe '.configuration' do
    it 'returns configuration object' do
      expect(Paperclip::Storage::EncryptedFilesystem.configuration).to be_a Paperclip::Storage::EncryptedFilesystem::Configuration
    end
  end

  describe 'attachment encryption integrated' do
    include_context 'test_model'

    after { FileUtils.rm_r 'spec/files/tmp' rescue nil }

    it 'sets the iv' do
      instance = Dummy.new
      instance.run_callbacks(:create)
      expect(instance.paperclip_encryption_iv).to be_present
    end

    it 'encrypts the attachment' do
      doge = File.open('spec/files/doge_mock.jpg', 'rb')
      instance = Dummy.new
      instance.image = doge
      instance.save!

      real_doge = instance.decrypt(:image)
      expect(real_doge).to eq doge.read
    end

  end
end