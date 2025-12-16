-- Spear Fishing Game Module (PlaceId: 101953168527257)
-- Features for https://www.roblox.com/games/101953168527257/Spear-Fishing

return function(Window)
    local Rayfield = Window
    
    -- Main Tab
    local MainTab = Window:CreateTab("Spear Fishing", 4483362458)
    
    -- Load modules
    local function loadModule(url)
        return loadstring(game:HttpGet(url))()
    end
    
    -- Load all modules
    local ESP = loadModule("https://raw.githubusercontent.com/yourusername/SenseESP-Hub/main/Modules/ESP.lua")
    local RemoteFinder = loadModule("https://raw.githubusercontent.com/yourusername/SenseESP-Hub/main/Modules/RemoteFinder.lua")
    local AutoFarm = loadModule("https://raw.githubusercontent.com/yourusername/SenseESP-Hub/main/Modules/AutoFarm.lua")
    local Teleport = loadModule("https://raw.githubusercontent.com/yourusername/SenseESP-Hub/main/Modules/Teleport.lua")
    
    -- Initialize modules
    if ESP then ESP(Window) end
    if RemoteFinder then RemoteFinder(Window) end
    if AutoFarm then AutoFarm(Window) end
    if Teleport then Teleport(Window) end
    
    -- Game-Specific Features
    local GameSection = MainTab:CreateSection("Spear Fishing Features")
    
    -- Auto Fish
    local AutoFishEnabled = false
    MainTab:CreateToggle({
        Name = "Auto Fish",
        CurrentValue = false,
        Callback = function(Value)
            AutoFishEnabled = Value
            if Value then
                startAutoFish()
            end
        end
    })
    
    local function startAutoFish()
        spawn(function()
            while AutoFishEnabled do
                local args = {
                    [1] = "Water",
                    [2] = CFrame.new(0, 0, 0),
                    [3] = Vector3.new(0, 0, 0),
                    [4] = "Spear",
                    [5] = "Test"
                }
                game:GetService("ReplicatedStorage").Remotes.FishRE:FireServer(unpack(args))
                wait(1)
            end
        end)
    end
    
    -- Auto Collect Fish
    MainTab:CreateToggle({
        Name = "Auto Collect Fish",
        CurrentValue = false,
        Callback = function(Value)
            if Value then
                spawn(function()
                    while wait(0.5) do
                        game:GetService("ReplicatedStorage").Remotes.SendFishRF:InvokeServer()
                    end
                end)
            end
        end
    })
    
    -- Infinite Oxygen
    MainTab:CreateToggle({
        Name = "Infinite Oxygen",
        CurrentValue = false,
        Callback = function(Value)
            if Value then
                game:GetService("Players").LocalPlayer.PlayerScripts.Swimming.Oxygen.Value = 100
                game:GetService("Players").LocalPlayer.PlayerScripts.Swimming.Oxygen.Changed:Connect(function()
                    game:GetService("Players").LocalPlayer.PlayerScripts.Swimming.Oxygen.Value = 100
                end)
            end
        end
    })
    
    -- Teleport to Best Fishing Spots
    local FishingSpots = {
        "Deep Ocean",
        "Coral Reef",
        "Shipwreck",
        "Iceberg"
    }
    
    MainTab:CreateDropdown({
        Name = "Teleport to Spot",
        Options = FishingSpots,
        CurrentOption = "Deep Ocean",
        Callback = function(Option)
            -- Teleport logic here
            Rayfield:Notify({
                Title = "Teleporting",
                Content = "Going to: " .. Option,
                Duration = 3
            })
        end
    })
    
    -- Auto Rebirth
    MainTab:CreateToggle({
        Name = "Auto Rebirth",
        CurrentValue = false,
        Callback = function(Value)
            if Value then
                spawn(function()
                    while wait(5) do
                        game:GetService("ReplicatedStorage").Remotes.RebirthLoadRF:InvokeServer()
                    end
                end)
            end
        end
    })
    
    -- Collect All Daily Rewards
    MainTab:CreateButton({
        Name = "Claim Daily Rewards",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.DailyRE:FireServer()
            game:GetService("ReplicatedStorage").Remotes.OnlineRewardRF:InvokeServer()
            Rayfield:Notify({
                Title = "Daily Rewards",
                Content = "Claimed all daily rewards!",
                Duration = 3
            })
        end
    })
    
    -- Speed Hack
    local SpeedHackValue = 16
    MainTab:CreateSlider({
        Name = "Walk Speed",
        Range = {16, 100},
        Increment = 1,
        Suffix = "studs",
        CurrentValue = 16,
        Callback = function(Value)
            SpeedHackValue = Value
            game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    })
    
    -- Jump Power
    MainTab:CreateSlider({
        Name = "Jump Power",
        Range = {50, 200},
        Increment = 5,
        Suffix = "power",
        CurrentValue = 50,
        Callback = function(Value)
            game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = Value
        end
    })
    
    -- No Clip
    MainTab:CreateToggle({
        Name = "No Clip",
        CurrentValue = false,
        Callback = function(Value)
            if Value then
                game:GetService("RunService").Stepped:Connect(function()
                    if game:GetService("Players").LocalPlayer.Character then
                        for _, v in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
                            if v:IsA("BasePart") then
                                v.CanCollide = false
                            end
                        end
                    end
                end)
            end
        end
    })
    
    Rayfield:Notify({
        Title = "Spear Fishing Loaded",
        Content = "All features enabled!",
        Duration = 3
    })
end
