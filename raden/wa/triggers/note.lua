local events = {CHAT_MSG_ADDON}
local trigger = function(event, addonkey, msg, ...)
    local split = function(inputstr, sep)
        sep = sep or " "
        local t = {}
        for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
            table.insert(t, str)
        end
        return t
    end
    if (addonkey == "EXRTADD") then
        aura_env.getNoteMsgs(split(msg, "\t")[3])
    end
end

