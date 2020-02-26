local lapis = require("lapis")
local app = lapis.Application()
app:enable("etlua")                                 -- Enable etlua templates
app.layout = require("views.layout")                -- Use etlua layout template

--[ Package processing ]--
local fileParser = require("fileParser")
local packages, packagesByName = fileParser("/var/lib/dpkg/status")
table.sort(packages, function(a, b)                 -- Sort packages alphabetically
  return a["Package"] < b["Package"]
end)

app:get("index", "/", function(self)
  self.packages = packages
  return { render = "index" }                       -- Render "index" template
end)

app:get("package", "/package/:name", function(self)
  local package = packagesByName[self.params.name]  -- Look for the package in our list
  if not package then
    self:write({"Not Found", status = 404})         -- Returns a basic "Not Found" message
  else
    self.package = package
    self.packagesByName = packagesByName
    self.page_title = string.format("Package: %s", package["Package"])
    return { render = "package" }                   -- Render "package" template
  end
end)

return app
