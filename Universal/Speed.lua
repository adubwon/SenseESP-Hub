-- Speed Hack Module

return function(Window, Rayfield)
    local SpeedTab = Window:CreateTab("⚡ Speed Hack")
    
    SpeedTab:CreateSection("Movement Settings")
    
    -- Speed variables
    local SpeedEnabled = false
    local CurrentSpeed = 50
    local OriginalSpeed = 16
    
    -- Store original speed
    local player = game:GetService("Players").LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        OriginalSpeed = player.Character.Humanoid.WalkSpeed
    end
    
    -- Speed Toggle
    SpeedTab:CreateToggle({
        Name = "Enable Speed Hack",
        CurrentValue = false,
        Callback = function(Value)
            SpeedEnabled = Value
            
            if Value then
                -- Apply speed
                game:GetService("RunService").Heartbeat:Connect(function()
                    if player.Character and player.Character:FindFirstChild("Humanoid") then
                        player.Character.Humanoid.WalkSpeed = CurrentSpeed
                    end
                end)
            else
                -- Reset to original
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid.WalkSpeed = OriginalSpeed
                end
            end
        end
    })
    
    -- Speed Slider
    SpeedTab:CreateSlider({
        Name = "Speed Value",
        Range = {16, 200},
        Increment = 1,
        Suffix = "studs",
        CurrentValue = 50,
        Callback = function(Value)
            CurrentSpeed = Value
            if SpeedEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = Value
            end
        end
    })
    
    -- Jump Power
    SpeedTab:CreateSlider({
        Name = "Jump Power",
        Range = {50, 250},
        Increment = 5,
        Suffix = "power",
        CurrentValue = 50,
        Callback = function(Value)
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.JumpPower = Value
            end
        end
    })
    
    Rayfield:Notify({
        Title = "Speed Hack Loaded",
        Content = "Movement features ready",
        Duration = 3
    })
end
