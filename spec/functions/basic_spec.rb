require 'spec_helper'

describe 'recurse_directory' do
  let(:facts) { { 'fqdn' => 'hello!' } }

  let(:resources) { run.with_params(params) }

  context 'all params' do
    let(:params) { %w(test dest_dir 0777 owner group) }
    let(:expected_properties) do
      {
        'ensure' => 'file',
        'content' => "hello!\n",
        'owner' => 'owner',
        'group' => 'group',
        'mode' => '0777'
      }
    end

    let(:expected_resources) do
      { 'dest_dir/example.conf' => expected_properties }
    end

    it 'returns them back' do
      expect(subject).to run.with_params(*params).and_return(expected_resources)
    end
  end

  context 'minimal params' do
    let(:params) { %w(test dest_dir) }
    let(:expected_resources) do
      { 'dest_dir/example.conf' => { 'ensure' => 'file', 'content' => "hello!\n", 'mode' => '0600' } }
    end

    it 'returns the proper values' do
      expect(subject).to run.with_params(*params).and_return(expected_resources)
    end
  end
end
