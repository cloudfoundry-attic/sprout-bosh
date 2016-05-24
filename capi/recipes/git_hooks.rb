execute 'install git-hooks' do
  command <<-EOC
    curl -L https://github.com/git-hooks/git-hooks/releases/download/v1.1.3/git-hooks_darwin_amd64.tar.gz | \
      tar -zxf - --to-stdout > /usr/local/bin/git-hooks
    chmod 755 /usr/local/bin/git-hooks
  EOC
  not_if { ::File.exist?('/usr/local/bin/git-hooks') }
end

execute 'install global git hooks' do
  command 'git config --system --add hooks.global /usr/local/share/githooks'
  user node['sprout']['user']
  not_if 'git config -l | grep hooks.global'
end

node['git_hooks']['install_dirs'].each do |dir|
  execute "install git-hooks in #{dir}" do
    command 'git hooks install || true'
    user node['sprout']['user']
    cwd ::File.join(node['sprout']['home'], dir)
  end
end

node['git_hooks']['allowed'].each do |pattern|
  execute "allow git secret: #{pattern}" do
    command "git secrets --add --allowed '#{pattern}'"
    user node['sprout']['user']
    not_if "git config -l | grep -F '#{pattern}'"
  end
end

%w(
  /usr/local/share/githooks/pre-commit
  /usr/local/share/githooks/commit-msg
  /usr/local/share/githooks/prepare-commit-msg
).each do |dir|
  directory dir do
    mode 0755
  end
end

template '/usr/local/share/githooks/pre-commit/00-git-secrets' do
  source 'git_hooks/pre-commit'
  mode 0755
end

template '/usr/local/share/githooks/commit-msg/00-git-secrets' do
  source 'git_hooks/commit-msg'
  mode 0755
end

template '/usr/local/share/githooks/prepare-commit-msg/00-git-secrets' do
  source 'git_hooks/prepare-commit-msg'
  mode 0755
end
