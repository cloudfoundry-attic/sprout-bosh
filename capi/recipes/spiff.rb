node.default['spiff']['url'] = 'https://github.com/cloudfoundry-incubator/spiff/releases/download/v1.0.7/spiff_darwin_amd64.zip'
node.default['spiff']['shasum'] = '482b77c522e5d8ac95cfe1b8e785f5d4fe9183f7d25122fa18d271cac6a3dbbe'

unless File.exists?('/usr/local/bin/spiff')
  directory Chef::Config[:file_cache_path] do
    action :create
    recursive true
  end

  remote_file "#{Chef::Config[:file_cache_path]}/spiff.zip" do
    source node['spiff']['url']
    checksum node['spiff']['shasum']
    owner node['sprout']['user']
  end

  execute 'extract text mate to /usr/local/bin' do
    command "unzip -o #{Chef::Config[:file_cache_path]}/spiff.zip -x __MACOSX* -d /usr/local/bin/"
    user node['sprout']['user']
  end
end
