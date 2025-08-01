--[[ AutoDig Script for Prospecting with Toggle GUI ]]--

local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local pan = character:WaitForChild("Plastic Pan")
local scripts = pan:WaitForChild("Scripts")

local toggleShovel = scripts:WaitForChild("ToggleShovelActive")
local collect = scripts:WaitForChild("Collect")

local runService = game:GetService("RunService")

local INTERVAL = 10
local autoDigEnabled = false

-- GUI setup
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "AutoDigGUI"

local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Size = UDim2.new(0, 120, 0, 40)
toggleButton.Position = UDim2.new(0, 20, 0, 100)
toggleButton.BackgroundColor3 = Color3.fromRGB(30, 150, 30)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 18
toggleButton.Text = "AutoDig: OFF"
toggleButton.Active = true
toggleButton.Draggable = true

-- Toggle function
toggleButton.MouseButton1Click:Connect(function()
    autoDigEnabled = not autoDigEnabled
    toggleButton.Text = autoDigEnabled and "AutoDig: ON" or "AutoDig: OFF"
    toggleButton.BackgroundColor3 = autoDigEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(150, 0, 0)
end)

-- Main loop (runs in parallel)
task.spawn(function()
    while true do
        if autoDigEnabled then
            print("[AutoDig] Start")

            pcall(function()
                toggleShovel:FireServer(true)
            end)
            wait(0.5)

            pcall(function()
                collect:InvokeServer()
            end)
            wait(0.5)

            pcall(function()
                collect:InvokeServer(1)
            end)
            wait(0.5)

            pcall(function()
                toggleShovel:FireServer(false)
            end)

            print("[AutoDig] Done - wait "..INTERVAL.."s")
        end
        wait(INTERVAL)
    end
end)
