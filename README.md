# samapi-docker
[![CI](https://github.com/siemdejong/samapi-docker/actions/workflows/ci.yaml/badge.svg)](https://github.com/siemdejong/samapi-docker/actions/workflows/ci.yaml)

Provides an unofficial Docker image with [`samapi`](https://github.com/ksugar/samapi).
Images are generated monthly.

Please cite the original repository if you use this docker image.

## Example usage

### From the terminal

```sh
docker run \
    --gpus all \
    -p 8000:8000 \
    -v ~/.samapi:/.samapi \
    ghcr.io/siemdejong/samapi-docker
```
- select gpus with `--gpus ...`
- map ports with `-p ...:8000`
- mount a local directory (e.g. ~/.samapi) to `/.samapi` to cache model weights.
- pass `--workers=...` to change the default number of workers (2).

### Different CUDA version
Images have are tagged by cuda version (`*-cu118` or `*-cu128`).
`latest` always refers to `*-cu118` to ensure compatibility.
