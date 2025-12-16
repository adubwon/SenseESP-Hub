-- Spear Fishing Simulator (PlaceId: 101953168527257)
-- Game-specific features

return function(Window, Rayfield)
    -- Create main tab for game features
    local GameTab = Window:CreateTab("🎣 Spear Fishing", 4483362458)
    
    GameTab:CreateSection("Fishing Features")
    
    -- Auto Fish
    GameTab:CreateToggle({
        Name = "Auto Fish",
        CurrentValue = false,
        Callback = function(Value)
            if Value then
                spawn(function()
                    while wait(1) do
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
    
    -- Auto Collect
    GameTab:CreateToggle({
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
    GameTab:CreateToggle({
        Name = "Infinite Oxygen",
        CurrentValue = false,
        Callback = function(Value)
            if Value then
                local oxygen = game:GetService("Players").LocalPlayer.PlayerScripts:FindFirstChild("Swimming")
                if oxygen then
                    oxygen.Oxygen.Value = 100
                    oxygen.Oxygen.Changed:Connect(function()
                        oxygen.Oxygen.Value = 100
                    end)
                end
            end
        end
    })
    
    -- Teleport to Spots
    GameTab:CreateSection("Teleport")
    
    local Spots = {"Deep Ocean", "Coral Reef", "Shipwreck", "Iceberg"}
    
    GameTab:CreateDropdown({
        Name = "Fishing Spots",
        Options = Spots,
        CurrentOption = Spots[1],
        Callback = function(Option)
            -- Add teleport coordinates here
            Rayfield:Notify({
                Title = "Teleporting",
                Content = "Going to: " .. Option,
                Duration = 3
            })
        end
    })
    
    -- Stats Section
    GameTab:CreateSection("Stats")
    
    GameTab:CreateSlider({
        Name = "Walk Speed",
        Range = {16, 100},
        Increment = 1,
        Suffix = "studs",
        CurrentValue = 16,
        Callback = function(Value)
            game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    })
    
    GameTab:CreateSlider({
        Name = "Jump Power",
        Range = {50, 200},
        Increment = 5,
        Suffix = "power",
        CurrentValue = 50,
        Callback = function(Value)
            game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = Value
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
    
    Rayfield:Notify({
        Title = "Spear Fishing Script Loaded",
        Content = "All game features enabled!",
        Duration = 4
    })
end
