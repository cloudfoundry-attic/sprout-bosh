# cf-bosh

## Run soloist

In the `cf-bosh` directory run:

```
soloist
```

## Manually tweak the final set of things we don't yet have automated
1. Mirror displays
1. Configure Finder
  1. Add ~/pivotal to Finder sidenav (https://www.pivotaltracker.com/story/show/89970764)
  1. Add ~/pivotal/workspace to Finder sidenav (https://www.pivotaltracker.com/story/show/89970764)
  1. Remove 'All my files' from Finder sidenav and as start page (https://www.pivotaltracker.com/story/show/92454292)
1. Configure Rubymine
  1. Update RubyMine to use Native ssh executable for git  (https://www.pivotaltracker.com/story/show/89970316)
  1. Update RubyMine to use Darcula theme and Darcularge font profile
1. Configure Intellij
  1. Update Intellij Idea to use Native ssh executable for git  (https://www.pivotaltracker.com/story/show/89970316)
  1. Update Intellij Idea to use Default theme and Darcularge font profile
  1. Install 'idea' command line tool (https://www.pivotaltracker.com/story/show/89970526)
  1. Setup Intellij to work with Go plugin:
    1. Install Go plugin:
      1. Enter custom plugin repository:
        - go to: preferences -> Plugins -> browse repositories -> Manage repositories
        - enter 'https://plugins.jetbrains.com/plugins/alpha/list'
      1. Select only that repository in the 'Browse Repositories' window
      1. install Go
      1. restart
    1. Configure Go SDK
      1. go to: project settings (cmd+;) -> Platform Settings -> SDKs
      1. Add SDK (plus icon in top of column) -> Go SDK -> select '/usr/local/Cellar/go/1.x.x/libexec' -> 'Choose'
    1. Select SDK for each project
      1. go to: Project settings (cmd+;) -> Project Settings -> Project -> Project SDK
      1. choose Go 1.x.x
1. Gem install bundler (https://www.pivotaltracker.com/story/show/90239920)
1. Gem install git-duet 
  1.  run `gem install git-duet`
