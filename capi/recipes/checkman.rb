link ::File.join(node['sprout']['home'], 'Checkman') do
  to ::File.join(node['sprout']['home'], node['workspace_directory'], 'capi-checkman')
end

execute 'install checkman' do
  command 'curl https://raw.githubusercontent.com/cppforlife/checkman/master/bin/install | bash -s'
end
