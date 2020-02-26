local lapis = require("lapis")
local app = lapis.Application()
app:enable("etlua")

local fileParser = require("fileParser")
local packages = fileParser("/var/lib/dpkg/status")

app:get("/", function(self)
  self.packages = packages
  return { render = "packages" }
end)

return app
