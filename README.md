# docker-owncloud-dev

Docker image for [ownCloud][] for development

This image pulls the ownCloud source from the host filesystem while maintaining a seperate config and data directory which makes it easy to test your local code in a clean ownCloud instance.

The build instructions are tracked on [GitHub][this.project_github_url].
Automated builds are hosted on [Docker Hub][this.project_docker_hub_url].

## Getting the image

You have two options to get the image:

1. Build it yourself with `make build`.
2. Download it via `docker pull icewind1991/owncloud-dev` ([automated build][this.project_docker_hub_url]).

## ownCloud up and running

`docker run --privileged -d -p 8123:80 -v /srv/http/owncloud:/owncloud-shared icewind1991/owncloud-dev`

Replace `/srv/http/owncloud` with the location of the ownCloud source

## ocserver command

Edit `misc/ocserver` with the location of the ownCloud source and copy or symlink it to somewhere without your $PATH

### Database

You can specify the database backend to be used by providing it as argument to the `ocserver` command.
The following database backends are supported `sqlite` (default), `mysql`, `pgsql` and `oci`.

```
ocserver mysql
```

For any database backends besides sqlite a seperate container will be started for the database.

### PHP version

You can specificy php version 5 (5.6) or 7 by passing it as seccond argument to `ocserver` (defaults to 5)

```
ocserver mysql 7
```

### Blackfire integration

You can enable [blackfire.io](https://blackfire.io) integration by defining BLACKFIRE_SERVER_ID and BLACKFIRE_SERVER_TOKEN as enviroment variables or starting a "blackfire" container beforehand.

See https://blackfire.io/docs/integrations/docker#running-the-agent for more information about using the blackfire agent with docker

Current blackfire only works with php5

## octests

`misc/octests` starts a new owncloud server in a container and executes the php test suite on it.

`octests` takes the same arguments for database and php version

It expects `ocserver` to be located in `$PATH`

## License

This project is distributed under [GNU Affero General Public License, Version 3][AGPLv3].
[ownCloud]: https://owncloud.org/
[AGPLv3]: https://github.com/jchaney/owncloud/blob/master/LICENSE
[this.project_docker_hub_url]: https://registry.hub.docker.com/u/icewind1991/owncloud-dev/
[this.project_github_url]: https://github.com/icewind1991/owncloud-dev
