FROM bitwalker/alpine-elixir-phoenix:latest

WORKDIR /app

COPY mix.exs ./app
COPY mix.lock ./app

COPY . /app

RUN mix deps.get

EXPOSE 4000

RUN chmod +x entrypoint.sh

CMD ["./entrypoint.sh"]