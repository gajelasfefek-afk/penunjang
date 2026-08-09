-- DEBUG VERSION - Player Detector
print("🚀 SCRIPT STARTED")

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- WEBHOOK URL (GANTI PUNYA KAMU)
local WEBHOOK = "https://discord.com/api/webhooks/1440706799002189998/zVyfFMoV0BRgn3YFC97OXmb8WcbnHJBPX0j-zOsOi7w8j4lddLR4dCuRPgaPcniyKTyd"

print("📡 HttpService:", HttpService)
print("👥 Players:", Players)
print("🔗 Webhook:", WEBHOOK)

-- TEST 1: Cek koneksi ke Discord
local function testConnection()
    print("🔄 Testing connection...")
    local testData = {
        content = "🟢 Connection Test from Roblox",
        username = "Debugger"
    }
    
    local success, err = pcall(function()
        local response = HttpService:PostAsync(
            WEBHOOK,
            HttpService:JSONEncode(testData),
            Enum.HttpContentType.ApplicationJson
        )
        print("📨 Response:", response)
        return response
    end)
    
    if success then
        print("✅ TEST PASSED: Connection OK")
        return true
    else
        warn("❌ TEST FAILED: " .. tostring(err))
        return false
    end
end

-- TEST 2: Ambil player list
local function getPlayers()
    print("🔍 Getting players...")
    local list = {}
    local count = 0
    
    for _, v in ipairs(Players:GetPlayers()) do
        count = count + 1
        table.insert(list, {
            Name = v.Name,
            UserId = v.UserId,
            DisplayName = v.DisplayName or v.Name
        })
        print(string.format("  %d. %s (%s)", count, v.Name, v.UserId))
    end
    
    print(string.format("✅ Found %d players", count))
    return list
end

-- TEST 3: Kirim player list ke Discord
local function sendPlayerList(players)
    print("📤 Sending to Discord...")
    
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
    
    print("📨 Message:", msg)
    
    local data = {
        content = msg,
        username = "Player Detector"
    }
    
    local success, err = pcall(function()
        local response = HttpService:PostAsync(
            WEBHOOK,
            HttpService:JSONEncode(data),
            Enum.HttpContentType.ApplicationJson
        )
        print("📨 Response from Discord:", response)
        return response
    end)
    
    if success then
        print("✅ SUCCESS: Webhook sent!")
    else
        warn("❌ FAILED: " .. tostring(err))
        print("🔍 Error type:", type(err))
        print("🔍 Error details:", err)
    end
    
    return success
end

-- MAIN EXECUTION
print("⚡ EXECUTING MAIN...")

-- Tunggu sebentar
task.wait(3)

-- Test connection dulu
local connectionOk = testConnection()
task.wait(1)

-- Ambil players
local players = getPlayers()
task.wait(1)

-- Kirim ke Discord
local sendOk = sendPlayerList(players)

-- Hasil akhir
print("═══════════════════════════")
print("📊 DEBUG RESULT:")
print("  Connection Test:", connectionOk and "✅ PASS" or "❌ FAIL")
print("  Players Found:", #players)
print("  Webhook Send:", sendOk and "✅ SUCCESS" or "❌ FAIL")
print("═══════════════════════════")

if not connectionOk then
    print("💡 TIPS: Cek webhook URL, pastikan Discord server terima webhook")
end

if not sendOk then
    print("💡 TIPS: Cek internet, mungkin kena rate limit Discord")
end

print("🔧 Script selesai. Cek console untuk error detail.")
