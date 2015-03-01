require 'serverspec'
require 'net/ssh'
require 'tempfile'

set :backend, :ssh # localか、sshかを指定

if ENV['ASK_SUDO_PASSWORD'] # passwordをどうするか
  begin
    require 'highline/import'
  rescue LoadError
    fail "highline is not available. Try installing it."
  end
  set :sudo_password, ask("Enter sudo password: ") { |q| q.echo = false }
else
  set :sudo_password, ENV['SUDO_PASSWORD']
end

host = ENV['TARGET_HOST']

# options = Net::SSH::Config.for(host) # ~/.ssh/configの設定を取得


options[:user] ||= Etc.getlogin

set :host,        options[:host_name] || host # ~/.ssh/configにHostNameがあればそれを、なければhostに入っている値を利用
set :ssh_options, options # Specinfra.configurasion.ssh_optionsにセットしている

# Disable sudo
# set :disable_sudo, true


# Set environment variables
# set :env, :LANG => 'C', :LC_MESSAGES => 'C'

# Set PATH
# set :path, '/sbin:/usr/local/sbin:$PATH'

Dir[File.expand_path('{shared,support}/*.rb', File.dirname(__FILE__))].each do |file|
  require file
end

