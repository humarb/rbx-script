wait(3)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:WaitForChild("Animator")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local CommonEffects_upvr = require(ReplicatedStorage.Modules.Utility.CommonEffects)

print("[DEBUG] Character loaded:", character)

local tool = character:FindFirstChild("Plastic Pan")
if not tool then
    print("Pan tidak ditemukan.")
    return
end

print("Tool", tool)

local scriptsFolder = tool:FindFirstChild("Scripts")
if not scriptsFolder then
    print("Folder Scripts tidak ditemukan dalam tool.")
    return
end

-- Dig
local collectRemote = scriptsFolder:FindFirstChild("Collect")
local toggleRemote = scriptsFolder:WaitForChild("ToggleShovelActive")

-- Pan
local panRemote = scriptsFolder:WaitForChild("Pan")
local shakeRemote = scriptsFolder:WaitForChild("Shake")

-- Animations
local panningAnims = ReplicatedStorage.Assets.Animations.Panning
local animWindUp = animator:LoadAnimation(panningAnims.DigWindUp)
local animDig = animator:LoadAnimation(panningAnims.Dig)
local animHit = animator:LoadAnimation(panningAnims.DigHit)
local animWash = animator:LoadAnimation(panningAnims.Wash)
local animShake = animator:LoadAnimation(panningAnims.Shake)

-- UI
local fillingUI = player:WaitForChild("PlayerGui"):WaitForChild("ToolUI").DigBar
local fillLine = fillingUI:WaitForChild("Line")

-- Attribute references
local stats = player:WaitForChild("Stats")
local capacity = stats:GetAttribute("Capacity")
local digSpeed = stats:GetAttribute("DigSpeed")

-- Sounds
local handle = tool:WaitForChild("Handle")
local digSound = handle:WaitForChild("Dig")
local perfectSound = scriptsFolder:WaitForChild("Sounds"):WaitForChild("PerfectDig")

-- Flags
local isDigging = false

local running = false

local needDig = true

-- Notif Remote
local notifRemote = ReplicatedStorage.Remotes.Info.NotificationClient

local function moveRelative(stud)
  print("Move", stud, "studs")
	
	-- Simpan arah hadap awal
	local lookRotation = humanoidRootPart.CFrame - humanoidRootPart.Position

	-- Hitung posisi target
	local targetPos = humanoidRootPart.Position + humanoidRootPart.CFrame.LookVector * stud

	-- Gerakkan
	humanoid:MoveTo(targetPos)

	local reached = false
	humanoid.MoveToFinished:Connect(function()
		reached = true
	end)

	local timeout = 5
	local start = tick()
	while not reached and tick() - start < timeout do
		task.wait(0.1)
	end

	-- Kembalikan arah hadap awal
	humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position) * lookRotation
end

local function startDigging()
  local panFill = tool:GetAttribute("Fill") or 0

	if isDigging then return end
	if panFill >= capacity then
    needDig = false
		local notifRemote = ReplicatedStorage.Remotes.Info.NotificationClient
		notifRemote:Fire("Your pan is full! Wash it in nearby water!", Color3.fromRGB(255, 66, 66), "Error")
		return
	end

  print(">>> Start Digging")
	isDigging = true
	local digSh = toggleRemote:FireServer(true)

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
  local coll = collectRemote:InvokeServer()
  if coll then
    success = true
  end

  local reachedPerfect = false
	local progress = 0
	local clamped
	while isDigging and success do
		local delta = RunService.Heartbeat:Wait()
		progress = progress + digSpeed * 1.5 * delta
		clamped = math.clamp(progress, 0, 1)
		fillLine.Position = UDim2.new(0.5, 0, 1 - clamped, 0)

		if clamped >= 1 then break end
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
	if clamped >= 1 - math.max(perfectThreshold, perfectThreshold * digSpeed) then
		perfectSound:Play()
    CommonEffects_upvr.TextRise(humanoidRootPart, "PERFECT!", Color3.new(1, 0.847059, 0.235294))
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
  print("<<< Selesai Digging")
  wait(2)
end

local function startPanning()
  local fill = tool:GetAttribute("Fill")
  print(">>> Start Panning")

  -- Mulai Panning
  local result = panRemote:InvokeServer()

  -- Mainkan animasi awal
  animWash:Play()
  task.wait(0.35) -- sesuai PanClient

  -- Mainkan animasi shake
  animShake:Play()
  animShake:AdjustSpeed(1)

  -- Loop shake hingga pan kosong
  while fill > 0 do
    shakeRemote:FireServer()
    task.wait(0.35)
    fill = tool:GetAttribute("Fill") or 0
    print("[DEBUG] Shake, fill sisa:", fill)
  end

  -- Hentikan animasi shake
  animShake:Stop()
  animWash:Stop()
  print("<<< Selesai Panning")

  needDig = true
end

local function runningLoop()
  while running do
    while needDig do
      startDigging()
    end

    wait(3)

    moveRelative(25)

    wait(3)

    startPanning()

    wait(3)

    moveRelative(-25)

    wait(3)
  end
end

-- UI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AutoFarmGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 150, 0, 100)
frame.Position = UDim2.new(0, 10, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.2

local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(1, -10, 0.4, -5)
toggleBtn.Position = UDim2.new(0, 5, 0, 5)
toggleBtn.Text = "Start"
toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)

local endBtn = Instance.new("TextButton", frame)
endBtn.Size = UDim2.new(1, -10, 0.4, -5)
endBtn.Position = UDim2.new(0, 5, 0.55, 0)
endBtn.Text = "End Script"
endBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 100)

-- Button Events
toggleBtn.MouseButton1Click:Connect(function()
	running = not running
	if running then
		toggleBtn.Text = "Running..."
		task.spawn(runningLoop)
	else
		toggleBtn.Text = "Start"
	end
end)

endBtn.MouseButton1Click:Connect(function()
	running = false
	gui:Destroy()
end)