# docker-owncloud-dev

Docker image for [ownCloud][] for development

The build instructions are tracked on [GitHub][this.project_github_url].
Automated builds are hosted on [Docker Hub][this.project_docker_hub_url].

## Getting the image

You have two options to get the image:

1. Build it yourself with `make build`.
2. Download it via `docker pull icewind1991/owncloud-dev` ([automated build][this.project_docker_hub_url]).

## ownCloud up and running

`docker run --privileged -d -p 8123:80 -v /srv/http/owncloud:/owncloud-shared icewind1991/owncloud-dev`

Replace `/srv/http/owncloud` with the location of the ownCloud source

## License

This project is distributed under [GNU Affero General Public License, Version 3][AGPLv3].
[ownCloud]: https://owncloud.org/
[AGPLv3]: https://github.com/jchaney/owncloud/blob/master/LICENSE
[this.project_docker_hub_url]: https://registry.hub.docker.com/u/icewind1991/owncloud-dev/
[this.project_github_url]: https://github.com/icewind1991/owncloud-dev
