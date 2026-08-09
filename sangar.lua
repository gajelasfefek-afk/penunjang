-- TEST SCRIPT
local HttpService = game:GetService("HttpService")
local webhook = "https://discord.com/api/webhooks/1440706799002189998/zVyfFMoV0BRgn3YFC97OXmb8WcbnHJBPX0j-zOsOi7w8j4lddLR4dCuRPgaPcniyKTyd"

local data = {
    content = "Hello from Roblox!",
    username = "TestBot"
}

local success, err = pcall(function()
    local response = HttpService:PostAsync(webhook, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
    print("Response:", response)
end)

if success then
    print("✅ BERHASIL!")
else
    print("❌ GAGAL:", err)
end
