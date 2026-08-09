-- deep.lua
-- Simple Player Detector + Discord Webhook

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- GANTI INI DENGAN WEBHOOK URL KAMU
local WEBHOOK = "https://discord.com/api/webhooks/1440706799002189998/zVyfFMoV0BRgn3YFC97OXmb8WcbnHJBPX0j-zOsOi7w8j4lddLR4dCuRPgaPcniyKTyd"

-- Fungsi kirim ke Discord
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

-- Ambil semua player
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

-- MAIN EXECUTE
print("🔍 Sedang cek player...")
task.wait(2)

local allPlayers = getPlayers()
sendToDiscord(allPlayers)

-- Auto detect player join/leave (opsional)
Players.PlayerAdded:Connect(function(p)
    print("👤 " .. p.Name .. " join")
    task.wait(1)
    local updated = getPlayers()
    sendToDiscord(updated)
end)

Players.PlayerRemoving:Connect(function(p)
    print("👋 " .. p.Name .. " leave")
    task.wait(1)
    local updated = getPlayers()
    sendToDiscord(updated)
end)

print("✅ Script jalan! Auto-detect aktif.")        -- Connect events
        Players.PlayerAdded:Connect(onPlayerAdded)
        Players.PlayerRemoving:Connect(onPlayerRemoving)
        
        -- Periodic update (every 60 seconds)
        task.spawn(function()
            while true do
                task.wait(60) -- Menit update
                local updatedList = getPlayerList()
                sendWebhook(updatedList, false)
                print("🔄 Periodic update sent")
            end
        end)
    else
        print("✅ Initial check complete. Script finished.")
    end
end)

print("📋 Script loaded successfully!")
