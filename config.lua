Config = {}

-- Server Configuration
Config.ServerAbbreviation = "LunaStudiosNET" 

-- Discord Webhook Configuration
Config.WebhookURL = "YOUR_DISCORD_WEBHOOK_URL_HERE" 
Config.DisconnectWebhookURL = "YOUR_DISCONNECT_WEBHOOK_URL_HERE" 

-- Webhook Appearance Configuration
Config.WebhookUsername = Config.ServerAbbreviation .. "Luna Logger"
Config.WebhookAvatarURL = "https://cdn.discordapp.com/icons/YOUR_SERVER_ID/YOUR_SERVER_ICON.png"


-- Embed Configuration
Config.EmbedColor = "#58A4B0" -- Hex color format 
Config.EmbedTitle = Config.ServerAbbreviation .. "-Connection Log"
Config.DisconnectEmbedTitle = Config.ServerAbbreviation .. "-Disconnect Log"

-- Logging Configuration
Config.LogConnections = true
Config.LogIPAddresses = true
Config.LogIdentifiers = true

-- Security Configuration
Config.PreventDumping = true 

-- Bypass Configuration (Discord IDs that won't be logged)
Config.BypassDiscordIDs = {
    "123456789012345678", -- Add Discord IDs here
    "123456789012345678"
} 
