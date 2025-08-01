-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2025-08-01 02:07:08
-- Luau version 6, Types version 3
-- Time taken: 0.012061 seconds

local RunService_upvr = game:GetService("RunService")
local TweenService_upvr = game:GetService("TweenService")
local ContextActionService_upvr = game:GetService("ContextActionService")
local CurrentCamera_upvr = workspace.CurrentCamera
local ToggleShovelActive_upvr = script.Parent:WaitForChild("ToggleShovelActive")
local NotificationClient_upvr = game.ReplicatedStorage.Remotes.Info.NotificationClient
local class_Tool_upvr = script:FindFirstAncestorOfClass("Tool")
local Handle_upvr = class_Tool_upvr:WaitForChild("Handle")
local LocalPlayer_upvr = game.Players.LocalPlayer
local Character_upvr = LocalPlayer_upvr.Character
local Humanoid_upvr = Character_upvr:WaitForChild("Humanoid")
local HumanoidRootPart_upvr = Character_upvr:WaitForChild("HumanoidRootPart")
local Animator = Humanoid_upvr:WaitForChild("Animator")
local module_upvr = require(LocalPlayer_upvr.PlayerGui:WaitForChild("ToolUI"):WaitForChild("Controls"):WaitForChild("ControlsDisplay"))
local CommonEffects_upvr = require(game.ReplicatedStorage.Modules.Utility.CommonEffects)
local Shake_4_upvr = require(game.ReplicatedStorage.Modules.Utility.Shake)
local Rarities_upvr = require(game.ReplicatedStorage.GameInfo.Rarities)
local ToolUI_upvr = LocalPlayer_upvr.PlayerGui:WaitForChild("ToolUI")
local Vignette_upvr = LocalPlayer_upvr.PlayerGui:WaitForChild("ScreenEffects"):WaitForChild("Vignette")
local Panning = game.ReplicatedStorage.Assets.Animations.Panning
local any_LoadAnimation_result1_upvr_3 = Animator:LoadAnimation(Panning.Dig)
local any_LoadAnimation_result1_upvr_2 = Animator:LoadAnimation(Panning.DigWindUp)
local Attachment = Instance.new("Attachment", HumanoidRootPart_upvr)
local Particles = script.Parent:WaitForChild("Particles")
local Perfect1_upvr = Particles:WaitForChild("Perfect1")
local Perfect2_upvr = Particles:WaitForChild("Perfect2")
Perfect1_upvr.Parent = Attachment
Perfect2_upvr.Parent = Attachment
local Stats_upvr = LocalPlayer_upvr:WaitForChild("Stats")
local var28_upvw
local var29_upvw
local var30_upvw = false
local var31_upvw = false
if _G.mobile then
	ToolUI_upvr:WaitForChild("DigBar").Size = UDim2.new(0.02, 0, 0.28, 0)
	ToolUI_upvr.DigBar.Position = UDim2.new(0.6, 0, 0.5, -30)
else
	ToolUI_upvr:WaitForChild("DigBar").Size = UDim2.new(0.015, 0, 0.2, 0)
	ToolUI_upvr.DigBar.Position = UDim2.new(0.6, 0, 0.5, 0)
end
local PointToRegion_upvr = require(game.ReplicatedStorage.Modules.Location.PointToRegion)
function updatePosition() -- Line 74
	--[[ Upvalues[4]:
		[1]: PointToRegion_upvr (readonly)
		[2]: HumanoidRootPart_upvr (readonly)
		[3]: var29_upvw (read and write)
		[4]: module_upvr (readonly)
	]]
	local any_GetPanningRegion_result1, _ = PointToRegion_upvr.GetPanningRegion(HumanoidRootPart_upvr.Position)
	if any_GetPanningRegion_result1 ~= var29_upvw then
		if any_GetPanningRegion_result1 == "Deposit" then
			module_upvr.SetControls({
				["Collect Deposit"] = Enum.UserInputType.MouseButton1;
			})
		elseif any_GetPanningRegion_result1 == "Water" then
			module_upvr.SetControls({
				Pan = Enum.UserInputType.MouseButton1;
			})
		else
			module_upvr.SetControls({})
		end
	end
	var29_upvw = any_GetPanningRegion_result1
end
local FormatNumber_upvr = require(game.ReplicatedStorage.Modules.Utility.FormatNumber)
local function updateFillUI() -- Line 91
	--[[ Upvalues[5]:
		[1]: class_Tool_upvr (readonly)
		[2]: Stats_upvr (readonly)
		[3]: ToolUI_upvr (readonly)
		[4]: FormatNumber_upvr (readonly)
		[5]: TweenService_upvr (readonly)
	]]
	local var38 = class_Tool_upvr:GetAttribute("Fill") or 0
	local Capacity = Stats_upvr:GetAttribute("Capacity")
	ToolUI_upvr.FillingPan.FillText.Text = FormatNumber_upvr.Format(var38)..'/'..Capacity
	TweenService_upvr:Create(ToolUI_upvr.FillingPan.Bar, TweenInfo.new(0.2), {
		Size = UDim2.new(math.clamp(var38 / Capacity, 0, 1), 0, 1, 0);
	}):Play()
	local Quality = class_Tool_upvr:GetAttribute("Quality")
	ToolUI_upvr.FillingPan.Quality.Text = "Quality: "..math.round(Quality * 100)..'%'
	ToolUI_upvr.FillingPan.Quality.TextColor3 = Color3.fromHSV(0.311111, Quality, 1)
end
class_Tool_upvr:GetAttributeChangedSignal("Fill"):Connect(updateFillUI)
updateFillUI()
local function _(arg1) -- Line 107, Named "freezePlayer"
	--[[ Upvalues[1]:
		[1]: Humanoid_upvr (readonly)
	]]
	if arg1 then
		Humanoid_upvr.WalkSpeed = 0
		Humanoid_upvr.JumpPower = 0
	else
		Humanoid_upvr.WalkSpeed = 16
		Humanoid_upvr.JumpPower = 50
	end
	Humanoid_upvr.AutoRotate = not arg1
end
local var42_upvw
local var43_upvw = false
local CFrame_upvw = CurrentCamera_upvr.CFrame
local function toggleCamera_upvr(arg1) -- Line 123, Named "toggleCamera"
	--[[ Upvalues[8]:
		[1]: Character_upvr (readonly)
		[2]: class_Tool_upvr (readonly)
		[3]: TweenService_upvr (readonly)
		[4]: CFrame_upvw (read and write)
		[5]: CurrentCamera_upvr (readonly)
		[6]: var42_upvw (read and write)
		[7]: HumanoidRootPart_upvr (readonly)
		[8]: var43_upvw (read and write)
	]]
	for i, v in Character_upvr:GetDescendants() do
		if not v:IsDescendantOf(class_Tool_upvr) and (v:IsA("BasePart") or v:IsA("Decal")) then
			if arg1 and v.Name ~= "Right Arm" and v.Name ~= "Left Arm" then
				TweenService_upvr:Create(v, TweenInfo.new(0.5), {
					LocalTransparencyModifier = 1;
				}):Play()
			else
				TweenService_upvr:Create(v, TweenInfo.new(0.5), {
					LocalTransparencyModifier = 0;
				}):Play()
			end
		end
	end
	if arg1 then
		CFrame_upvw = CurrentCamera_upvr.CFrame
		i = HumanoidRootPart_upvr
		i = CFrame.new
		v = 0
		i = i(v, 0.5, -2.4)
		i = (-math.pi/2)
		v = 0
		var42_upvw = i.CFrame * i * CFrame.Angles(i, v, 0)
		CurrentCamera_upvr.CameraType = Enum.CameraType.Scriptable
		i = TweenInfo.new
		v = 0.5
		i = i(v)
		v = {}
		v.CFrame = var42_upvw
		TweenService_upvr:Create(CurrentCamera_upvr, i, v):Play()
		task.delay(0.5, function() -- Line 140
			--[[ Upvalues[1]:
				[1]: var43_upvw (copied, read and write)
			]]
			var43_upvw = true
		end)
	else
		var43_upvw = false
		TweenService_upvr:Create(CurrentCamera_upvr, TweenInfo.new(1), {
			CFrame = CFrame_upvw;
		}):Play()
		task.wait(1)
		CurrentCamera_upvr.CameraType = Enum.CameraType.Custom
	end
end
local function stopDigging_upvr() -- Line 153, Named "stopDigging"
	--[[ Upvalues[7]:
		[1]: any_LoadAnimation_result1_upvr_3 (readonly)
		[2]: any_LoadAnimation_result1_upvr_2 (readonly)
		[3]: var30_upvw (read and write)
		[4]: var31_upvw (read and write)
		[5]: ToolUI_upvr (readonly)
		[6]: Humanoid_upvr (readonly)
		[7]: ToggleShovelActive_upvr (readonly)
	]]
	any_LoadAnimation_result1_upvr_3:Stop(0.25)
	any_LoadAnimation_result1_upvr_2:Stop(0.25)
	var30_upvw = false
	var31_upvw = false
	ToolUI_upvr.DigBar.Visible = false
	Humanoid_upvr.WalkSpeed = 16
	Humanoid_upvr.JumpPower = 50
	Humanoid_upvr.AutoRotate = true
	task.delay(0.25, function() -- Line 162
		--[[ Upvalues[2]:
			[1]: var31_upvw (copied, read and write)
			[2]: ToggleShovelActive_upvr (copied, readonly)
		]]
		if not var31_upvw then
			ToggleShovelActive_upvr:FireServer(false)
		end
	end)
end
local Collect_upvr = script.Parent:WaitForChild("Collect")
local any_LoadAnimation_result1_upvr_5 = Animator:LoadAnimation(Panning.DigHit)
local Dig_upvr = Handle_upvr:WaitForChild("Dig")
local PerfectDig_upvr = script.Parent:WaitForChild("Sounds"):WaitForChild("PerfectDig")
local function startDigging_upvr() -- Line 214, Named "startDigging"
	--[[ Upvalues[21]:
		[1]: class_Tool_upvr (readonly)
		[2]: Stats_upvr (readonly)
		[3]: NotificationClient_upvr (readonly)
		[4]: var30_upvw (read and write)
		[5]: var31_upvw (read and write)
		[6]: Humanoid_upvr (readonly)
		[7]: ToggleShovelActive_upvr (readonly)
		[8]: any_LoadAnimation_result1_upvr_2 (readonly)
		[9]: any_LoadAnimation_result1_upvr_3 (readonly)
		[10]: ToolUI_upvr (readonly)
		[11]: Collect_upvr (readonly)
		[12]: RunService_upvr (readonly)
		[13]: stopDigging_upvr (readonly)
		[14]: any_LoadAnimation_result1_upvr_5 (readonly)
		[15]: Dig_upvr (readonly)
		[16]: PerfectDig_upvr (readonly)
		[17]: CommonEffects_upvr (readonly)
		[18]: Character_upvr (readonly)
		[19]: Perfect1_upvr (readonly)
		[20]: Perfect2_upvr (readonly)
		[21]: Shake_4_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var59
	if Stats_upvr:GetAttribute("Capacity") <= class_Tool_upvr:GetAttribute("Fill") then
		var59 = 66
		NotificationClient_upvr:Fire("Your pan is full! Wash it in nearby water!", Color3.fromRGB(255, 66, var59), "Error")
	else
		var30_upvw = true
		var31_upvw = true
		Humanoid_upvr.WalkSpeed = 0
		Humanoid_upvr.JumpPower = 0
		Humanoid_upvr.AutoRotate = false
		ToggleShovelActive_upvr:FireServer(true)
		local DigSpeed = Stats_upvr:GetAttribute("DigSpeed")
		any_LoadAnimation_result1_upvr_2:Play(0.25)
		any_LoadAnimation_result1_upvr_3:AdjustSpeed(DigSpeed)
		local DigBar = ToolUI_upvr.DigBar
		local Line = DigBar.Line
		DigBar.Visible = true
		var59 = 1
		Line.Position = UDim2.new(0.5, 0, var59, 0)
		local var64_upvw = true
		var59 = task.spawn
		var59(function() -- Line 241
			--[[ Upvalues[2]:
				[1]: var64_upvw (read and write)
				[2]: Collect_upvr (copied, readonly)
			]]
			var64_upvw = Collect_upvr:InvokeServer()
		end)
		while true do
			var59 = var30_upvw
			if not var59 then break end
			var59 = RunService_upvr.Heartbeat:Wait()
			local var66 = 0 + var59 * DigSpeed * 1.5 * -1
			if 1 <= var66 or var66 <= 0 then
				local clamped = math.clamp(var66, 0, 1)
			end
			Line.Position = UDim2.new(0.5, 0, 1 - clamped, 0)
			if not var64_upvw then
				stopDigging_upvr()
				return
			end
		end
		var59 = false
		DigBar.Visible = var59
		var59 = any_LoadAnimation_result1_upvr_2:Stop
		var59()
		var59 = any_LoadAnimation_result1_upvr_5:Play
		var59()
		var59 = any_LoadAnimation_result1_upvr_5:AdjustSpeed
		var59(DigSpeed)
		var59 = task.wait
		var59(0.17 / DigSpeed)
		var59 = Dig_upvr:Play
		var59()
		var59 = 0.05
		if _G.mobile then
			var59 = 0.1
		end
		if 1 - math.max(var59, var59 * DigSpeed) < clamped then
			local const_number_upvw = 1
			PerfectDig_upvr:Play()
			CommonEffects_upvr.TextRise(Character_upvr.HumanoidRootPart, "PERFECT!", Color3.new(1, 0.847059, 0.235294))
			Perfect1_upvr:Emit(2)
			Perfect2_upvr:Emit(4)
		elseif 0.6 < const_number_upvw then
			CommonEffects_upvr.TextRise(Character_upvr.HumanoidRootPart, "Good!", Color3.new(0.835294, 0.835294, 0.835294))
		end
		Shake_4_upvr.Shake(const_number_upvw / 2, 5, 0.1, 0.3)
		task.spawn(function() -- Line 285
			--[[ Upvalues[2]:
				[1]: Collect_upvr (copied, readonly)
				[2]: const_number_upvw (read and write)
			]]
			Collect_upvr:InvokeServer(const_number_upvw)
		end)
		task.wait(0.95 / DigSpeed)
		stopDigging_upvr()
	end
end
local Pan_upvr = script.Parent:WaitForChild("Pan")
local ColorCorrection_upvr = game:GetService("Lighting"):WaitForChild("ColorCorrection")
local any_LoadAnimation_result1_upvr_4 = Animator:LoadAnimation(Panning.Wash)
local function startPanning_upvr() -- Line 295, Named "startPanning"
	--[[ Upvalues[9]:
		[1]: Pan_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: TweenService_upvr (readonly)
		[4]: ColorCorrection_upvr (readonly)
		[5]: HumanoidRootPart_upvr (readonly)
		[6]: toggleCamera_upvr (readonly)
		[7]: Humanoid_upvr (readonly)
		[8]: any_LoadAnimation_result1_upvr_4 (readonly)
		[9]: Character_upvr (readonly)
	]]
	if not Pan_upvr:InvokeServer() then
	else
		module_upvr.SetControls({
			Shake = Enum.UserInputType.MouseButton1;
		})
		if workspace:GetAttribute("Night") then
			TweenService_upvr:Create(ColorCorrection_upvr, TweenInfo.new(0.5), {
				Brightness = 0.1;
			}):Play()
		end
		HumanoidRootPart_upvr.Anchored = true
		toggleCamera_upvr(true)
		Humanoid_upvr.WalkSpeed = 0
		Humanoid_upvr.JumpPower = 0
		Humanoid_upvr.AutoRotate = false
		any_LoadAnimation_result1_upvr_4:Play()
		repeat
			task.wait()
			HumanoidRootPart_upvr.CFrame = HumanoidRootPart_upvr.CFrame
		until not Character_upvr:GetAttribute("Panning")
		task.wait(1)
		if ColorCorrection_upvr.Brightness ~= 0 then
			TweenService_upvr:Create(ColorCorrection_upvr, TweenInfo.new(0.5), {
				Brightness = 0;
			}):Play()
		end
		HumanoidRootPart_upvr.Anchored = false
		toggleCamera_upvr(false)
		Humanoid_upvr.WalkSpeed = 16
		Humanoid_upvr.JumpPower = 50
		Humanoid_upvr.AutoRotate = true
		any_LoadAnimation_result1_upvr_4:Stop()
	end
end
local var76_upvw = false
local any_LoadAnimation_result1_upvr = Animator:LoadAnimation(Panning.Shake)
local Shake_5_upvr = script.Parent:WaitForChild("Shake")
local Shake_3_upvr = Handle_upvr:WaitForChild("Shake")
local Shake2_upvr = Handle_upvr:WaitForChild("Shake2")
local function shake_upvr() -- Line 350, Named "shake"
	--[[ Upvalues[7]:
		[1]: var76_upvw (read and write)
		[2]: Stats_upvr (readonly)
		[3]: any_LoadAnimation_result1_upvr (readonly)
		[4]: Shake_4_upvr (readonly)
		[5]: Shake_5_upvr (readonly)
		[6]: Shake_3_upvr (readonly)
		[7]: Shake2_upvr (readonly)
	]]
	if var76_upvw then
	else
		local ShakeSpeed = Stats_upvr:GetAttribute("ShakeSpeed")
		var76_upvw = true
		any_LoadAnimation_result1_upvr:Play(ShakeSpeed)
		Shake_4_upvr.Shake(0.6, 3, 0.1, 0.3)
		Shake_5_upvr:FireServer()
		Shake_3_upvr.PlaybackSpeed = 0.9 + math.random() * 0.2
		Shake_3_upvr:Play()
		Shake2_upvr.PlaybackSpeed = 0.9 + math.random() * 0.2
		Shake2_upvr:Play()
		task.delay(0.33 / ShakeSpeed, function() -- Line 368
			--[[ Upvalues[1]:
				[1]: var76_upvw (copied, read and write)
			]]
			var76_upvw = false
		end)
	end
end
local function toolToggled_upvr(arg1, arg2, arg3) -- Line 404, Named "toolToggled"
	--[[ Upvalues[10]:
		[1]: var30_upvw (read and write)
		[2]: var31_upvw (read and write)
		[3]: Character_upvr (readonly)
		[4]: shake_upvr (readonly)
		[5]: LocalPlayer_upvr (readonly)
		[6]: var29_upvw (read and write)
		[7]: startDigging_upvr (readonly)
		[8]: CurrentCamera_upvr (readonly)
		[9]: startPanning_upvr (readonly)
		[10]: NotificationClient_upvr (readonly)
	]]
	if not arg3 then
	else
		if arg2 == Enum.UserInputState.Begin then
			if var30_upvw then
			else
				if var31_upvw then return end
				if Character_upvr:GetAttribute("Panning") then
					var30_upvw = true
					while var30_upvw and Character_upvr:GetAttribute("Panning") do
						shake_upvr()
						task.wait()
					end
					return
				end
				LocalPlayer_upvr:SetAttribute("BackpackLocked", true)
				if var29_upvw == "Deposit" then
					startDigging_upvr()
				elseif var29_upvw == "Water" and CurrentCamera_upvr.CameraType ~= Enum.CameraType.Scriptable then
					startPanning_upvr()
				elseif CurrentCamera_upvr.CameraType ~= Enum.CameraType.Scriptable then
					NotificationClient_upvr:Fire("Invalid location! Can only dig at deposits!", Color3.fromRGB(255, 0, 0), "Error")
				end
				LocalPlayer_upvr:SetAttribute("BackpackLocked", false)
			end
		end
		if arg2 == Enum.UserInputState.End then
			var30_upvw = false
		end
	end
end
class_Tool_upvr.Equipped:Connect(function() -- Line 433
	--[[ Upvalues[5]:
		[1]: var28_upvw (read and write)
		[2]: RunService_upvr (readonly)
		[3]: ToolUI_upvr (readonly)
		[4]: ContextActionService_upvr (readonly)
		[5]: toolToggled_upvr (readonly)
	]]
	local var85_upvw = 0.1
	var28_upvw = RunService_upvr.Heartbeat:Connect(function(arg1) -- Line 435
		--[[ Upvalues[1]:
			[1]: var85_upvw (read and write)
		]]
		var85_upvw += arg1
		if 0.1 <= var85_upvw then
			updatePosition()
		end
	end)
	ToolUI_upvr.FillingPan.Visible = true
	ContextActionService_upvr:BindAction("PanActivate", toolToggled_upvr, true, Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR2)
	ContextActionService_upvr:SetTitle("PanActivate", "Use")
	ContextActionService_upvr:SetPosition("PanActivate", UDim2.new(0.35, 0, 0.25, 0))
	local any_GetButton_result1 = ContextActionService_upvr:GetButton("PanActivate")
	if any_GetButton_result1 then
		any_GetButton_result1.Size = UDim2.new(0.3, 0, 0.3, 0)
		any_GetButton_result1.AnchorPoint = Vector2.new(0.5, 0.5)
		Instance.new("UISizeConstraint", any_GetButton_result1).MinSize = Vector2.new(45, 45)
		Instance.new("UIAspectRatioConstraint", any_GetButton_result1).AspectRatio = 1
		local ActionTitle = any_GetButton_result1:WaitForChild("ActionTitle")
		ActionTitle.AnchorPoint = Vector2.new(0.5, 0.5)
		ActionTitle.Position = UDim2.new(0.5, 0, 0.5, 0)
		ActionTitle.Size = UDim2.new(1, 0, 0.6, 0)
		ActionTitle.TextScaled = true
	end
end)
class_Tool_upvr.Unequipped:Connect(function() -- Line 466
	--[[ Upvalues[5]:
		[1]: var28_upvw (read and write)
		[2]: ToolUI_upvr (readonly)
		[3]: module_upvr (readonly)
		[4]: var29_upvw (read and write)
		[5]: ContextActionService_upvr (readonly)
	]]
	if var28_upvw then
		var28_upvw:Disconnect()
	end
	ToolUI_upvr.FillingPan.Visible = false
	module_upvr.SetControls({})
	var29_upvw = nil
	ContextActionService_upvr:UnbindAction("PanActivate")
end)
local tbl_upvr_2 = {"Ooh!", "Wow!", "Nice!", "Not bad!", "Shiny!"}
local tbl_upvr = {"WOW!", "AWESOME!", "OMG!", "NO WAY!"}
local Head_upvr = Character_upvr:WaitForChild("Head")
local FollowingParticle_upvr = require(game.ReplicatedStorage.Modules.Utility.FollowingParticle)
script.Parent:WaitForChild("PanningComplete").OnClientEvent:Connect(function(arg1, arg2) -- Line 486
	--[[ Upvalues[8]:
		[1]: CommonEffects_upvr (readonly)
		[2]: Head_upvr (readonly)
		[3]: tbl_upvr_2 (readonly)
		[4]: tbl_upvr (readonly)
		[5]: FollowingParticle_upvr (readonly)
		[6]: Rarities_upvr (readonly)
		[7]: Handle_upvr (readonly)
		[8]: HumanoidRootPart_upvr (readonly)
	]]
	if arg1 == "Common" or arg1 == "Uncommon" then
		game.SoundService.SoundEffects.PanningRewards.Common:Play()
	elseif arg1 == "Rare" or arg1 == "Epic" then
		game.SoundService.SoundEffects.PanningRewards.Rare:Play()
		CommonEffects_upvr.DialogText(Head_upvr, tbl_upvr_2[math.random(1, #tbl_upvr_2)])
	else
		game.SoundService.SoundEffects.PanningRewards.Legendary:Play()
		CommonEffects_upvr.DialogText(Head_upvr, tbl_upvr[math.random(1, #tbl_upvr)])
	end
	for i_2, v_2 in arg2 do
		local var98 = 2
		if i_2 == "Legendary" or i_2 == "Mythic" then
			var98 += 2
		elseif i_2 == "Epic" then
			var98 += 0.5
		end
		v_2 = math.min(v_2, 10)
		FollowingParticle_upvr.Emit(FollowingParticle_upvr.Star, {
			Amount = v_2;
			Color = Rarities_upvr.RarityColors[i_2];
			Lifetime = var98;
			Interval = 0.1;
			Origin = Handle_upvr.Position;
			Goal = HumanoidRootPart_upvr;
		})
	end
end)
RunService_upvr.RenderStepped:Connect(function() -- Line 517
	--[[ Upvalues[3]:
		[1]: var43_upvw (read and write)
		[2]: CurrentCamera_upvr (readonly)
		[3]: var42_upvw (read and write)
	]]
	if var43_upvw then
		local Shake = CurrentCamera_upvr:GetAttribute("Shake")
		if Shake then
			CurrentCamera_upvr.CFrame = var42_upvw * Shake
		end
	end
end)
local TweenInfo_new_result1_upvr = TweenInfo.new(0.25)
local var104_upvw = 0.5
local function updateFOV_upvr() -- Line 530, Named "updateFOV"
	--[[ Upvalues[7]:
		[1]: TweenService_upvr (readonly)
		[2]: CurrentCamera_upvr (readonly)
		[3]: TweenInfo_new_result1_upvr (readonly)
		[4]: class_Tool_upvr (readonly)
		[5]: Stats_upvr (readonly)
		[6]: Vignette_upvr (readonly)
		[7]: var104_upvw (read and write)
	]]
	TweenService_upvr:Create(CurrentCamera_upvr, TweenInfo_new_result1_upvr, {
		FieldOfView = 70 - (1 - math.clamp(class_Tool_upvr:GetAttribute("Fill") / Stats_upvr:GetAttribute("Capacity"), 0, 1)) * 10;
	}):Play()
	TweenService_upvr:Create(Vignette_upvr, TweenInfo_new_result1_upvr, {
		ImageTransparency = 1 - (1 - var104_upvw) * (1 - math.clamp(class_Tool_upvr:GetAttribute("Fill") / Stats_upvr:GetAttribute("Capacity"), 0, 1));
	}):Play()
end
Character_upvr:GetAttributeChangedSignal("Panning"):Connect(function() -- Line 535
	--[[ Upvalues[9]:
		[1]: Character_upvr (readonly)
		[2]: class_Tool_upvr (readonly)
		[3]: var104_upvw (read and write)
		[4]: Vignette_upvr (readonly)
		[5]: Rarities_upvr (readonly)
		[6]: updateFOV_upvr (readonly)
		[7]: TweenService_upvr (readonly)
		[8]: CurrentCamera_upvr (readonly)
		[9]: TweenInfo_new_result1_upvr (readonly)
	]]
	if Character_upvr:GetAttribute("Panning") then
		local var108 = class_Tool_upvr:GetAttribute("BestRarity") or "Common"
		if var108 == "Common" or var108 == "Uncommon" then
			var104_upvw = 0.7
		elseif var108 == "Rare" or var108 == "Epic" then
			var104_upvw = 0.5
		else
			var104_upvw = 0.25
		end
		Vignette_upvr.ImageColor3 = Rarities_upvr.RarityColors[var108]
		updateFOV_upvr()
	else
		task.wait(1)
		TweenService_upvr:Create(CurrentCamera_upvr, TweenInfo_new_result1_upvr, {
			FieldOfView = 70;
		}):Play()
		TweenService_upvr:Create(Vignette_upvr, TweenInfo_new_result1_upvr, {
			ImageTransparency = 1;
		}):Play()
	end
end)
class_Tool_upvr:GetAttributeChangedSignal("Fill"):Connect(function() -- Line 558
	--[[ Upvalues[2]:
		[1]: Character_upvr (readonly)
		[2]: updateFOV_upvr (readonly)
	]]
	if Character_upvr:GetAttribute("Panning") then
		updateFOV_upvr()
	end
end)