-- ESP System with Player Highlighting

return function(Window, Rayfield)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    
    local ESPTab = Window:CreateTab("👁️ ESP System")
    
    ESPTab:CreateSection("Player Highlighting")
    
    -- ESP Variables
    local ESPEnabled = false
    local HighlightInstances = {}
    
    -- Function to create highlight
    local function createHighlight(player)
        if HighlightInstances[player] then return end
        
        local highlight = Instance.new("Highlight")
        highlight.Name = player.Name .. "_Highlight"
        highlight.FillColor = Color3.fromRGB(0, 255, 0)  -- Green
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = player.Character
        
        -- Store reference
        HighlightInstances[player] = highlight
        
        -- Track character changes
        player.CharacterAdded:Connect(function(character)
            wait(0.5)  -- Wait for character to load
            if HighlightInstances[player] then
                HighlightInstances[player].Parent = character
            else
                createHighlight(player)
            end
        end)
        
        player.CharacterRemoving:Connect(function()
            if HighlightInstances[player] then
                HighlightInstances[player]:Destroy()
                HighlightInstances[player] = nil
            end
        end)
    end
    
    -- Function to remove highlight
    local function removeHighlight(player)
        if HighlightInstances[player] then
            HighlightInstances[player]:Destroy()
            HighlightInstances[player] = nil
        end
    end
    
    -- Function to update all highlights
    local function updateHighlights()
        for player, highlight in pairs(HighlightInstances) do
            if player.Character and highlight then
                highlight.Adornee = player.Character
            elseif highlight then
                highlight:Destroy()
                HighlightInstances[player] = nil
            end
        end
    end
    
    -- ESP Toggle
    local ESPToggle = ESPTab:CreateToggle({
        Name = "Enable Player Highlight",
        CurrentValue = false,
        Callback = function(Value)
            ESPEnabled = Value
            
            if Value then
                -- Enable ESP for all players
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        createHighlight(player)
                    end
                end
                
                -- Start update loop
                RunService.Heartbeat:Connect(updateHighlights)
                
                Rayfield:Notify({
                    Title = "ESP Enabled",
                    Content = "Player highlighting activated",
                    Duration = 3
                })
            else
                -- Disable ESP
                for player, highlight in pairs(HighlightInstances) do
                    if highlight then
                        highlight:Destroy()
                    end
                end
                HighlightInstances = {}
                
                Rayfield:Notify({
                    Title = "ESP Disabled",
                    Content = "Player highlighting removed",
                    Duration = 3
                })
            end
        end
    })
    
    -- Highlight Color Picker
    local HighlightColor = Color3.fromRGB(0, 255, 0)
    
    ESPTab:CreateColorPicker({
        Name = "Highlight Color",
        Color = HighlightColor,
        Callback = function(Color)
            HighlightColor = Color
            for _, highlight in pairs(HighlightInstances) do
                if highlight then
                    highlight.FillColor = Color
                end
            end
        end
    })
    
    -- Outline Color Picker
    ESPTab:CreateColorPicker({
        Name = "Outline Color",
        Color = Color3.fromRGB(255, 255, 255),
        Callback = function(Color)
            for _, highlight in pairs(HighlightInstances) do
                if highlight then
                    highlight.OutlineColor = Color
                end
            end
        end
    })
    
    -- Transparency Slider
    ESPTab:CreateSlider({
        Name = "Fill Transparency",
        Range = {0, 100},
        Increment = 5,
        Suffix = "%",
        CurrentValue = 50,
        Callback = function(Value)
            for _, highlight in pairs(HighlightInstances) do
                if highlight then
                    highlight.FillTransparency = Value / 100
                end
            end
        end
    })
    
    -- Team Check Toggle
    ESPTab:CreateToggle({
        Name = "Team Color Mode",
        CurrentValue = false,
        Callback = function(Value)
            if Value then
                -- Use team colors
                for player, highlight in pairs(HighlightInstances) do
                    if highlight and player.Team then
                        highlight.FillColor = player.Team.TeamColor.Color
                    end
                end
            else
                -- Use custom color
                for _, highlight in pairs(HighlightInstances) do
                    if highlight then
                        highlight.FillColor = HighlightColor
                    end
                end
            end
        end
    })
    
    -- Show Distance Toggle
    ESPTab:CreateToggle({
        Name = "Show Distance",
        CurrentValue = false,
        Callback = function(Value)
            -- Distance display logic would go here
        end
    })
    
    -- Max Distance Slider
    ESPTab:CreateSlider({
        Name = "Max Distance",
        Range = {0, 5000},
        Increment = 100,
        Suffix = "studs",
        CurrentValue = 2000,
        Callback = function(Value)
            -- Distance filtering logic
        end
    })
    
    -- Refresh Button
    ESPTab:CreateButton({
        Name = "Refresh ESP",
        Callback = function()
            -- Remove all highlights
            for player, highlight in pairs(HighlightInstances) do
                if highlight then
                    highlight:Destroy()
                end
            end
            HighlightInstances = {}
            
            -- Recreate for all players
            if ESPEnabled then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        createHighlight(player)
                    end
                end
            end
        end
    })
    
    -- Player added/removed connections
    Players.PlayerAdded:Connect(function(player)
        if ESPEnabled then
            player.CharacterAdded:Connect(function()
                wait(0.5)
                if ESPEnabled then
                    createHighlight(player)
                end
            end)
        end
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        removeHighlight(player)
    end)
    
    -- Initialize for existing players
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            createHighlight(player)
        end
    end
    
    Rayfield:Notify({
        Title = "ESP System Loaded",
        Content = "Player highlighting ready",
        Duration = 3
    })
    
    return {
        Enable = function()
            ESPToggle:Set(true)
        end,
        Disable = function()
            ESPToggle:Set(false)
        end
    }
end
