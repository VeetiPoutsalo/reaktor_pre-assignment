return function(filename)
    local function trim(str) return string.match(str, "^%s*(.-)%s*$") end
    local packages = {}
    local packagesByName = {}
    for line in io.lines(filename) do
        local field, data = line:match("(.-): (.*)")
        if field then
            if field == "Package" then
                packages[#packages + 1] = {[field] = data}
                packagesByName[data] = packages[#packages]
            elseif field == "Depends" then
                data = data:gsub("%s?%(.-%)%s?", "")
                local dependencies = {}
                for dependency in data:gmatch("([^,]*)") do
                    if dependency ~= "" then
                        local alternatives = {}
                        for alternative in dependency:gmatch("([^|]*)") do
                            if alternative ~= "" then
                                alternatives[#alternatives + 1] = trim(alternative)
                            end
                        end
                        dependencies[#dependencies + 1] = alternatives
                    end
                end
                packages[#packages][field] = dependencies
            else
                assert(packages[#packages])
                packages[#packages][field] = data
            end
        end
    end
    for i = 1, #packages do
        local package = packages[i]
        if package["Depends"] then
            for j = 1, #package["Depends"] do
                for k = 1, #package["Depends"][j] do
                    local dependency = package["Depends"][j][k]
                    if packagesByName[dependency] then
                        local reverseDepends = packagesByName[dependency]["Reverse Depends"]
                        if reverseDepends then
                            reverseDepends[#reverseDepends + 1] = {package["Package"]}
                        else
                            packagesByName[dependency]["Reverse Depends"] = {{package["Package"]}}
                        end
                    end
                end
            end
        end
    end
    return packages, packagesByName
end