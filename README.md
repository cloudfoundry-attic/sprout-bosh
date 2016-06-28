# sprout-wrap

This project uses [soloist](https://github.com/mkocher/soloist) and [librarian-chef](https://github.com/applicationsonline/librarian-chef)
to run a subset of the recipes in sprout's cookbooks.

[Fork it](https://github.com/pivotal-sprout/sprout-wrap/fork) to
customize its [attributes](http://docs.chef.io/attributes.html) in [soloistrc](/soloistrc) and the list of recipes
you'd like to use for your team. You may also want to add other cookbooks to its [Cheffile](/Cheffile), perhaps one
of the many [community cookbooks](https://supermarket.chef.io/cookbooks). By default it configures an OS X
Mavericks workstation for Ruby development.

Finally, if you've never used Chef before - we highly recommend you buy &amp; watch [this excellent 17 minute screencast](http://railscasts.com/episodes/339-chef-solo-basics) by Ryan Bates.

## Installation under El Capitan (OS X 10.11)

### 1. Install Command Line Tools

    xcode-select --install

If you receive a message about the update server being unavailable and are on Mavericks, then you already have the command line tools.

### 2. Clone this project

    git clone https://github.com/cloudfoundry/sprout-bosh.git
    cd sprout-bosh

### 3. Install soloist & and other required gems

If you're running under rvm, rbenv, or chruby, you shouldn't preface the following commands with `sudo`.

    sudo gem install bundler
    bundle

If you receive errors like this:

    clang: error: unknown argument: '-multiply_definedsuppress'

then try downgrading those errors like this:

    sudo ARCHFLAGS=-Wno-error=unused-command-line-argument-hard-error-in-future bundle

### 4. Run soloist

[The `caffeinate` command will keep your computer awake while installing; depending on your network connection, soloist can take from 10 minutes to 2 hours to complete.]

    caffeinate bundle exec soloist

### 5. Optionally run other commands to set up workstation

1. copy *Spectacle* and *Flycut* to start on login
1. run git-hooks & git secrets
   ```
   git clone git@github.com:pivotal-sprout/sprout-git.git ~/workspace/sprout-git
   cd !$
   bundle
   bundle exec soloist run_recipe sprout-git::sprout_hooks
   bundle exec soloist run_recipe sprout-git::sprout_secrets
   ```
1. Mirror displays
1. Configure Finder
  1. Add ~/pivotal to Finder sidenav (https://www.pivotaltracker.com/story/show/89970764)
  1. Add ~/pivotal/workspace to Finder sidenav (https://www.pivotaltracker.com/story/show/89970764)
  1. Remove 'All my files' from Finder sidenav and as start page (https://www.pivotaltracker.com/story/show/92454292)
1. Configure Rubymine
  1. Update RubyMine to use Native ssh executable for git  (https://www.pivotaltracker.com/story/show/89970316)
  1. Update RubyMine to use Darcula theme and Darcularge font profile
  1. Setup RubyMine to work with Go plugin:
    1. Install Go plugin:
      1. Enter plugin repository:
        - go to: preferences &rarr; Plugins &rarr; browse repositories
      1. install Go
      1. restart
    1. Configure Go SDK
      1. Click on "Set up SDK" in notification window or
      1. go to: project settings (cmd+;) -> Platform Settings -> SDKs
      1. Add SDK (plus icon in top of column) -> Go SDK -> select '/usr/local/Cellar/go/1.x.x/libexec' -> 'Choose'
1. Gem install bundler (https://www.pivotaltracker.com/story/show/90239920)
```bash
cd ~/workspace/bosh
git co develop
gem install bundler -v 1.11.2
```
1. Install BOSH gems
```bash
cd ~/workspace/bosh
git co develop
gem install bundler -v 1.11.2
bundle
# IF error  "require': incompatible library version"
gem pristine --all
# ENDIF incompatible library
# IF pg gem doesn't install, reboot and try again. Really. It worked for me.
```
1. Run the unit tests:
```
be rake spec:unit:director
```
1. Install the integration tests dependencies:
```
export CFLAGS=-I/usr/local/opt/openssl/include
export LDFLAGS=-L/usr/local/opt/openssl/lib
be rake spec:integration:install_dependencies
```
