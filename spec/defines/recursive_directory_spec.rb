require 'spec_helper'

describe 'recursive_directory' do
    context 'foobar2.py should contain fqdn with default file owner, group, mode' do
        let(:title) { 'example_test' }
        let(:facts) { { :fqdn => 'testhost.localdomain' } }
        let(:params) {
            {   
                :source_dir => 'recursive_directory',
                :final_dir => '/tmp/dest_dir',
            }
        }

        it do
            should contain_file('/tmp/dest_dir/foobar2.py').with({
                'ensure' => 'file',
                'owner' => 'nobody',
                'group'  => 'nobody',
                'mode'  => '0600',
            }).with_content("testhost.localdomain\n")
        end

    end

    context 'foobar2.py should set proper file mode' do
        let(:title) { 'example_test' }
        let(:facts) { { :fqdn => 'testhost.localdomain' } }
        let(:params) {
            {   
                :source_dir => 'recursive_directory',
                :final_dir => '/tmp/dest_dir',
                :file_mode => '0711',
            }
        }

        it do
            should contain_file('/tmp/dest_dir/foobar2.py').with({
                'ensure' => 'file',
                'owner' => 'nobody',
                'group'  => 'nobody',
                'mode'  => '0711',
            }).with_content("testhost.localdomain\n")
        end

    end

    context 'foobar2.py should set proper file owner' do
        let(:title) { 'example_test' }
        let(:facts) { { :fqdn => 'testhost.localdomain' } }
        let(:params) {
            {   
                :source_dir => 'recursive_directory',
                :final_dir => '/tmp/dest_dir',
                :owner => 'root',
            }
        }

        it do
            should contain_file('/tmp/dest_dir/foobar2.py').with({
                'ensure' => 'file',
                'owner' => 'root',
                'group'  => 'nobody',
                'mode'  => '0600',
            }).with_content("testhost.localdomain\n")
        end

    end

    context 'foobar2.py should set proper file group' do
        let(:title) { 'example_test' }
        let(:facts) { { :fqdn => 'testhost.localdomain' } }
        let(:params) {
            {   
                :source_dir => 'recursive_directory',
                :final_dir => '/tmp/dest_dir',
                :group => 'root',
            }
        }

        it do
            should contain_file('/tmp/dest_dir/foobar2.py').with({
                'ensure' => 'file',
                'owner' => 'nobody',
                'group'  => 'root',
                'mode'  => '0600',
            }).with_content("testhost.localdomain\n")
        end

    end

    context 'foobar2.py should have_custom_fact' do
        let(:title) { 'example_test' }
        let(:facts) { { 
            :fqdn => 'testhost.localdomain',
            :custom_fake_fact => 'this_is_fake'
        } }
        let(:params) {
            {   
                :source_dir => 'recursive_directory',
                :final_dir => '/tmp/dest_dir',
                :group => 'root',
            }
        }

        it do
            should contain_file('/tmp/dest_dir/custom.conf').with({
                'ensure' => 'file',
                'owner' => 'nobody',
                'group'  => 'root',
                'mode'  => '0600',
            }).with_content("testhost.localdomain\nthis_is_fake\n")
        end

    end
end