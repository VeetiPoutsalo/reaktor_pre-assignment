return function(filename)
    local function trim(str) return string.match(str, "^%s*(.-)%s*$") end   -- Trim extra whitespace from the beginning and end of the given string
    local packages = {}
    local packagesByName = {}                                               -- Name-indexed table
    local lastField
    for line in io.lines(filename) do                                       -- Loop over all lines in the file (This should work for huge files too)
        local field, data = line:match("(.-): (.*)")                        -- Extract field and data using regex
        if field then
            lastField = field
            if field == "Package" then                                      -- "Package" field creates a new package entry
                packages[#packages + 1] = {[field] = data}
                packagesByName[data] = packages[#packages]                  -- The new entry is also added to the name-indexed table
            elseif field == "Depends" then                                  -- Parse dependencies
                data = data:gsub("%s?%(.-%)%s?", "")                        -- Remove version numbers as we don't need them
                local dependencies = {}
                for dependency in data:gmatch("([^,]*)") do                 -- Extract dependencies separated by a comma
                    if dependency ~= "" then
                        local alternatives = {}
                        for alternative in dependency:gmatch("([^|]*)") do  -- Extract each alternative dependency separated by a "|" character
                            if alternative ~= "" then
                                alternatives[#alternatives + 1] = trim(alternative)
                            end
                        end
                        dependencies[#dependencies + 1] = alternatives      -- The dependencies are added to the list as a table of alternatives
                    end
                end
                packages[#packages][field] = dependencies                   -- Add the dependency list to the package
            else
                packages[#packages][field] = data                           -- If no special handling is defined, just stuff the whole data into the correct field
            end
        elseif lastField == "Description" then                              -- If a new field wasn't defined, parse long comment
            local content = trim(line)
            if content ~= "" then
                packages[#packages]["Long Description"] = packages[#packages]["Long Description"] or {""}   -- Create new field if it doesn't exist
                local longDesc = packages[#packages]["Long Description"]
                if content == "." then                                                                      -- A "." line is a line break
                    longDesc[#longDesc + 1] = ""                                                            -- An empty line is added twice as new content will be concatenated into the second one
                    longDesc[#longDesc + 1] = ""
                else
                    longDesc[#longDesc] = longDesc[#longDesc] .. " " .. content                             -- Concatenate the comment content to the previous line
                end
            end
        end
    end
    for i = 1, #packages do                                                 -- Iterate all packages for reverse dependencies
        local package = packages[i]
        if package["Depends"] then
            for j = 1, #package["Depends"] do
                for k = 1, #package["Depends"][j] do                        -- Iterate the package's all dependencies, including alternatives
                    local dependency = package["Depends"][j][k]
                    if packagesByName[dependency] then                      -- If the dependency exists in our package list, we can add the reverse dependency
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
    return packages, packagesByName                                         -- Return both the package list and the name-indexed list
end