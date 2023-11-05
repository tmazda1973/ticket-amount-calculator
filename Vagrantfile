# -*- mode: ruby -*-
# vi: set ft=ruby :

(lambda do
  #
  # プラグインをインストールします。
  # @param action [String] アクション名
  #
  def install_plugins(action)
    # 対象外のアクションであれば終了する
    return unless %w[up reload].include?(action)
    # プラグインをインストールする
    plugins_dependencies = %w(
      vagrant-vbguest
      vagrant-docker-compose
      vagrant-disksize
      vagrant-rsync-back
    ) # <- ここに必要なプラグインを列挙する
    plugin_status = false
    plugins_dependencies.each do |plugin_name|
      unless Vagrant.has_plugin?(plugin_name)
        puts "#{plugin_name} is required."
        system("vagrant plugin install #{plugin_name}")
        plugin_status = true
      end
    end
    # Restart Vagrant if any new plugin installed
    if plugin_status === true
      exec "vagrant #{ARGV.join(' ')}"
    else
      puts "All Plugin Dependencies already installed."
    end
  end
  # プラグインをインストールする
  install_plugins(ARGV[0])
end).call

# ------------------------------------------------------------------------------
# Vagrant コンフィグ定義
# ------------------------------------------------------------------------------
GUEST_IP_ADDR = "192.168.33.11"
PATH_MAPPINGS = {
  app: { host: "./app", guest: "/vagrant/app" },
  docker: { host: "./docker", guest: "/vagrant/docker" },
}
Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu2004"
  config.vm.network "private_network", ip: GUEST_IP_ADDR
  config.vm.provider :virtualbox do |vb|
    vb.gui = false
    vb.cpus = 4
    vb.memory = 2048
    vb.customize ["modifyvm", :id, "--audio", "none"]
    vb.customize ['modifyvm', :id, '--natdnsproxy1', 'off']
    vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'off']
  end

  # 同期対象のディレクトリを設定する
  config.vm.synced_folder PATH_MAPPINGS[:app][:host], PATH_MAPPINGS[:app][:guest],
    owner: "vagrant", group: "vagrant",
    type: "rsync", create: true,
    rsync_auto: true, rsync__exclude: %w[.git/ node_modules/ log/ tmp/ vendor/ storage/ vendor/bundle/]
  config.vm.synced_folder PATH_MAPPINGS[:docker][:host], PATH_MAPPINGS[:docker][:guest],
    owner: "vagrant", group: "vagrant",
    type: "rsync", create: true,
    rsync_auto: true

  # Dockerを起動する
  config.vm.provision :docker
  config.vm.provision :docker_compose,
    yml: "#{PATH_MAPPINGS[:docker][:guest]}/docker-compose.yml",
    rebuild: true,
    run: "always"
end
