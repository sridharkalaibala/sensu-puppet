require 'spec_helper'

describe 'sensu' do
  let(:facts) { { :fqdn => 'testhost.domain.com' } }

  context 'package' do
    context 'defaults' do
      it { should create_class('sensu::package') }
      it { should contain_package('sensu').with_ensure('latest') }
      it { should contain_file('/etc/default/sensu') }
      [ '/etc/sensu/conf.d', '/etc/sensu/conf.d/handlers', '/etc/sensu/conf.d/checks' ].each do |dir|
        it { should contain_file(dir).with(
          :ensure => 'directory',
          :purge  => false
        ) }
      end
      it { should contain_file('/etc/sensu/config.json').with_ensure('absent') }
      it { should contain_user('sensu') }
      it { should contain_group('sensu') }
    end

    context 'setting version' do
      let(:params) { {
        :version      => '0.9.10',
      } }

      it { should contain_package('sensu').with(
        :ensure => '0.9.10'
      ) }
    end

    context 'repos' do

      context 'redhat' do
        let(:facts) { { :operatingsystem => 'RedHat' } }

        context 'default' do
          it { should contain_yumrepo('sensu').with(
            :enabled   => 1,
            :baseurl   => 'http://repos.sensuapp.org/yum/el/$releasever/$basearch/',
            :gpgcheck  => 0,
            :before    => 'Package[sensu]'
          ) }
        end

        context 'unstable repo' do
          let(:params) { { :repo => 'unstable' } }
          it { should contain_yumrepo('sensu').with(:baseurl => 'http://repos.sensuapp.org/yum-unstable/el/$releasever/$basearch/' )}
        end

        context 'install_repo => false' do
          let(:params) { { :install_repo => false } }
          it { should_not contain_yumrepo('sensu') }
        end
      end
    end

    context 'purge_config' do
      let(:params) { { :purge_config => true } }

      [ '/etc/sensu/conf.d', '/etc/sensu/conf.d/handlers', '/etc/sensu/conf.d/checks' ].each do |dir|
        it { should contain_file(dir).with(
          :ensure  => 'directory',
          :purge   => true,
          :recurse => true,
          :force   => true
        ) }
      end

    end
  end

end
