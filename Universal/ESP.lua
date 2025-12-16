-- Universal ESP Module
-- Works in any game

return function(Window, Rayfield)
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera
    
    local ESPTab = Window:CreateTab("👁️ ESP", 4483362458)
    ESPTab:CreateSection("Visual ESP Settings")
    
    -- ESP Variables
    local ESPEnabled = false
    local ESPFolder = Instance.new("Folder")
    ESPFolder.Name = "UniversalESPFolder"
    ESPFolder.Parent = game.CoreGui
    
    local Settings = {
        Box = false,
        Tracer = false,
        Name = false,
        Distance = false,
        Health = false,
        TeamColor = false,
        Color = Color3.fromRGB(0, 255, 0),
        MaxDistance = 2000
    }
    
    local ESPObjects = {}
    
    local function clearESP()
        for _, objects in pairs(ESPObjects) do
            for _, obj in pairs(objects) do
                if obj then obj:Destroy() end
            end
        end
        ESPObjects = {}
    end
    
    local function createESP(player)
        if ESPObjects[player] then return end
        
        local objects = {}
        ESPObjects[player] = objects
        
        -- Box
        objects.Box = Instance.new("Frame")
        objects.Box.Parent = ESPFolder
        objects.Box.BackgroundTransparency = 1
        objects.Box.BorderSizePixel = 2
        objects.Box.BorderColor3 = Settings.Color
        objects.Box.ZIndex = 10
        objects.Box.Visible = false
        
        -- Tracer
        objects.Tracer = Instance.new("Frame")
        objects.Tracer.Parent = ESPFolder
        objects.Tracer.BackgroundColor3 = Settings.Color
        objects.Tracer.BorderSizePixel = 0
        objects.Tracer.ZIndex = 10
        objects.Tracer.Visible = false
        
        -- Name
        objects.Name = Instance.new("TextLabel")
        objects.Name.Parent = ESPFolder
        objects.Name.BackgroundTransparency = 1
        objects.Name.Text = player.Name
        objects.Name.TextColor3 = Settings.Color
        objects.Name.TextSize = 14
        objects.Name.Font = Enum.Font.SourceSansBold
        objects.Name.ZIndex = 10
        objects.Name.Visible = false
        
        -- Distance
        objects.Distance = Instance.new("TextLabel")
        objects.Distance.Parent = ESPFolder
        objects.Distance.BackgroundTransparency = 1
        objects.Distance.TextColor3 = Settings.Color
        objects.Distance.TextSize = 12
        objects.Distance.Font = Enum.Font.SourceSans
        objects.Distance.ZIndex = 10
        objects.Distance.Visible = false
        
        -- Update loop
        local connection = RunService.RenderStepped:Connect(function()
            if not ESPEnabled or not player.Character then
                for _, obj in pairs(objects) do
                    if obj then obj.Visible = false end
                end
                return
            end
            
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if not root then return end
            
            local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
            if not onScreen then
                for _, obj in pairs(objects) do
                    if obj then obj.Visible = false end
                end
                return
            end
            
            -- Update visibility based on settings
            if objects.Box then
                objects.Box.Visible = Settings.Box
                if objects.Box.Visible then
                    objects.Box.Size = UDim2.new(0, 50, 0, 100)
                    objects.Box.Position = UDim2.new(0, pos.X - 25, 0, pos.Y - 100)
                end
            end
            
            if objects.Name then
                objects.Name.Visible = Settings.Name
                if objects.Name.Visible then
                    objects.Name.Position = UDim2.new(0, pos.X, 0, pos.Y - 120)
                end
            end
        end)
        
        table.insert(objects, connection)
    end
    
    -- ESP Toggle
    ESPTab:CreateToggle({
        Name = "Enable ESP",
        CurrentValue = false,
        Callback = function(Value)
            ESPEnabled = Value
            if Value then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer then
                        createESP(player)
                    end
                end
            else
                clearESP()
            end
        end
    })
    
    -- Feature toggles
    ESPTab:CreateToggle({
        Name = "Box ESP",
        CurrentValue = false,
        Callback = function(Value)
            Settings.Box = Value
        end
    })
    
    ESPTab:CreateToggle({
        Name = "Tracer ESP",
        CurrentValue = false,
        Callback = function(Value)
            Settings.Tracer = Value
        end
    })
    
    ESPTab:CreateToggle({
        Name = "Name ESP",
        CurrentValue = false,
        Callback = function(Value)
            Settings.Name = Value
        end
    })
    
    ESPTab:CreateToggle({
        Name = "Distance ESP",
        CurrentValue = false,
        Callback = function(Value)
            Settings.Distance = Value
        end
    })
    
    ESPTab:CreateToggle({
        Name = "Team Colors",
        CurrentValue = false,
        Callback = function(Value)
            Settings.TeamColor = Value
        end
    })
    
    ESPTab:CreateColorPicker({
        Name = "ESP Color",
        Color = Settings.Color,
        Callback = function(Color)
            Settings.Color = Color
        end
    })
    
    ESPTab:CreateSlider({
        Name = "Max Distance",
        Range = {0, 5000},
        Increment = 50,
        Suffix = "studs",
        CurrentValue = 2000,
        Callback = function(Value)
            Settings.MaxDistance = Value
        end
    })
    
    -- Player connections
    Players.PlayerAdded:Connect(function(player)
        if ESPEnabled then
            createESP(player)
        end
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        if ESPObjects[player] then
            for _, obj in pairs(ESPObjects[player]) do
                if obj then obj:Destroy() end
            end
            ESPObjects[player] = nil
        end
    end)
    
    Rayfield:Notify({
        Title = "Universal ESP Loaded",
        Content = "ESP features enabled",
        Duration = 3
    })
end
