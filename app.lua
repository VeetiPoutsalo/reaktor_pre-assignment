local lapis = require("lapis")
local app = lapis.Application()
app:enable("etlua")

local fileParser = require("fileParser")
local packages = fileParser("/var/lib/dpkg/status")
table.sort(packages, function(a, b)
  return a["Package"] < b["Package"]
end)

app:get("/", function(self)
  self.packages = packages
  return { render = "packages" }
end)

return app
