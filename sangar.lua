-- deep.lua (Fixed Version)
-- Simple Player Detector + Discord Webhook

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- 🔴 GANTI URL INI DENGAN WEBHOOK DISCORD KAMU YANG BARU
local WEBHOOK = "https://discord.com/api/webhooks/1440706799002189998/zVyfFMoV0BRgn3YFC97OXmb8WcbnHJBPX0j-zOsOi7w8j4lddLR4dCuRPgaPcniyKTyd"

-- Fungsi kirim pesan ke Discord
local function sendToDiscord(players)
    local msg = "📋 **PLAYER LIST**\n"
    msg = msg .. "━━━━━━━━━━━━━━━━━\n"

    if #players == 0 then
        msg = msg .. "❌ Kosong bro"
    else
        for i, p in ipairs(players) do
            msg = msg .. string.format("%d. **%s** (`%s`)\n", i, p.Name, p.UserId)
        end
        msg = msg .. "━━━━━━━━━━━━━━━━━\n"
        msg = msg .. string.format("👥 Total: **%d** player", #players)
    end

    local data = {
        content = msg,
        username = "Player Detector"
    }

    local success, err = pcall(function()
        HttpService:PostAsync(WEBHOOK, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
    end)

    if success then
        print("✅ Berhasil kirim ke Discord!")
    else
        warn("❌ Gagal: " .. tostring(err))
    end
end

-- Ambil semua player yang sedang online
local function getPlayers()
    local list = {}
    for _, v in ipairs(Players:GetPlayers()) do
        table.insert(list, {
            Name = v.Name,
            UserId = v.UserId,
            DisplayName = v.DisplayName
        })
    end
    return list
end

-- === MAIN EXECUTION ===
print("🔍 Sedang cek player...")
task.wait(2) -- Tunggu sebentar biar stabil

-- Kirim data pertama kali
local allPlayers = getPlayers()
sendToDiscord(allPlayers)

-- Auto-detect player join
Players.PlayerAdded:Connect(function(p)
    print("👤 " .. p.Name .. " join")
    task.wait(1) -- Tunggu data player siap
    local updated = getPlayers()
    sendToDiscord(updated)
end)

-- Auto-detect player leave
Players.PlayerRemoving:Connect(function(p)
    print("👋 " .. p.Name .. " leave")
    task.wait(1)
    local updated = getPlayers()
    sendToDiscord(updated)
end)

print("✅ Script jalan! Auto-detect aktif.")
