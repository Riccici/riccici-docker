# riccici-docker

The Dockerfiles I utilized are as follows:

### helix-p4d

A Docker image for the Helix Core server.

The source code reference is taken from [sourcegraph/helix-docker](https://github.com/sourcegraph/helix-docker).

The Dockerfile reference is derived from [Official Perforce Linux package-based installation](https://www.perforce.com/manuals/p4sag/Content/P4SAG/install.linux.packages.install.html).

##### Dockerfile changes

Certain modifications have been made in the Dockerfile to build the image:

- The save path for `perforce.pubkey` has been altered from `/usr/share/keyrings/perforce.gpg` to `/etc/apt/trusted.gpg.d/perforce.gpg` in order to prevent pub key errors durning `apt-get update`.
- The stdout of `tee` has been redirected to `/dev/null` to eliminate output in build log

There are additional changes in the Dockerfile for Github Actions:

- The installation of `apt-utils` is performed to avoid certain errors during image building.
- `DEBIAN_FRONTEND` and `DEBCONF_NOWARNINGS` have been added to bypass unnecessary warnings during image building.

##### Scripts changes

- The server is forcefully initiated in Unicode mode.
- The server is forcefully initiated in case-sensitive mode.
- The super user's username and password are set to `admin` by default.

##### Usage

simple test run:

```bash
docker run --rm -p 1666:1666 ghcr.io/riccici/helix-p4d:latest
```

All environment variables version:

```bash
docker run -d \
    -p 1666:1666 \
    -e NAME=test-project-name \
    -e P4NAME=helix-core-master \
    -e P4PORT=1666 \
    -e P4USER=admin \
    -e P4PASSWD=qwer1234 \
    -v ~/.helix-p4d:/p4 \
    ghcr.io/riccici/helix-p4d:latest
```
