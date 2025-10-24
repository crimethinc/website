# CrimethInc. website

Ruby on Rails app that powers https://crimethinc.com

## Development

[![GitHub Actions Tests CI Build Status](https://github.com/crimethinc/website/actions/workflows/tests.yml/badge.svg)](https://github.com/crimethinc/website/actions?workflow=Tests)
[![GitHub Actions System Tests CI Build Status](https://github.com/crimethinc/website/actions/workflows/tests_system.yml/badge.svg)](https://github.com/crimethinc/website/actions?workflow=Tests)
[![Maintainability](https://api.codeclimate.com/v1/badges/22ef4ea6475be7057b87/maintainability)](https://codeclimate.com/github/crimethinc/website/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/22ef4ea6475be7057b87/test_coverage)](https://codeclimate.com/github/crimethinc/website/test_coverage)

## Short Version

**First things first**, [Strap](https://strap.mikemcquaid.com/) your computer’s development environment.

```sh
open https://strap.mikemcquaid.com/strap.sh
```

Then…

```sh
sh ~/Downloads/strap.sh
rm -f ~/Downloads/strap.sh
git clone https://github.com/crimethinc/website.git
cd website
./script/bootstrap
source ~/.bash_profile
./script/setup
overcommit --install
./script/server
```

## Scripts to Rule Them All

The CrimethInc. website uses the [Scripts to Rule Them All](https://githubengineering.com/scripts-to-rule-them-all) pattern.
See also: https://github.com/github/scripts-to-rule-them-all

`/script` is a collection of scripts for development on an macOS computer.
Development setup on a Windows or Linux computer will likely vary.

If any of these scripts fail for you, [file an issue](https://github.com/crimethinc/website/issues)
with as much detail about your setup and any errors you got from the script, and we’ll try to fix whatever’s happening.

## Development Scripts

The rest of these instructions assume that you’ve [strapped your computer](https://macos-strap.herokuapp.com) already. If you haven’t, you’ll need to install somethings manually. (But really, you’re better off using [Strap](https://macos-strap.herokuapp.com).)

- [Homebrew](https://brew.sh)
- Homebrew taps and extensions
- Xcode command line tools
- Postgres launchctl (for `setup` script)

***

- [bootstrap](#bootstrap-script)
- [setup](#setup-script)
- [server](#server-script)
- [update](#update-script)
- [test](#test-script)
- [test_server](#test-server-script)
- [console](#console-script)
- [cibuild](#ci-build-script)
- [seed](#database-seed-script)

***

### Bootstrap script

The `bootstrap` script is the first time development environment configuration for this app.
You should only need to run this script once.
It will install the proper Ruby and PostgreSQL database versions.

Clone this repo.

```sh
git clone https://github.com/crimethinc/website.git
cd website
```

Then run the `bootstrap` script.

```sh
./script/bootstrap
```

### Setup script

After you’ve `bootstrap`ed, you’ll need to `setup`.
The `setup` setups the Rails environment (creates, migrates and seeds databases, then clears logs and tmp).

```sh
./script/setup
```

### Server script

The `server` script starts the Rails server on port `3000` (which uses **Puma**).

```sh
./script/server
```

### Update script

Periodically, you can run the `update` script to check for new versions of dependencies and to update the database schema. If you ever get a `PendingMigrationError`, run this script to migrate your database.

```sh
./script/update
```

### Test script

Run the test suite using the `test` script.

```sh
./script/test
```

### Test server script

To run a process which runs tests on file change

```sh
./script/test_server
```

### Console script

If you need to use the app’s console (in any environment), use the `console` script.

```sh
./script/console
```

If you need to use the console on a remote instance of the app, specific its environment name as the first argument.

```sh
./script/console production
```

Or

```sh
./script/console staging
```

### CI Build script

Setup environment for CI to run tests. This is primarily designed to run on the continuous integration server.

```sh
./script/cibuild
```

### Database seed script

Drop the database, rebuild it, and fill it with seed data.

```sh
./script/seed
```

***

## How to guides…

- [Add a new language to `/languages`](/blob/main/docs/languages.md)
- [Add a new locale](/blob/main/docs/locales.md)
- [Publishing workflow](/blob/main/docs/publishing.md)
- [To Change Everything, language translations](/blob/main/docs/to-change-everything-guide.md)

## Additional documentaion

- [For Docker based development](/blob/main/docs/docker.md) docs here
- ["Can’t Find Postgresql" Error](/blob/main/docs/docker.md) docs here
- ["Can’t Load Gem from /vendor" Error](/blob/main/docs/gem-vendor.md) docs here
- [Site’s running locally, but there are no articles?](/blob/main/docs/development-data.md) docs here

***

## Contributing

See [CONTRIBUTING.md](https://github.com/crimethinc/website/blob/main/CONTRIBUTING.md).

If you find bugs, have feature requests or questions, please
[file an issue](https://github.com/crimethinc/website/issues).

## Code of Conduct

Everyone interacting in all of CrimethInc. codebases, issue trackers, chat rooms, and mailing lists is expected to follow the
[CrimethInc. development code of conduct](https://github.com/crimethinc/website/blob/main/CODE_OF_CONDUCT.md).

## License

**PUBLIC DOMAIN**

Your heart is as free as the air you breathe. \\
The ground you stand on is liberated territory.

In legal text, **CrimethInc. website** is dedicated to the public domain
using Creative Commons — CC0 1.0 Universal.

[https://creativecommons.org/publicdomain/zero/1.0](https://creativecommons.org/publicdomain/zero/1.0 "Creative Commons — CC0 1.0 Universal")
