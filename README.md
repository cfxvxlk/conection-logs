#  FiveM Connection Logger

A FiveM script that logs player connections to a Discord webhook with detailed identifier information.

## Features

- Logs player connections to Discord webhook
- Extracts all player identifiers (Discord, Steam, Xbox, FiveM, License)
- Captures IPv4 and IPv6 addresses
- Beautiful embed with colored design
- Copy-paste friendly format with code blocks
- Security features to prevent server dumping
- Timestamp on each connection log

## Installation

1. Place the entire folder in your FiveM server's `resources` directory
2. Rename the folder to `connection-logger` (or any name you prefer)
3. Edit `config.lua` and add your Discord webhook URL
4. Add `start connection-logger` to your `server.cfg` file
5. Restart your server or refresh the resource

## Configuration

### Webhook Setup
1. Create a Discord webhook in your server:
   - Go to Server Settings > Integrations > Webhooks
   - Create a new webhook
   - Copy the webhook URL
2. Paste the webhook URL in `config.lua` at line: `Config.WebhookURL = "YOUR_DISCORD_WEBHOOK_URL_HERE"`

### Customization
- **Embed Color**: Change `Config.EmbedColor` to any decimal color value
  - Blue: `3447003` (default)
  - Red: `16711680`
  - Green: `3066993`
- **Title**: Modify `Config.EmbedTitle` to change the embed title

## Embed Format

The Discord embed will display:
```
ServerName-Connection Log: DiscordIDOfTheUser

Player Name: PlayerName
Discord ID: 123456789012345678
IPv4: 192.168.1.1
IPv6: ::1
CFX ID: abc123
Xbox ID: Unknown
Steam ID: 76561198012345678
License: abc123def456
```

## Security Features

- Configuration is protected from client access
- No sensitive information is exposed to players
- Prevents server dumping attempts
- Server-side only execution

## Troubleshooting

### Webhook not sending
1. Verify your webhook URL is correct in `config.lua`
2. Check if the Discord channel still exists
3. Ensure the webhook has permission to post messages

### Missing identifiers
1. Some identifiers may be "Unknown" if the player doesn't have that platform linked
2. IPv6 may not be available for all players
3. Xbox ID requires the player to be signed into Xbox Live

### Script not loading
1. Ensure `fxmanifest.lua` is properly formatted
2. Check server console for any errors
3. Verify the resource is started in `server.cfg`

## Support

For support or issues, please contact the Luna team.

**Version**: 1.0.0
**Author**: Luna
