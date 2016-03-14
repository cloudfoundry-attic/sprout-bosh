remote_file '/usr/local/bin/fly' do
  source 'https://capi.ci.cf-app.com/api/v1/cli?arch=amd64&platform=darwin'
  owner node['sprout']['user']
  mode '0755'
end
