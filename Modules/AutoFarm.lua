-- Auto Farm Module for Spear Fishing

return function(Window)
    local Rayfield = Window
    
    local FarmTab = Window:CreateTab("Auto Farm", 4483362458)
    FarmTab:CreateSection("Farming Features")
    
    local AutoFarmEnabled = false
    local AutoFishEnabled = false
    local AutoCollectEnabled = false
    local AutoRebirthEnabled = false
    
    -- Auto Farm Toggle
    FarmTab:CreateToggle({
        Name = "Enable Auto Farm",
        CurrentValue = false,
        Callback = function(Value)
            AutoFarmEnabled = Value
            if Value then
                startAutoFarm()
            end
        end
    })
    
    local function startAutoFarm()
        spawn(function()
            while AutoFarmEnabled do
                -- Auto Fish
                if AutoFishEnabled then
                    local args = {
                        [1] = "Water",
                        [2] = CFrame.new(0, 0, 0),
                        [3] = Vector3.new(0, 0, 0),
                        [4] = "Spear",
                        [5] = "Test"
                    }
                    game:GetService("ReplicatedStorage").Remotes.FishRE:FireServer(unpack(args))
                end
                
                -- Auto Collect
                if AutoCollectEnabled then
                    game:GetService("ReplicatedStorage").Remotes.SendFishRF:InvokeServer()
                end
                
                -- Auto Rebirth
                if AutoRebirthEnabled then
                    game:GetService("ReplicatedStorage").Remotes.RebirthLoadRF:InvokeServer()
                end
                
                wait(1)
            end
        end)
    end
    
    -- Individual Toggles
    FarmTab:CreateToggle({
        Name = "Auto Fish",
        CurrentValue = false,
        Callback = function(Value)
            AutoFishEnabled = Value
        end
    })
    
    FarmTab:CreateToggle({
        Name = "Auto Collect Fish",
        CurrentValue = false,
        Callback = function(Value)
            AutoCollectEnabled = Value
        end
    })
    
    FarmTab:CreateToggle({
        Name = "Auto Rebirth",
        CurrentValue = false,
        Callback = function(Value)
            AutoRebirthEnabled = Value
        end
    })
    
    -- Auto Daily Rewards
    FarmTab:CreateToggle({
        Name = "Auto Daily Rewards",
        CurrentValue = false,
        Callback = function(Value)
            if Value then
                spawn(function()
                    while wait(300) do -- Every 5 minutes
                        game:GetService("ReplicatedStorage").Remotes.DailyRE:FireServer()
                        game:GetService("ReplicatedStorage").Remotes.OnlineRewardRF:InvokeServer()
                    end
                end)
            end
        end
    })
    
    -- Farm Settings
    FarmTab:CreateSlider({
        Name = "Farm Speed",
        Range = {0.1, 5},
        Increment = 0.1,
        Suffix = "seconds",
        CurrentValue = 1,
        Callback = function(Value)
            -- Adjust farm speed
        end
    })
    
    -- Quick Actions
    FarmTab:CreateButton({
        Name = "Claim All Daily",
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
    
    FarmTab:CreateButton({
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
end
