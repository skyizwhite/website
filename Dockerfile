FROM fukamachi/qlot AS build

ARG TARGETARCH
ARG TW_VERSION=4.3.0

RUN apt-get update \
  && apt-get install -y --no-install-recommends build-essential curl libev-dev \
  && rm -rf /var/lib/apt/lists/*

RUN case "${TARGETARCH:-amd64}" in \
      amd64) tw=x64 ;; \
      arm64) tw=arm64 ;; \
      *) echo "no Tailwind binary for ${TARGETARCH}" >&2; exit 1 ;; \
    esac \
  && curl -fsSL "https://github.com/tailwindlabs/tailwindcss/releases/download/v${TW_VERSION}/tailwindcss-linux-${tw}" \
       -o /usr/local/bin/tailwindcss \
  && chmod +x /usr/local/bin/tailwindcss

WORKDIR /app

COPY . /app
RUN qlot install

RUN tailwindcss -i ./assets/style/global.css -o ./assets/style/dist.css --minify

RUN qlot exec sbcl --non-interactive \
      --eval '(ql:quickload "website")' \
      --eval '(website:save-executable "/app/website")'

FROM debian:bookworm-slim

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
       ca-certificates curl libev4 libssl3 libzstd1 \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=build /app/website /usr/local/bin/website
COPY --from=build /app/assets ./assets

EXPOSE 3000

ENTRYPOINT ["website"]
