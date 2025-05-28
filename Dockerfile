# use ubuntu20.04 as ubuntu22.04 doesn't go well with nvrtc
ARG NVIDIA_CUDA_TAG=11.8.0-base-ubuntu20.04

FROM nvidia/cuda:${NVIDIA_CUDA_TAG}

ARG PYTHON_VERSION=3.10
ARG PYTORCH_INDEX_URL=https://download.pytorch.org/whl/cu118
ARG COMPATIBLE_TORCH_VERSION=2.3.1

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
ENV UV_LINK_MODE=copy
ENV UV_VENV=/opt/venv
ENV UV_CACHE_DIR=/root/.cache/uv
ENV PATH="$UV_VENV/bin:$PATH"

RUN --mount=type=cache,target=${UV_CACHE_DIR} \
    uv venv --python ${PYTHON_VERSION} ${UV_VENV} \
    && uv pip install \
        "torch~=${COMPATIBLE_TORCH_VERSION}" \
        torchvision \
        --index-url ${PYTORCH_INDEX_URL} \
    && uv pip install git+https://github.com/ksugar/samapi.git

ENV SAMAPI_ROOT_DIR=/.samapi
RUN mkdir -p /.samapi
VOLUME ["/.samapi"]

HEALTHCHECK --interval=5m --timeout=3s \
    CMD curl -f http://localhost/sam/ || exit 1
EXPOSE 8000
ENTRYPOINT ["uv", "run", "uvicorn", "--host=0.0.0.0", "samapi.main:app"]
CMD ["--workers=2"]
