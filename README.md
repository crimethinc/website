# CrimethInc. website

Ruby on Rails app that powers https://crimethinc.com

## Development

[![GitHub Actions CI Build Status](https://github.com/crimethinc/website/workflows/Tests/badge.svg)](https://github.com/crimethinc/website/actions?workflow=Tests)
[![Maintainability](https://api.codeclimate.com/v1/badges/22ef4ea6475be7057b87/maintainability)](https://codeclimate.com/github/crimethinc/website/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/22ef4ea6475be7057b87/test_coverage)](https://codeclimate.com/github/crimethinc/website/test_coverage)

## Short Version

**First things first**, [Strap](https://macos-strap.herokuapp.com) your computer’s development environment.

```sh
open https://macos-strap.herokuapp.com/strap.sh
```

Then…

```sh
bash ~/Downloads/strap.sh
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

```
git clone https://github.com/crimethinc/website.git
cd website
```

Then run the `bootstrap` script.

```
./script/bootstrap
```

### Setup script

After you’ve `bootstrap`ed, you’ll need to `setup`.
The `setup` setups the Rails environment (creates, migrates and seeds databases, then clears logs and tmp).

```
./script/setup
```

#### Can’t Load Gem from /vendor Error

If you get an error that some gem can’t be loaded, like `bcrypt_ext`, follow these steps to rebuild this repo’s dev setup. From the root directory of this repo:

```
rm -rf vendor/gems
rm -rf .bundle
./script/setup
```

### Server script

The `server` script starts the Rails server on port `3000` (which uses **Puma**).

```
./script/server
```

#### Site’s running but no articles?

Stop the server, [seed the database](#database-seed-script), then run the server script again.
This will import (scrubbed) production data into your local development database.

```
./script/seed
./script/server
```

#### Can’t Find Postgresql Error

See [Postgres](/blob/main/docs/docker.md) docs here.

### Update script

Periodically, you can run the `update` script to check for new versions of dependencies and to update the database schema. If you ever get a `PendingMigrationError`, run this script to migrate your database.

```
./script/update
```

### Test script

Run the test suite using the `test` script.

```
./script/test
```

### Test server script

To run a process which runs tests on file change

```
./script/test_server
```

### Console script

If you need to use the app’s console (in any environment), use the `console` script.

```
./script/console
```

If you need to use the console on a remote instance of the app, specific its environment name as the first argument.

```
./script/console production
```

Or

```
./script/console staging
```

### CI Build script

Setup environment for CI to run tests. This is primarily designed to run on the continuous integration server.

```
./script/cibuild
```

### Database seed script

Drop the database, rebuild it, and fill it with seed data.

```
./script/seed
```

## Development Setup with Docker

See [Docker based development](/blob/main/docs/docker.md) docs here.

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
