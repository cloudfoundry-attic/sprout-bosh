cookbook_file 'usr/local/bin/imgcat' do
  source 'imgcat'
  owner node['sprout']['user']
  mode 0755
end

cookbook_file 'usr/local/bin/dishy' do
  source 'dishy'
  owner node['sprout']['user']
  mode 0755
end
