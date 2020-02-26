local config = require("lapis.config")

config("development", {
    port = 8080 -- This will be overridden from Dockerfile
})