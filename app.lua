local lapis = require("lapis")
local app = lapis.Application()
app:enable("etlua")

local fileParser = require("fileParser")
local packages, packagesByName = fileParser("/var/lib/dpkg/status")
table.sort(packages, function(a, b)
  return a["Package"] < b["Package"]
end)

app:get("index", "/", function(self)
  self.packages = packages
  return { render = "index" }
end)

app:get("package", "/package/:name", function(self)
  local package = packagesByName[self.params.name]
  if not package then
    self:write({"Not Found", status = 404})
  else
    self.package = package
    self.packagesByName = packagesByName
    return { render = "package" }
  end
end)

return app
