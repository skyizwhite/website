FROM fukamachi/qlot

# 作業ディレクトリ
WORKDIR /app

# ソース全体をコピー
COPY . /app

# Tailwind CLI をダウンロード＆インストール
RUN mkdir -p ./bin \
  && curl -sLO https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-linux-x64 \
  && chmod +x tailwindcss-linux-x64 \
  && mv tailwindcss-linux-x64 ./bin/tailwindcss

# Tailwind CSS をビルド（global.css -> dist.css）
RUN ./bin/tailwindcss -i ./public/style/global.css -o ./public/style/dist.css --minify

# Qlot依存関係のインストール
RUN qlot install

# ポート開放
EXPOSE 3000

# アプリ起動
CMD [".qlot/bin/clackup", "--system", "hp", "--server", "woo", "--port", "3000", "src/app.lisp"]
