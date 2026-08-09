-- Reworked PlayerListWebhook.lua (Compatible with Delta Executor)

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Ganti dengan webhook URL Discord kamu
local WEBHOOK_URL = "https://discord.com/api/webhooks/1477626808160489593/NkdAmbmx55b3Hu--jees1G238Chvi5f5PwD3PC4Iqd_kLjfTBd0hJZKAB-QUrO-os9jg"

-- Fungsi untuk send webhook
local function sendWebhook(playerList, isStartup)
    local description = ""
    local title = isStartup and "🚀 Server Started - Player List" or "👥 Current Player List Update"
    
    if #playerList == 0 then
        description = "❌ No players currently in server"
    else
        for _, entry in ipairs(playerList) do
            description = description .. string.format("**%s** — `<@%s>`\n", entry.Username, entry.UserId)
        end
        description = description .. string.format("\n**Total Players:** %d", #playerList)
    end

    local payload = {
        embeds = {
            {
                title = title,
                description = description,
                color = isStartup and 3066993 or 3447003, -- hijau untuk startup, biru untuk update
                footer = {
                    text = string.format("PlaceId: %s | JobId: %s", tostring(game.PlaceId), tostring(game.JobId))
                },
                timestamp = DateTime.now():ToIsoDate()
            }
        }
    }

    -- Tambahkan retry mechanism
    local success = false
    local attempts = 0
    while not success and attempts < 3 do
        attempts = attempts + 1
        local s, err = pcall(function()
            HttpService:PostAsync(
                WEBHOOK_URL,
                HttpService:JSONEncode(payload),
                Enum.HttpContentType.ApplicationJson,
                false -- disable cache
            )
        end)
        
        if s then
            success = true
            print("✅ Webhook sent successfully!")
        else
            warn(string.format("⚠️ Attempt %d failed: %s", attempts, tostring(err)))
            task.wait(1)
        end
    end
end

-- Fungsi untuk get current player list
local function getPlayerList()
    local list = {}
    for _, player in ipairs(Players:GetPlayers()) do
        table.insert(list, {
            Username = player.Name,
            UserId = player.UserId,
            DisplayName = player.DisplayName or player.Name
        })
    end
    return list
end

-- Main execution
task.spawn(function()
    print("🔍 Script started...")
    
    -- Tunggu beberapa detik agar executor dan game stabil
    task.wait(3)
    
    -- Cek koneksi internet
    print("🌐 Checking connection...")
    
    -- Dapatkan player list awal
    local playerList = getPlayerList()
    print(string.format("📊 Found %d players", #playerList))
    
    -- Kirim webhook pertama (startup)
    sendWebhook(playerList, true)
    
    -- Setup auto-update (opsional)
    local autoUpdate = true -- Set ke false jika tidak mau auto-update
    if autoUpdate then
        print("🔄 Auto-update enabled - checking every 60 seconds")
        
        -- Track player join/leave dengan callback
        local function onPlayerAdded(player)
            print(string.format("👤 Player joined: %s (%s)", player.Name, player.UserId))
            task.wait(2) -- Tunggu sebentar biar player fully loaded
            local updatedList = getPlayerList()
            sendWebhook(updatedList, false)
        end
        
        local function onPlayerRemoving(player)
            print(string.format("👋 Player left: %s (%s)", player.Name, player.UserId))
            task.wait(1)
            local updatedList = getPlayerList()
            sendWebhook(updatedList, false)
        end
        
        -- Connect events
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
