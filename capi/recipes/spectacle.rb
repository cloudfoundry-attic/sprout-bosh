homebrew_cask 'spectacle'

cookbook_file "/Users/#{node['sprout']['user']}/Library/Preferences/com.divisiblebyzero.Spectacle.plist" do
  source 'com.divisiblebyzero.Spectacle.plist'
  user node['sprout']['user']
  mode '0600'
end
