# Error: Can’t Find Postgresql

If you get an error when starting the server that Rails can’t connect to the Postgresql server, you can fix it with these steps. (Assuming, you’re on a Mac and use [Homebrew](https://brew.sh)).

First, double check that `postgresql` is running:

```sh
brew services
```

If it lists an error, try restarting:

```sh
brew services restart postgresql
```

If that doesn't work, check the end of your logs for a version incompatibility:

```sh
tail /usr/local/var/log/postgres.log
```

If you see an error that looks like this...

```sh
FATAL:  database files are incompatible with server
DETAIL:  The data directory was initialized by PostgreSQL version 12, which is not compatible with this version 13.0.
```

...then run this command next:

```sh
brew postgresql-upgrade-database
```

If that *still* doesn't work, you can try to completely reinstall using the following steps.

**WARNING:** These step will DELETE all Postgresql databases / software and re-install Postgresql from scratch.
If you have data in your local Postgresql database that you can’t re-create after deleting it, you’ll want to run some backups first. (That’s an exercise for the reader.)

```sh
brew services stop postgresql
brew uninstall postgresql
rm -rf /usr/local/var/postgres/
brew install postgresql
brew services start postgresql
```
