return function(filename)
    local packages = {}
    for line in io.lines(filename) do
        local field, data = line:match("(.-): (.*)")
        if field then
            if field == "Package" then
                packages[#packages + 1] = {[field] = data}
            else
                assert(packages[#packages])
                packages[#packages][field] = data
            end
        end
    end
    return packages
end