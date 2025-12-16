-- Universal ESP Hub
-- GitHub: https://github.com/yourusername/SenseESP-Hub

-- Load RayField UI
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success then
    -- Fallback to simple notification
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Error",
        Text = "Failed to load RayField UI",
        Duration = 5
    })
    return
end

-- Get current game info
local PlaceId = game.PlaceId
local GameName = game:GetService("MarketplaceService"):GetProductInfo(PlaceId).Name

-- Supported Games Database
local SupportedGames = {
    [101953168527257] = {
        Name = "Spear Fishing Simulator",
        Description = "Fishing game with ocean exploration",
        Loader = "Games/SpearFishing.lua"
    },
    [2753915549] = {
        Name = "Blox Fruits",
        Description = "Anime fighting game with fruits",
        Loader = "Games/BloxFruits.lua"
    },
    [286090429] = {
        Name = "Arsenal",
        Description = "FPS shooter game",
        Loader = "Games/Arsenal.lua"
    },
    [142823291] = {
        Name = "Murder Mystery 2",
        Description = "Murder mystery game",
        Loader = "Games/MurderMystery2.lua"
    }
}

-- Function to load modules from GitHub
local function loadModule(path)
    local url = "https://raw.githubusercontent.com/yourusername/SenseESP-Hub/main/" .. path
    local success, result = pcall(function()
        local script = game:HttpGet(url, true)
        return loadstring(script)
    end)
    
    if success and result then
        return result
    else
        warn("Failed to load module:", path)
        return nil
    end
end

-- Create Main Hub Window
local Window = Rayfield:CreateWindow({
    Name = "Universal ESP Hub",
    LoadingTitle = "Loading Hub...",
    LoadingSubtitle = "Detecting Game: " .. GameName,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "UniversalESPHub",
        FileName = "Config"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

-- Home Tab
local HomeTab = Window:CreateTab("🏠 Home")

-- Current Game Info
HomeTab:CreateSection("Current Game")
HomeTab:CreateLabel("Game: " .. GameName)
HomeTab:CreateLabel("Place ID: " .. PlaceId)

-- Check if game is supported
local CurrentGame = SupportedGames[PlaceId]

if CurrentGame then
    HomeTab:CreateLabel("✅ Status: SUPPORTED")
    
    local GameCard = HomeTab:CreateParagraph({
        Title = CurrentGame.Name,
        Content = CurrentGame.Description
    })
    
    -- Launch Game Button
    HomeTab:CreateButton({
        Name = "🚀 Launch " .. CurrentGame.Name .. " Script",
        Callback = function()
            Rayfield:Notify({
                Title = "Loading...",
                Content = "Loading " .. CurrentGame.Name .. " features",
                Duration = 3
            })
            
            local gameModule = loadModule(CurrentGame.Loader)
            if gameModule then
                gameModule(Window, Rayfield)
            else
                Rayfield:Notify({
                    Title = "Error",
                    Content = "Failed to load game script",
                    Duration = 3
                })
            end
        end
    })
else
    HomeTab:CreateLabel("❌ Status: NOT SUPPORTED")
    
    local UnsupportedCard = HomeTab:CreateParagraph({
        Title = "Game Not Supported",
        Content = GameName .. " is not in our supported games list.\n\nYou can use the universal features below."
    })
end

-- Universal Features Section (Always available)
HomeTab:CreateSection("Universal Features")

HomeTab:CreateButton({
    Name = "👁️ Load ESP System",
    Callback = function()
        local espModule = loadModule("Universal/ESP.lua")
        if espModule then
            espModule(Window, Rayfield)
        end
    end
})

HomeTab:CreateButton({
    Name = "🔍 Load Remote Finder",
    Callback = function()
        local remoteModule = loadModule("Universal/RemoteFinder.lua")
        if remoteModule then
            remoteModule(Window, Rayfield)
        end
    end
})

HomeTab:CreateButton({
    Name = "⚡ Load Speed Hack",
    Callback = function()
        local speedModule = loadModule("Universal/Speed.lua")
        if speedModule then
            speedModule(Window, Rayfield)
        end
    end
})

-- Supported Games Tab
local GamesTab = Window:CreateTab("🎮 Supported Games")

GamesTab:CreateSection("Available Games")

-- Create a button for each supported game
for placeId, gameInfo in pairs(SupportedGames) do
    GamesTab:CreateButton({
        Name = gameInfo.Name,
        Callback = function()
            if PlaceId == placeId then
                -- Load the correct game script
                local gameModule = loadModule(gameInfo.Loader)
                if gameModule then
                    gameModule(Window, Rayfield)
                end
            else
                Rayfield:Notify({
                    Title = "Wrong Game",
                    Content = "This script is for " .. gameInfo.Name .. "\nYou are in: " .. GameName,
                    Duration = 5
                })
            end
        end
    })
    
    GamesTab:CreateLabel("Place ID: " .. placeId)
    GamesTab:CreateDivider()
end

-- Settings Tab
local SettingsTab = Window:CreateTab("⚙️ Settings")

SettingsTab:CreateSection("Hub Settings")

SettingsTab:CreateButton({
    Name = "Unload Hub",
    Callback = function()
        Rayfield:Destroy()
    end
})

-- Initial notification
Rayfield:Notify({
    Title = "Universal ESP Hub Loaded",
    Content = "Game: " .. GameName .. "\nPlace ID: " .. PlaceId,
    Duration = 5
})
