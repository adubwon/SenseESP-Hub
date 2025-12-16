-- Teleport Module

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

return function(Window)
    local Rayfield = Window
    
    local TeleportTab = Window:CreateTab("Teleport", 4483362458)
    TeleportTab:CreateSection("Teleport Features")
    
    -- Teleport to Player
    local PlayerList = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(PlayerList, player.Name)
        end
    end
    
    TeleportTab:CreateDropdown({
        Name = "Teleport to Player",
        Options = PlayerList,
        CurrentOption = PlayerList[1] or "None",
        Callback = function(Option)
            local target = Players:FindFirstChild(Option)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character:MoveTo(target.Character.HumanoidRootPart.Position)
                Rayfield:Notify({
                    Title = "Teleported",
                    Content = "Teleported to " .. Option,
                    Duration = 3
                })
            end
        end
    })
    
    -- Fishing Spots
    local FishingSpots = {
        "Deep Ocean Area",
        "Coral Reef",
        "Shipwreck Zone",
        "Iceberg Area",
        "Treasure Bay"
    }
    
    TeleportTab:CreateDropdown({
        Name = "Teleport to Fishing Spot",
        Options = FishingSpots,
        CurrentOption = "Deep Ocean Area",
        Callback = function(Option)
            -- These coordinates would need to be adjusted for the actual game
            local locations = {
                ["Deep Ocean Area"] = Vector3.new(100, -50, 200),
                ["Coral Reef"] = Vector3.new(50, -30, 150),
                ["Shipwreck Zone"] = Vector3.new(-100, -40, -200),
                ["Iceberg Area"] = Vector3.new(-200, 0, 300),
                ["Treasure Bay"] = Vector3.new(150, -20, -150)
            }
            
            if locations[Option] and LocalPlayer.Character then
                LocalPlayer.Character:MoveTo(locations[Option])
                Rayfield:Notify({
                    Title = "Teleported",
                    Content = "Teleported to " .. Option,
                    Duration = 3
                })
            end
        end
    })
    
    -- Bring Player
    TeleportTab:CreateDropdown({
        Name = "Bring Player to You",
        Options = PlayerList,
        CurrentOption = PlayerList[1] or "None",
        Callback = function(Option)
            local target = Players:FindFirstChild(Option)
            if target and target.Character and LocalPlayer.Character then
                target.Character:MoveTo(LocalPlayer.Character.HumanoidRootPart.Position)
                Rayfield:Notify({
                    Title = "Brought Player",
                    Content = "Brought " .. Option .. " to you",
                    Duration = 3
                })
            end
        end
    })
    
    -- Teleport to Safe Zone
    TeleportTab:CreateButton({
        Name = "Teleport to Safe Zone",
        Callback = function()
            if LocalPlayer.Character then
                LocalPlayer.Character:MoveTo(Vector3.new(0, 10, 0))
                Rayfield:Notify({
                    Title = "Teleported",
                    Content = "Teleported to Safe Zone",
                    Duration = 3
                })
            end
        end
    })
    
    -- Teleport Behind Player
    TeleportTab:CreateButton({
        Name = "Teleport Behind Target",
        Callback = function()
            local target = Players:FindFirstChild(PlayerList[1] or "")
            if target and target.Character and LocalPlayer.Character then
                local pos = target.Character.HumanoidRootPart.Position
                local look = target.Character.HumanoidRootPart.CFrame.LookVector
                LocalPlayer.Character:MoveTo(pos - look * 5)
            end
        end
    })
end
