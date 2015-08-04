def has_nfs_mount_point(uri)
  system "rpcinfo -u #{uri} nfs 3"
end

default['pivotal']['in_office'] = has_nfs_mount_point('synology-01.cf-app.com')
