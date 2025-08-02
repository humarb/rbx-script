local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local remotes = ReplicatedStorage:WaitForChild("Remotes")
local shop = remotes:WaitForChild("Shop")

for k, v in pairs(shop:GetChildren()) do
    print(k, v)
end