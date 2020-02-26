return function(filename)
    local packages = {}
    for line in io.lines(filename) do
        local field, data = line:match("(.-): (.*)")
        if field then
            if field == "Package" then
                packages[#packages + 1] = {[field] = data}
            elseif field == "Depends" then
                data = data:gsub("%s?%(.-%)%s?", "")
                local dependencies = {}
                for dependency in data:gmatch("([^,]*)") do
                    if dependency ~= "" then
                        local alternatives = {}
                        for alternative in dependency:gmatch("([^|]*)") do
                            if alternative ~= "" then
                                alternatives[#alternatives + 1] = alternative
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
    return packages
end