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

`ocserver` will automatically pick a free port, start a new oc server using sqlite on that port and display the url to the oc instance
`ocserver mysql` will also start a mysql container and configure the oc instance to use mysql

## License

This project is distributed under [GNU Affero General Public License, Version 3][AGPLv3].
[ownCloud]: https://owncloud.org/
[AGPLv3]: https://github.com/jchaney/owncloud/blob/master/LICENSE
[this.project_docker_hub_url]: https://registry.hub.docker.com/u/icewind1991/owncloud-dev/
[this.project_github_url]: https://github.com/icewind1991/owncloud-dev
