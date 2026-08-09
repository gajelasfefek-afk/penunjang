local Players = game:GetService("Players")

print("=== Player di Server ===")

for _, player in ipairs(Players:GetPlayers()) do
    print("Username :", player.Name)
    print("Display  :", player.DisplayName)
    print("UserId   :", player.UserId)
    print("-----------------------")
end
