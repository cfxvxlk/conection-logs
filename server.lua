local function GetPlayerIdentifiers(source)
    local identifiers = {}
    local steamID = "Unknown"
    local discordID = "Unknown"
    local xboxID = "Unknown"
    local fivemID = "Unknown"
    local license = "Unknown"
    local ipv4 = "Unknown"
    local ipv6 = "Unknown"
    
    for _, id in ipairs(GetPlayerIdentifiers(source)) do
        if string.find(id, "steam:") then
            steamID = string.sub(id, 7)
        elseif string.find(id, "discord:") then
            discordID = string.sub(id, 8)
        elseif string.find(id, "xbl:") then
            xboxID = string.sub(id, 5)
        elseif string.find(id, "fivem:") then
            fivemID = string.sub(id, 6)
        elseif string.find(id, "license:") then
            license = string.sub(id, 9)
        elseif string.find(id, "ip:") then
            local ip = string.sub(id, 4)
            if string.find(ip, ":") then
                ipv6 = ip
            else
                ipv4 = ip
            end
        end
    end
    
    return {
        steam = steamID,
        discord = discordID,
        xbox = xboxID,
        fivem = fivemID,
        license = license,
        ipv4 = ipv4,
        ipv6 = ipv6
    }
end

local function ShouldBypassUser(discordID)
    if not Config.BypassDiscordIDs or discordID == "Unknown" then
        return false
    end
    
    for _, bypassID in ipairs(Config.BypassDiscordIDs) do
        if discordID == bypassID then
            return true
        end
    end
    
    return false
end

local function SendDiscordWebhook(playerName, identifiers)
    if not Config.WebhookURL or Config.WebhookURL == "YOUR_DISCORD_WEBHOOK_URL_HERE" then
        print("^1[" .. Config.ServerAbbreviation .. "] Webhook URL not configured in config.lua^7")
        return
    end
    
    if ShouldBypassUser(identifiers.discord) then
        print("^3[" .. Config.ServerAbbreviation .. "] Connection from bypassed user ignored: " .. playerName .. " (Discord: " .. identifiers.discord .. ")^7")
        return
    end
    
    local discordID = identifiers.discord ~= "Unknown" and identifiers.discord or "Unknown"
    local header = string.format("\x1b[0;34m[" .. Config.ServerAbbreviation .. "-Connection Log : %s]", discordID)
    
    local description = string.format([[[ansi]

%s

\x1b[0;97;48;5;1m+ Player Name: %s                                          
\x1b[0;97;48;5;1m+ Discord ID: %s                          
\x1b[0;97;48;5;1m+ IP: %s                                    
\x1b[0;97;48;5;1m+ CFX ID: %s
\x1b[0;97;48;5;1m+ Xbox ID: %s
\x1b[0;97;48;5;1m+ Steam ID: %s
\x1b[0;97;48;5;1m+ License: %s
\x1b[0;97;48;5;1m+ Time: %s
```]], 
        header,
        playerName,
        identifiers.discord,
        identifiers.ipv4,
        identifiers.fivem,
        identifiers.xbox,
        identifiers.steam,
        identifiers.license,
        os.date('%Y-%m-%d %H:%M:%S')
    )
    
    local embedColor = tonumber(Config.EmbedColor:gsub("#", ""), 16) or 5793266
    
    local embed = {
        {
            ["description"] = description,
            ["color"] = embedColor,
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%S.000Z")
        }
    }
    
    PerformHttpRequest(Config.WebhookURL, function(errorCode, resultData, resultHeaders)
        if errorCode ~= 200 then
            print("^1[" .. Config.ServerAbbreviation .. "] Failed to send webhook. Error code: " .. errorCode .. "^7")
        else
            print("^2[" .. Config.ServerAbbreviation .. "] Connection log sent successfully^7")
        end
    end, 'POST', json.encode({
        username = Config.WebhookUsername,
        avatar_url = Config.WebhookAvatarURL, 
        embeds = embed
    }), {['Content-Type'] = 'application/json'})
end

local function SendDisconnectWebhook(playerName, identifiers, reason)
    if not Config.DisconnectWebhookURL or Config.DisconnectWebhookURL == "YOUR_DISCONNECT_WEBHOOK_URL_HERE" then
        print("^1[" .. Config.ServerAbbreviation .. "] Disconnect Webhook URL not configured in config.lua^7")
        return
    end
    
    if ShouldBypassUser(identifiers.discord) then
        return
    end
    
    local discordID = identifiers.discord ~= "Unknown" and identifiers.discord or "Unknown"
    local header = string.format("\x1b[0;34m[" .. Config.ServerAbbreviation .. "-Disconnect Log : %s]", discordID)
    
    local description = string.format([[[ansi]

%s

\x1b[0;97;48;5;1m+ Player Name: %s                                          
\x1b[0;97;48;5;1m+ Discord ID: %s                          
\x1b[0;97;48;5;1m+ IP: %s                                    
\x1b[0;97;48;5;1m+ CFX ID: %s
\x1b[0;97;48;5;1m+ Xbox ID: %s
\x1b[0;97;48;5;1m+ Steam ID: %s
\x1b[0;97;48;5;1m+ License: %s
\x1b[0;97;48;5;1m+ Time: %s
\x1b[0;97;48;5;1m+ Reason: %s
```]], 
        header,
        playerName,
        identifiers.discord,
        identifiers.ipv4,
        identifiers.fivem,
        identifiers.xbox,
        identifiers.steam,
        identifiers.license,
        os.date('%Y-%m-%d %H:%M:%S'),
        reason or "Unknown"
    )
    
    local embedColor = tonumber(Config.EmbedColor:gsub("#", ""), 16) or 5793266
    
    local embed = {
        {
            ["description"] = description,
            ["color"] = embedColor,
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%S.000Z")
        }
    }
    
    PerformHttpRequest(Config.DisconnectWebhookURL, function(errorCode, resultData, resultHeaders)
        if errorCode ~= 200 then
            print("^1[" .. Config.ServerAbbreviation .. "] Failed to send disconnect webhook. Error code: " .. errorCode .. "^7")
        else
            print("^2[" .. Config.ServerAbbreviation .. "] Disconnect log sent successfully^7")
        end
    end, 'POST', json.encode({
        username = Config.WebhookUsername,
        avatar_url = Config.WebhookAvatarURL, 
        embeds = embed
    }), {['Content-Type'] = 'application/json'})
end

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local source = source
    
    Citizen.Wait(100)
    
    local identifiers = GetPlayerIdentifiers(source)
    
    if Config.LogConnections then
        SendDiscordWebhook(name, identifiers)
    end
    
    deferrals.done()
end)

AddEventHandler('playerDropped', function(reason)
    local source = source
    local playerName = GetPlayerName(source)
    local identifiers = GetPlayerIdentifiers(source)
    
    if Config.LogConnections then
        SendDisconnectWebhook(playerName, identifiers, reason)
    end
end)

AddEventHandler('playerSpawned', function()
    local source = source
    local playerName = GetPlayerName(source)
    local identifiers = GetPlayerIdentifiers(source)
    
    if Config.LogConnections then
        Citizen.SetTimeout(5000, function()
            SendDiscordWebhook(playerName, identifiers)
        end)
    end
end)

if GetConvar('isClient', 'false') == 'true' then
    return
end

print("^2[" .. Config.ServerAbbreviation .. "] Connection Logger Script Loaded^7")
print("^3[" .. Config.ServerAbbreviation .. "] Webhook URL: " .. (Config.WebhookURL and "Set" or "Not Set") .. "^7")
print("^3[" .. Config.ServerAbbreviation .. "] Disconnect Webhook URL: " .. (Config.DisconnectWebhookURL and "Set" or "Not Set") .. "^7")
