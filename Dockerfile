FROM fukamachi/qlot

ARG TW_VERSION=4.1.3
ARG TW_BIN=./bin/tailwindcss

WORKDIR /app
COPY . /app

RUN apt-get update && apt-get install -y --no-install-recommends build-essential curl wget libev-dev

RUN mkdir -p ./bin \
  && curl -sLO https://github.com/tailwindlabs/tailwindcss/releases/download/v${TW_VERSION}/tailwindcss-linux-x64 \
  && chmod +x tailwindcss-linux-x64 \
  && mv tailwindcss-linux-x64 ${TW_BIN}

RUN ${TW_BIN} -i ./assets/style/global.css -o ./assets/style/dist.css --minify

RUN qlot install --quiet --no-color

RUN chmod +x entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["./entrypoint.sh"]
