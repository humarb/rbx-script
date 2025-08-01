local sh = game:GetService("Players").LocalPlayer.Character:WaitForChild("Plastic Pan"):WaitForChild("Scripts"):WaitForChild("ToggleShovelActive"):FireServer(true)
print("Shovel:", sh)

local co = game:GetService("Players").LocalPlayer.Character:WaitForChild("Plastic Pan"):WaitForChild("Scripts"):WaitForChild("Collect"):InvokeServer()
print("Collect:", co)

local sh2 = game:GetService("Players").LocalPlayer.Character:WaitForChild("Plastic Pan"):WaitForChild("Scripts"):WaitForChild("ToggleShovelActive"):FireServer(false)
print("Shovel:", sh2)