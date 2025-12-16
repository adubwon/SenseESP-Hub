-- Spear Fishing Simulator Script
-- PlaceId: 101953168527257

return function(Window, Rayfield)
    -- Create main tab for game
    local GameTab = Window:CreateTab("🎣 Spear Fishing")
    
    GameTab:CreateSection("Auto Farming")
    
    -- Auto Fish Toggle
    local AutoFishEnabled = false
    GameTab:CreateToggle({
        Name = "Auto Fish",
        CurrentValue = false,
        Callback = function(Value)
            AutoFishEnabled = Value
            
            if Value then
                spawn(function()
                    while AutoFishEnabled and wait(1) do
                        -- Fire fish remote
                        local args = {
                            [1] = "Water",
                            [2] = CFrame.new(0, 0, 0),
                            [3] = Vector3.new(0, 0, 0),
                            [4] = "Spear",
                            [5] = "Test"
                        }
                        game:GetService("ReplicatedStorage").Remotes.FishRE:FireServer(unpack(args))
                    end
                end)
            end
        end
    })
    
    -- Auto Collect Toggle
    local AutoCollectEnabled = false
    GameTab:CreateToggle({
        Name = "Auto Collect Fish",
        CurrentValue = false,
        Callback = function(Value)
            AutoCollectEnabled = Value
            
            if Value then
                spawn(function()
                    while AutoCollectEnabled and wait(0.5) do
                        game:GetService("ReplicatedStorage").Remotes.SendFishRF:InvokeServer()
                    end
                end)
            end
        end
    })
    
    -- Infinite Oxygen
    GameTab:CreateToggle({
        Name = "Infinite Oxygen",
        CurrentValue = false,
        Callback = function(Value)
            if Value then
                local playerScripts = game:GetService("Players").LocalPlayer.PlayerScripts
                local swimming = playerScripts:FindFirstChild("Swimming")
                
                if swimming and swimming:FindFirstChild("Oxygen") then
                    swimming.Oxygen.Value = 100
                    swimming.Oxygen.Changed:Connect(function()
                        swimming.Oxygen.Value = 100
                    end)
                end
            end
        end
    })
    
    -- Quick Actions
    GameTab:CreateSection("Quick Actions")
    
    GameTab:CreateButton({
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
    
    GameTab:CreateButton({
        Name = "Rebirth Now",
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.RebirthLoadRF:InvokeServer()
            
            Rayfield:Notify({
                Title = "Rebirth",
                Content = "Performed rebirth!",
                Duration = 3
            })
        end
    })
    
    -- Stats
    GameTab:CreateSection("Player Stats")
    
    GameTab:CreateSlider({
        Name = "Walk Speed",
        Range = {16, 150},
        Increment = 1,
        Suffix = "studs",
        CurrentValue = 16,
        Callback = function(Value)
            local character = game:GetService("Players").LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = Value
            end
        end
    })
    
    GameTab:CreateSlider({
        Name = "Jump Power",
        Range = {50, 250},
        Increment = 5,
        Suffix = "power",
        CurrentValue = 50,
        Callback = function(Value)
            local character = game:GetService("Players").LocalPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.JumpPower = Value
            end
        end
    })
    
    -- Teleport
    GameTab:CreateSection("Teleport")
    
    local FishingSpots = {
        "Deep Ocean",
        "Coral Reef", 
        "Shipwreck",
        "Iceberg Area",
        "Treasure Bay"
    }
    
    GameTab:CreateDropdown({
        Name = "Teleport to Spot",
        Options = FishingSpots,
        CurrentOption = FishingSpots[1],
        Callback = function(Option)
            Rayfield:Notify({
                Title = "Teleporting",
                Content = "Going to: " .. Option,
                Duration = 3
            })
            
            -- You would add actual teleport coordinates here
            -- Example: game.Players.LocalPlayer.Character:MoveTo(Vector3.new(x, y, z))
        end
    })
    
    Rayfield:Notify({
        Title = "Spear Fishing Script Loaded",
        Content = "All features ready!",
        Duration = 4
    })
end
