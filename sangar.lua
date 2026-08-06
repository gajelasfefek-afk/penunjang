local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Ganti dengan webhook URL Discord kamu
local WEBHOOK_URL = "https://discord.com/api/webhooks/1440706799002189998/zVyfFMoV0BRgn3YFC97OXmb8WcbnHJBPX0j-zOsOi7w8j4lddLR4dCuRPgaPcniyKTyd"

-- Delay biar player sempat masuk dulu sebelum di-list (server baru start biasanya masih kosong sesaat)
local STARTUP_DELAY = 5 -- detik

local function sendWebhook(playerList)
	local description = ""

	if #playerList == 0 then
		description = "Belum ada player saat startup."
	else
		for _, entry in ipairs(playerList) do
			description = description .. string.format("**%s** — `%s`\n", entry.Username, entry.UserId)
		end
	end

	local payload = {
		embeds = {
			{
				title = "Server Started — Player List",
				description = description,
				color = 3066993, -- hijau
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

task.spawn(function()
	task.wait(STARTUP_DELAY)

	local playerList = {}
	for _, player in ipairs(Players:GetPlayers()) do
		table.insert(playerList, {
			Username = player.Name,
			UserId = player.UserId
		})
	end

	sendWebhook(playerList)
end)
