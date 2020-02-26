# Reaktor Junior pre-assignment #
## Overview ##
This project is my submission to [Reaktor's Junior pre-assignment](https://www.reaktor.com/junior-dev-assignment/), implemented using [Lua](https://www.lua.org/) with [Lapis](https://leafo.net/lapis/).

## Running the app ##
The dockerfile is set up for running the app in [Heroku](https://www.heroku.com/) by overriding the port defined in Lapis' config from the `PORT` environment variable; if this environment variable is not defined, the app will fail to start.

You can run the app using `docker-compose` normally, as `docker-compose.yml` is configured to set the environment variable to `8080`.

**`docker-compose` currently also creates a volume for the app for hot-reloading code.**