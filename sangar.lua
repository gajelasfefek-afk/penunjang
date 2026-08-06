local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local WEBHOOK_URL = "https://discord.com/api/webhooks/1477626808160489593/NkdAmbmx55b3Hu--jees1G238Chvi5f5PwD3PC4Iqd_kLjfTBd0hJZKAB-QUrO-os9jg" -- regenerate dulu yang lama

local function sendJoinAlert(player)
	local payload = {
		embeds = {
			{
				title = "⚠️ Player Joined",
				description = string.format("**%s** — `%s`", player.Name, player.UserId),
				color = 15158332, -- merah
				footer = {
					text = "PlaceId: " .. tostring(game.PlaceId) .. " | JobId: " .. tostring(game.JobId)
				},
				timestamp = DateTime.now():ToIsoDate()
			}
		}
	}

	local success, err = pcall(function()
		HttpService:PostAsync(
			WEBHOOK_URL,
			HttpService:JSONEncode(payload),
			Enum.HttpContentType.ApplicationJson
		)
	end)

	if not success then
		warn("Gagal kirim webhook: " .. tostring(err))
	end
end

Players.PlayerAdded:Connect(sendJoinAlert)
