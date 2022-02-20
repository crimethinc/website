# Site’s running locally, but no articles are showing

Stop the server, [seed the database](/#database-seed-script), then run the server script again.
This will import (scrubbed) production data into your local development database.

```sh
./script/seed
./script/server
```

