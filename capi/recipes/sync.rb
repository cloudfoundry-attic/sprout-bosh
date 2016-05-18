require 'yaml'

sync_config = "#{node['sprout']['home']}/.sync.folders"

if ::File.exist?(sync_config)
  sync_folders = YAML.load_file(sync_config)['folders']
else
  sync_folders = []
end

template "#{node['sprout']['home']}/.btsync.conf" do
  source 'sync/btsync.conf.erb'
  owner node['sprout']['user']
  variables 'sync_folders' => sync_folders
end

execute 'load bittorrent sync config' do
  command "'/opt/homebrew-cask/Caskroom/bittorrent-sync/latest/BitTorrent Sync.app/Contents/MacOS/BitTorrent Sync' --config #{node['sprout']['home']}/.btsync.conf &"
  user node['sprout']['user']
  only_if { ::File.exist?(sync_config) }
end
