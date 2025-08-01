local sh = game:GetService("Players").LocalPlayer.Character:WaitForChild("Plastic Pan"):WaitForChild("Scripts"):WaitForChild("ToggleShovelActive"):FireServer(true)
print("Shovel:", sh)

local co = game:GetService("Players").LocalPlayer.Character:WaitForChild("Plastic Pan"):WaitForChild("Scripts"):WaitForChild("Collect"):InvokeServer()
print("Collect:", co)

local sh2 = game:GetService("Players").LocalPlayer.Character:WaitForChild("Plastic Pan"):WaitForChild("Scripts"):WaitForChild("ToggleShovelActive"):FireServer(false)
print("Shovel:", sh2)

/*local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function getScriptsFolder()
    local character = player.Character
    if not character then
        warn("No character found")
        return nil
    end
    
    local plasticPan = character:FindFirstChild("Plastic Pan")
    if not plasticPan then
        warn("Plastic Pan not equipped")
        return nil
    end
    
    local scripts = plasticPan:FindFirstChild("Scripts")
    if not scripts then
        warn("Scripts folder not found")
        return nil
    end
    
    return scripts
end

local function toggleShovelActive(active)
    local scripts = getScriptsFolder()
    if not scripts then return end
    
    local toggleRemote = scripts:FindFirstChild("ToggleShovelActive")
    if toggleRemote then
        toggleRemote:FireServer(active) -- RemoteEvent menggunakan FireServer
        print("Toggled shovel:", active)
    else
        warn("ToggleShovelActive not found")
    end
end

local function collect(perfectValue)
    local scripts = getScriptsFolder()
    if not scripts then return end
    
    local collectRemote = scripts:FindFirstChild("Collect")
    if collectRemote then
        local result
        if perfectValue then
            result = collectRemote:InvokeServer(perfectValue) -- RemoteFunction dengan parameter
        else
            result = collectRemote:InvokeServer() -- RemoteFunction tanpa parameter
        end
        print("Collection result:", result)
        return result
    else
        warn("Collect not found")
    end
end

-- Contoh penggunaan:
toggleShovelActive(true)   -- Aktifkan shovel
wait(1)                    -- Tunggu sebentar
collect()                  -- Collect biasa
wait(0.5)
collect(1)                 -- Collect perfect
wait(0.5)
toggleShovelActive(false)  -- Nonaktifkan shovel
*/