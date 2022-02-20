# Docker based development

If you’re doing development on Linux, you may find it more comfortable to run the website in a container. You can do this easily using Docker.

First, you’ll need to have a Postgres instance running. If you’re just doing development and have no need to persist database changes to disk, you can run one like and print out its IP address like this:

```sh
docker run -d --name postgres postgres:latest
docker inspect -f '{{ .NetworkSettings.IPAddress }}' postgres
```

We’re going to assume that the Postgres container’s IP address was `172.17.0.2` for the next few steps; if that’s not the case, be sure to replace it as appropriate.

Next, you need to build the Docker image, create, and then seed the database:

```sh
docker build -t crimethinc .
docker run --rm postgres:latest psql -h 172.17.0.2 -U postgres -c 'create database crimethinc;'
docker run --rm -e DATABASE_URL=postgresql://postgres@172.17.0.2/crimethinc crimethinc bin/rails db:migrate db:seed
```

Now, you can run the app:

```sh
docker run -it --rm -e DATABASE_URL=postgresql://postgres@172.17.0.2/crimethinc -p 3000:3000 crimethinc
```

You’ll now be able to access the app at [http://localhost:3000](http://localhost:3000).

When you’re done, you can stop and remove your Postgres container:

```sh
docker stop postgres
docker rm postgres
```
