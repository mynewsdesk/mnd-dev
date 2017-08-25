# MND-DEV

Command line interface with install, update and quality of life functionality for all platform related mynewsdesk repos.

## Install

```bash
brew tap mynewsdesk/homebrew-tap
brew install mnd
```

This is to enable usage of the `mnd` command on your computer.
See below for development setup instructions.

## Usage

Check the usage by typing `mnd help`

```
Usage: mnd COMMAND [repo1 repo2] [command-specific-options]

Type 'mnd help COMMAND' for details of each command

Available commands:
edit            Open repo source in editor
help            Helps you out!
install         Install missing repos
list            List all repos
logs            Check logs
platform        Get or set the current platform
run             Run shell commands on multi-repos
upgrade         Upgrade all or given repos
```

Check detail usage for one command `mnd help logs`:

```
Check logs

Usage:
    mnd logs # tails all logs
    mnd logs web create # tails logs from web and create
    mnd l # use alias

    Note: currently, only the development.log is pulled.
```

## Development setup

Clone the repo and run `bin/setup`
```bash
cd ~/Projects
git clone git@github.com:mynewsdesk/mnd-dev.git
cd mnd-dev
bundle install
# Add below line to your ~/.bashrc or ~/.zshrc
export PATH="$HOME/Projects/mnd-dev/bin:$PATH"
```

### Add command

Create your awesome command and put in `lib/mnd/commands`:

```ruby
module Mnd

  # You can add documentation for command before the class define.
  # The summary is one short sentence, which will appear in the help page
  # The usage is the detail usage, which will appear in the help:awesome page
  class Commands::Awesome < Commands::Base
    summary "An awesome command"
    usage <<-EOF
    mnd awesome # show how awesome it is
    EOF

    # The command executes via the perform method
    def perform
      # Use display.[info|warn|error|debug] to display text on screen
      display.info "This is an awesome command!"
    end
  end
end
```

### Useful methods in the `Mnd::Commands::Base`

`Base#selected_repos`

Get currently selected repos based on command line arguments.

For example when running, `mnd logs mynewsdesk apiary` then the `selected_repos`
will be `["mynewsdesk", "apiary"]`.

However if no apps are specified it returns an empty array so when running
`mnd logs` the `selected_repos` will be `[]`. You might want to either display
an error (`return display.error "No repo specified if selected_repos.empty?"`) or
default to use all apps (`selected_repos.presence || Repo.all`) in that case.

`Base#display`

Use `display` to get a display to print message instead of puts everywhere.
It supports color in terminal. By default:

* display.info: default color
* display.error: red
* display.warn: yellow
* display.debug: light_black

`Base#run(cmd, repo = nil)`

Use it to run external command.

Parameters:

* cmd, String of the command you want to run
* repo, Optional if you want to run cmd on an repo

When repo is passed, it will cd to the root of repo then run the command.

### Add a repo

Add repos to the various platforms in `src/mnd/platforms.cr`.
