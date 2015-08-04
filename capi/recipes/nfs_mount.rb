include_recipe 'sprout-base::workspace_directory'

return unless node['pivotal']['in_office']

directory '/mnt/Resources' do
  mode '0755'
  action :create
  recursive true
end

execute 'Configure auto_master' do
  command 'echo "/-          auto_resources -nobrowse,nosuidq" >> /etc/auto_master'
  not_if do
    open('/etc/auto_master').grep(%r(auto_resources)).any?
  end
end

file '/etc/auto_resources' do
  content "/mnt/capi_shared   -fstype=nfs,resvport,rw synology-01.cf-app.com:/volume1/capi\n"
  mode '0644'
  action :create
end

execute 'Activate automount' do
  command 'sudo automount -vc'
end

compiled_package_cache_path = ::File.join(node['sprout']['home'], node['workspace_directory'], 'bosh-lite/tmp/compiled_package_cache')
directory compiled_package_cache_path do
  action :delete
  not_if { File.symlink?(compiled_package_cache_path) && File.realpath(compiled_package_cache_path) == '/mnt/capi_shared/bosh/compiled_package_cache' }
end

link compiled_package_cache_path do
  to '/mnt/capi_shared/bosh/compiled_package_cache'
end

cf_release_blob_path = ::File.join(node['sprout']['home'], node['workspace_directory'], 'cf-release/.blobs')
directory cf_release_blob_path do
  action :delete
  not_if { File.symlink?(cf_release_blob_path) && File.realpath(cf_release_blob_path) == '/mnt/capi_shared/cf-release-blobs' }
end

link cf_release_blob_path do
  to '/mnt/capi_shared/cf-release-blobs'
end
