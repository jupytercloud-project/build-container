# build-container
Container with the tools to build qemu images

## Usage
```bash
$ DKR=https://github.com/jupytercloud-project/build-container/releases/download/0.0.1/jupytercloud-project_build-container_latest.dkr
$ curl --location ${DKR} | docker load
Loaded image: jupytercloud-project/build-container:latest
$ docker run -it jupytercloud-project/build-container:latest sh
/ #
```
