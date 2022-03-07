# ASCII-Canvas

This is an application built with **Elixir** to draw **ASCII geometries** that provides:

- A web API to interact with a canvas
- A client to draw your canvas

## Contents

- [Contents](#contents)
- [Requirements](#requirements)
- [Configuration](#configuration)
- [API endpoints](#api-endpoints)
- [Client](#client)
- [How to install](#how-to-install)
- [Run application](#run-application)
- [Run tests](#run-tests)

## Requirements

### Running container
- Docker
- Docker-compose

### Running locally
- Elixir 1.13
- Postgres

## Configuration

The configuration to run with docker-compose can be found in the `.docker_env` file.
If running locally, the configurations can be found at `/config/dev.exs` (`/config/test.exs` if running tests).

## API endpoints

A postman collection can be found in `/aux/AsciiCanvas.postman_collection.json`. Below are the API endpoints.

- Create new **canvas** : `POST localhost:4000/api/canvas/`

Body example:
```json
{
    "max_size_x": 22,
    "max_size_y": 9
}
```

- Add new **drawing commands**: `POST localhost:4000/api/canvas/:canvas_id`

Body example:
```json
{
    "command": {
        "type": "rect",
        "coords": [
            5,
            5
        ],
        "height": 3,
        "width": 5,
        "out": "X",
        "fill": "X"
    }
}
```

- Get drawing from canvas: `GET localhost:4000/api/canvas/:canvas_id`

Return example:
```json
{
    "drawing": "              XXXXXXX\n              XXXXXXX\n              XXXXXXX\nOOOOOOOO      XXXXXXX\nO      O      XXXXXXX\nO    XXXXX    XXXXXXX\nOOOOOXXXXX\n     XXXXX"
}
```

## Client
You can get the drawing from a specific canvas accessing [`localhost:4000`](http://localhost:4000) from your browser. Just type the `canvas id` and get the result.

## How to install

- With docker-compose:
```bash
$ make compose-build
```

- Locally:
```bash
$ mix deps.get
$ mix ecto.setup
```

## Run application

- With docker-compose:
```bash
$ make compose-up
```

- Locally:
```bash
$ mix phx.server
```

## Run tests

- With docker-compose:
```bash
$ make compose-test
```
- Locally:
```bash
$ mix test
```
