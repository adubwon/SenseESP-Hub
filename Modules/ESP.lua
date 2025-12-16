-- Enhanced ESP Module with fixes

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

return function(Window)
    local Rayfield = Window
    
    local ESPTab = Window:CreateTab("ESP", 4483362458)
    ESPTab:CreateSection("Visual ESP")
    
    -- ESP Variables
    local ESPEnabled = false
    local ESPFolder = Instance.new("Folder")
    ESPFolder.Name = "SenseESPFolder"
    ESPFolder.Parent = game.CoreGui
    
    -- Settings
    local Settings = {
        BoxESP = false,
        TracerESP = false,
        NameESP = false,
        DistanceESP = false,
        HealthESP = false,
        TeamCheck = false,
        ESPColor = Color3.fromRGB(0, 255, 0),
        MaxDistance = 1000
    }
    
    -- Player ESP Objects
    local ESPObjects = {}
    
    -- Clear ESP
    local function clearESP()
        for _, objects in pairs(ESPObjects) do
            for _, obj in pairs(objects) do
                if obj then
                    obj:Destroy()
                end
            end
        end
        ESPObjects = {}
        ESPFolder:ClearAllChildren()
    end
    
    -- Create ESP for player
    local function createESP(player)
        if ESPObjects[player] then return end
        
        ESPObjects[player] = {}
        local objects = ESPObjects[player]
        
        -- Box
        objects.Box = Instance.new("Frame")
        objects.Box.Name = player.Name .. "_Box"
        objects.Box.Parent = ESPFolder
        objects.Box.BackgroundTransparency = 1
        objects.Box.BorderSizePixel = 2
        objects.Box.BorderColor3 = Settings.ESPColor
        objects.Box.ZIndex = 10
        objects.Box.Visible = false
        
        -- Tracer
        objects.Tracer = Instance.new("Frame")
        objects.Tracer.Name = player.Name .. "_Tracer"
        objects.Tracer.Parent = ESPFolder
        objects.Tracer.BackgroundColor3 = Settings.ESPColor
        objects.Tracer.BorderSizePixel = 0
        objects.Tracer.ZIndex = 10
        objects.Tracer.Visible = false
        
        -- Name
        objects.Name = Instance.new("TextLabel")
        objects.Name.Name = player.Name .. "_Name"
        objects.Name.Parent = ESPFolder
        objects.Name.BackgroundTransparency = 1
        objects.Name.Text = player.Name
        objects.Name.TextColor3 = Settings.ESPColor
        objects.Name.TextSize = 14
        objects.Name.Font = Enum.Font.SourceSansBold
        objects.Name.ZIndex = 10
        objects.Name.Visible = false
        
        -- Distance
        objects.Distance = Instance.new("TextLabel")
        objects.Distance.Name = player.Name .. "_Distance"
        objects.Distance.Parent = ESPFolder
        objects.Distance.BackgroundTransparency = 1
        objects.Distance.TextColor3 = Settings.ESPColor
        objects.Distance.TextSize = 12
        objects.Distance.Font = Enum.Font.SourceSans
        objects.Distance.ZIndex = 10
        objects.Distance.Visible = false
        
        -- Health
        objects.Health = Instance.new("TextLabel")
        objects.Health.Name = player.Name .. "_Health"
        objects.Health.Parent = ESPFolder
        objects.Health.BackgroundTransparency = 1
        objects.Health.TextColor3 = Color3.fromRGB(255, 255, 255)
        objects.Health.TextSize = 12
        objects.Health.Font = Enum.Font.SourceSans
        objects.Health.ZIndex = 10
        objects.Health.Visible = false
        
        -- Update function
        local function updateESP()
            if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                for _, obj in pairs(objects) do
                    if obj then obj.Visible = false end
                end
                return
            end
            
            local character = player.Character
            local rootPart = character.HumanoidRootPart
            local position, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            
            if not onScreen then
                for _, obj in pairs(objects) do
                    if obj then obj.Visible = false end
                end
                return
            end
            
            -- Calculate distance
            local distance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) 
                and (rootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude 
                or 0
            
            if distance > Settings.MaxDistance then
                for _, obj in pairs(objects) do
                    if obj then obj.Visible = false end
                end
                return
            end
            
            -- Update Box
            if objects.Box then
                objects.Box.Visible = Settings.BoxESP and ESPEnabled
                objects.Box.Size = UDim2.new(0, 50, 0, 100)
                objects.Box.Position = UDim2.new(0, position.X - 25, 0, position.Y - 100)
            end
            
            -- Update Tracer
            if objects.Tracer then
                objects.Tracer.Visible = Settings.TracerESP and ESPEnabled
                if objects.Tracer.Visible then
                    local screenSize = Camera.ViewportSize
                    objects.Tracer.Size = UDim2.new(0, 2, 0, math.sqrt((position.X - screenSize.X/2)^2 + (position.Y - screenSize.Y)^2))
                    objects.Tracer.Position = UDim2.new(0, position.X, 0, position.Y)
                    objects.Tracer.Rotation = math.deg(math.atan2(position.Y - screenSize.Y, position.X - screenSize.X/2))
                end
            end
            
            -- Update Name
            if objects.Name then
                objects.Name.Visible = Settings.NameESP and ESPEnabled
                objects.Name.Position = UDim2.new(0, position.X, 0, position.Y - 120)
            end
            
            -- Update Distance
            if objects.Distance then
                objects.Distance.Visible = Settings.DistanceESP and ESPEnabled
                objects.Distance.Text = math.floor(distance) .. " studs"
                objects.Distance.Position = UDim2.new(0, position.X, 0, position.Y - 105)
            end
            
            -- Update Health
            if objects.Health then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    objects.Health.Visible = Settings.HealthESP and ESPEnabled
                    local health = math.floor(humanoid.Health)
                    local maxHealth = math.floor(humanoid.MaxHealth)
                    objects.Health.Text = health .. "/" .. maxHealth
                    objects.Health.Position = UDim2.new(0, position.X, 0, position.Y - 90)
                    
                    -- Health color
                    local percent = health / maxHealth
                    if percent > 0.5 then
                        objects.Health.TextColor3 = Color3.fromRGB(0, 255, 0)
                    elseif percent > 0.25 then
                        objects.Health.TextColor3 = Color3.fromRGB(255, 255, 0)
                    else
                        objects.Health.TextColor3 = Color3.fromRGB(255, 0, 0)
                    end
                else
                    objects.Health.Visible = false
                end
            end
        end
        
        -- Add to update loop
        table.insert(ESPObjects[player], RunService.RenderStepped:Connect(updateESP))
    end
    
    -- Toggle ESP
    ESPTab:CreateToggle({
        Name = "Enable ESP",
        CurrentValue = false,
        Callback = function(Value)
            ESPEnabled = Value
            if not Value then
                clearESP()
            else
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer then
                        createESP(player)
                    end
                end
            end
        end
    })
    
    -- ESP Features
    ESPTab:CreateToggle({
        Name = "Box ESP",
        CurrentValue = false,
        Callback = function(Value)
            Settings.BoxESP = Value
        end
    })
    
    ESPTab:CreateToggle({
        Name = "Tracer ESP",
        CurrentValue = false,
        Callback = function(Value)
            Settings.TracerESP = Value
        end
    })
    
    ESPTab:CreateToggle({
        Name = "Name ESP",
        CurrentValue = false,
        Callback = function(Value)
            Settings.NameESP = Value
        end
    })
    
    ESPTab:CreateToggle({
        Name = "Distance ESP",
        CurrentValue = false,
        Callback = function(Value)
            Settings.DistanceESP = Value
        end
    })
    
    ESPTab:CreateToggle({
        Name = "Health ESP",
        CurrentValue = false,
        Callback = function(Value)
            Settings.HealthESP = Value
        end
    })
    
    ESPTab:CreateToggle({
        Name = "Team Check",
        CurrentValue = false,
        Callback = function(Value)
            Settings.TeamCheck = Value
        end
    })
    
    ESPTab:CreateColorPicker({
        Name = "ESP Color",
        Color = Settings.ESPColor,
        Callback = function(Color)
            Settings.ESPColor = Color
        end
    })
    
    ESPTab:CreateSlider({
        Name = "Max Distance",
        Range = {0, 5000},
        Increment = 50,
        Suffix = "studs",
        CurrentValue = 1000,
        Callback = function(Value)
            Settings.MaxDistance = Value
        end
    })
    
    -- Player connections
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            if ESPEnabled then
                wait(0.5)
                createESP(player)
            end
        end)
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        if ESPObjects[player] then
            for _, connection in pairs(ESPObjects[player]) do
                connection:Disconnect()
            end
            ESPObjects[player] = nil
        end
    end)
    
    -- Initialize ESP for existing players
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            createESP(player)
        end
    end
    
    ESPTab:CreateButton({
        Name = "Refresh ESP",
        Callback = function()
            clearESP()
            if ESPEnabled then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer then
                        createESP(player)
                    end
                end
            end
        end
    })
end
