local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:WaitForChild("Animator")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

print("[DEBUG] Character loaded:", character)

local tool = character:FindFirstChild("Plastic Pan")

if not tool then
    warn("Plastic Pan tidak ditemukan.")
    return
end

print("Tool", tool)

local handle = tool:WaitForChild("Handle")
local digSound = handle:WaitForChild("Dig")

local scriptsFolder = tool:FindFirstChild("Scripts")
if not scriptsFolder then
    warn("Folder Scripts tidak ditemukan dalam tool.")
    return
end

local collectRemote = scriptsFolder:FindFirstChild("Collect")
local toggleRemote = scriptsFolder:WaitForChild("ToggleShovelActive")

-- Animations
local panningAnims = ReplicatedStorage.Assets.Animations.Panning
local animWindUp = animator:LoadAnimation(panningAnims.DigWindUp)
local animDig = animator:LoadAnimation(panningAnims.Dig)
local animHit = animator:LoadAnimation(panningAnims.DigHit)

-- UI
local fillingUI = player:WaitForChild("PlayerGui"):WaitForChild("ToolUI").DigBar
local fillLine = fillingUI:WaitForChild("Line")

-- Attribute references
local stats = player:WaitForChild("Stats")
local capacity = stats:GetAttribute("Capacity")
local digSpeed = stats:GetAttribute("DigSpeed")
local panFill = tool:GetAttribute("Fill") or 0

-- Sounds
local perfectSound = scriptsFolder:WaitForChild("Sounds"):WaitForChild("PerfectDig")

-- Flags
local isDigging = false

function startDigging()
	if isDigging then return end
	if panFill >= capacity then
		local notifRemote = ReplicatedStorage.Remotes.Info.NotificationClient
		notifRemote:Fire("Your pan is full! Wash it in nearby water!", Color3.fromRGB(255, 66, 66), "Error")
		return
	end

	isDigging = true
	local digSh = toggleRemote:FireServer(true)
  print(digSh)

	-- Lock movement
	humanoid.WalkSpeed = 0
	humanoid.JumpPower = 0
	humanoid.AutoRotate = false

	-- Start animation
	animWindUp:Play(0.2)
	animDig:Play(0.25)
	animDig:AdjustSpeed(digSpeed)

	-- Show UI
	fillingUI.Visible = true
	fillLine.Position = UDim2.new(0.5, 0, 1, 0)

	local success = false
	task.spawn(function()
    print('aaa')
    local coll = game:GetService("Players").LocalPlayer.Character:WaitForChild("Plastic Pan"):WaitForChild("Scripts"):WaitForChild("Collect"):InvokeServer()
    print(coll)
		
	end)

	local progress = 1
	local clamped
  print('bbb')
  print(success)
	while isDigging and success do
		RunService.Heartbeat:Wait()
		print("HB")
		print(RunService.Heartbeat:Wait())
		progress = progress - digSpeed * 1.5 * RunService.Heartbeat:Wait()
		print("Pro")
		print(progress)
		clamped = math.clamp(progress, 0, 1)
		print(clamped)
		fillLine.Position = UDim2.new(0.5, 0, 1 - clamped, 0)

		if clamped <= 0 then break end
	end

	-- Finish animation
	animWindUp:Stop(0.1)
	animDig:Stop(0.1)
	animHit:Play()
	animHit:AdjustSpeed(digSpeed)
	task.wait(0.17 / digSpeed)

	digSound:Play()

	-- PERFECT CHECK (like in PanClient)
	local perfectThreshold = _G.mobile and 0.1 or 0.05
  print(clamped)
  print(1 - math.max(perfectThreshold, perfectThreshold * digSpeed))
	if clamped >= 1 - math.max(perfectThreshold, perfectThreshold * digSpeed) then
		perfectSound:Play()
		-- Tambahkan efek perfect jika diperlukan
	end

	-- Final invoke
	task.spawn(function()
		collectRemote:InvokeServer(1)
	end)

	task.wait(0.95 / digSpeed)

	-- Reset
	humanoid.WalkSpeed = 16
	humanoid.JumpPower = 50
	humanoid.AutoRotate = true
	fillingUI.Visible = false
	toggleRemote:FireServer(false)

	isDigging = false
end

startDigging()

