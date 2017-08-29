# MND-DEV

Command line interface with install, update and quality of life functionality
for all platform related mynewsdesk repos.

## Install

The [dev computer](https://github.com/mynewsdesk/dev-computer/) script installs
it for you but if you need to do it manually simply run:

```bash
brew install --HEAD mynewsdesk/tap/mnd
```

## Configuration

Run `mnd setup` to configure where you want to install the repos etc. All settings
will be stored in YAML format in `~/.mnd`.

## Update

To update to the latest version simply run `mnd update`.

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

    Note: currently, only the development.log is pulled.
```

## Development setup

Clone the repo and run `bin/setup`

Then run `guardian` to auto-compile whenever you change any source files.

Executable will be available as `bin/mnd` which you can run to test your
changes before publishing.

### Publish a new release

Bump the version number in `src/mnd/version.cr` and run `bin/release`

### Add a repo

Add repos to the various platforms in `src/mnd/platforms.cr`.

### Add command

Create a new command class in the `src/mnd/commands` directory:

```ruby
module Mnd
  class Commands::Awesome < Commands::Base
    # The summary is one short sentence, which will appear in the help page
    # The usage is the details, which will appear when running 'mnd help awesome'
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
