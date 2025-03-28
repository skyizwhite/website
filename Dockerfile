FROM fukamachi/qlot

WORKDIR /app
COPY . /app

RUN apt-get update && apt-get install -y --no-install-recommends build-essential curl libev-dev

RUN mkdir -p ./bin \
  && curl -sLO https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-linux-x64 \
  && chmod +x tailwindcss-linux-x64 \
  && mv tailwindcss-linux-x64 ./bin/tailwindcss

RUN ./bin/tailwindcss -i ./public/style/global.css -o ./public/style/dist.css --minify

RUN qlot install --quiet

EXPOSE 3000

ENTRYPOINT [".qlot/bin/clackup", "--system", "hp", "--server", "woo", "--address", "0.0.0.0", "--port", "3000", "src/app.lisp"]
