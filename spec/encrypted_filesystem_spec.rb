require 'spec_helper'

describe Paperclip::Storage::EncryptedFilesystem do
  it 'has a version number' do
    expect(Paperclip::Storage::EncryptedFilesystem::VERSION).not_to be nil
  end



  describe '#configure' do
    let(:proc) { ->(key) { 'result' } }
    let(:key) { '1234567890' }

    before do
      Paperclip::Storage::EncryptedFilesystem.configure do |config|
        config.process_key_proc = proc
      end
    end

    it 'sets key processing procedure' do
      expect(Paperclip::Storage::EncryptedFilesystem.configuration.process_key_proc).to eq proc
      expect(Paperclip::Storage::EncryptedFilesystem.configuration.process_key_proc.call key).to eq 'result'
    end
  end

  describe '#configuration' do
    it 'returns configuration object' do
      expect(Paperclip::Storage::EncryptedFilesystem.configuration).to be_a Paperclip::Storage::EncryptedFilesystem::Configuration
    end
  end
end