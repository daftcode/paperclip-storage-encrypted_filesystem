require 'spec_helper'

describe Paperclip::Storage::EncryptedFilesystem::Configuration do
  describe '.process_key_proc' do
    let(:value) { '1234567890' }
    context 'default procedure' do
      it 'returns passed value' do
        expect(subject.process_key_proc.call value).to eq value
      end
    end
  end
end