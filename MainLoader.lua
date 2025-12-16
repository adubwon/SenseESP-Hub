-- Universal Sense ESP Hub
-- GitHub: https://github.com/yourusername/SenseESP-Hub

-- Load RayField UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Get current game info
local PlaceId = game.PlaceId
local GameName = game:GetService("MarketplaceService"):GetProductInfo(PlaceId).Name

-- Supported Games Database
local SupportedGames = {
    [101953168527257] = {
        Name = "Spear Fishing Simulator",
        Description = "Fishing game with ocean exploration",
        Thumbnail = "https://tr.rbxcdn.com/ed1d05a62c32667d0cd15da22eea501f/420/420/Image/Png",
        Loader = "Games/SpearFishing.lua",
        Verified = true
    },
    [2753915549] = {
        Name = "Blox Fruits",
        Description = "Anime fighting game with fruits",
        Thumbnail = "https://tr.rbxcdn.com/9e2b9e0b6c4b8a9b6d4f8c4e4b8f4c4e/420/420/Image/Png",
        Loader = "Games/BloxFruits.lua",
        Verified = true
    },
    [286090429] = {
        Name = "Arsenal",
        Description = "FPS shooter game",
        Thumbnail = "https://tr.rbxcdn.com/4d4e4f4c4a4b4c4d4e4f4a4b4c4d4e4f/420/420/Image/Png",
        Loader = "Games/Arsenal.lua",
        Verified = true
    },
    [142823291] = {
        Name = "Murder Mystery 2",
        Description = "Murder mystery game",
        Thumbnail = "https://tr.rbxcdn.com/1d1e1f1a1b1c1d1e1f1a1b1c1d1e1f/420/420/Image/Png",
        Loader = "Games/MurderMystery2.lua",
        Verified = true
    }
}

-- Function to load modules from GitHub
local function loadGitHubModule(path)
    local url = "https://raw.githubusercontent.com/yourusername/SenseESP-Hub/main/" .. path
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url, true))()
    end)
    return success and result or nil
end

-- Create Main Hub Window
local Window = Rayfield:CreateWindow({
    Name = "Sense ESP Universal Hub",
    LoadingTitle = "Initializing Hub...",
    LoadingSubtitle = "Checking Game Support",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "SenseESPHub",
        FileName = "HubConfig"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false
})

-- Home Tab (Game Selection)
local HomeTab = Window:CreateTab("🏠 Home", 4483362458)

-- Current Game Info Section
HomeTab:CreateSection("Current Game")

HomeTab:CreateLabel("Game: " .. GameName)
HomeTab:CreateLabel("Place ID: " .. PlaceId)

-- Check if current game is supported
local CurrentGame = SupportedGames[PlaceId]

if CurrentGame then
    HomeTab:CreateLabel("✅ Status: SUPPORTED")
    
    -- Game Card
    local GameCard = HomeTab:CreateParagraph({
        Title = CurrentGame.Name,
        Content = CurrentGame.Description .. "\n\nClick 'Launch Game Script' below to load all features!"
    })
    
    -- Launch Button
    HomeTab:CreateButton({
        Name = "🚀 Launch Game Script",
        Callback = function()
            Rayfield:Notify({
                Title = "Loading Game Script",
                Content = "Loading " .. CurrentGame.Name .. " features...",
                Duration = 3
            })
            
            -- Load the game-specific script
            loadGitHubModule(CurrentGame.Loader)(Window, Rayfield)
        end
    })
    
    -- Load Universal Features first
    HomeTab:CreateButton({
        Name = "📦 Load Universal Features",
        Callback = function()
            -- Load Universal ESP
            local ESPModule = loadGitHubModule("Universal/ESP.lua")
            if ESPModule then
                ESPModule(Window, Rayfield)
                Rayfield:Notify({
                    Title = "ESP Loaded",
                    Content = "Universal ESP features added",
                    Duration = 3
                })
            end
            
            -- Load Remote Finder
            local RemoteFinderModule = loadGitHubModule("Universal/RemoteFinder.lua")
            if RemoteFinderModule then
                RemoteFinderModule(Window, Rayfield)
                Rayfield:Notify({
                    Title = "Remote Finder Loaded",
                    Content = "Remote finding features added",
                    Duration = 3
                })
            end
        end
    })
    
else
    HomeTab:CreateLabel("❌ Status: NOT SUPPORTED")
    
    -- Game not supported message
    local UnsupportedCard = HomeTab:CreateParagraph({
        Title = "Game Not Supported",
        Content = "This game (" .. GameName .. ") is not in our supported list.\n\nYou can still use universal features below, or request support on our Discord."
    })
    
    -- Universal Features for unsupported games
    HomeTab:CreateSection("Universal Features")
    
    HomeTab:CreateButton({
        Name = "👁️ Load Universal ESP",
        Callback = function()
            local ESPModule = loadGitHubModule("Universal/ESP.lua")
            if ESPModule then
                ESPModule(Window, Rayfield)
                Rayfield:Notify({
                    Title = "Universal ESP Loaded",
                    Content = "Basic ESP features enabled",
                    Duration = 3
                })
            end
        end
    })
    
    HomeTab:CreateButton({
        Name = "🔍 Load Remote Finder",
        Callback = function()
            local RemoteFinderModule = loadGitHubModule("Universal/RemoteFinder.lua")
            if RemoteFinderModule then
                RemoteFinderModule(Window, Rayfield)
                Rayfield:Notify({
                    Title = "Remote Finder Loaded",
                    Content = "Remote finding features enabled",
                    Duration = 3
                })
            end
        end
    })
end

-- Supported Games List Tab
local GamesTab = Window:CreateTab("🎮 Supported Games", 4483362458)

GamesTab:CreateSection("Game Library")

-- Create game cards for all supported games
for placeId, gameInfo in pairs(SupportedGames) do
    local GameSection = GamesTab:CreateSection(gameInfo.Name)
    
    GamesTab:CreateParagraph({
        Title = gameInfo.Name,
        Content = gameInfo.Description .. "\n\nPlace ID: " .. placeId
    })
    
    GamesTab:CreateLabel("Status: " .. (gameInfo.Verified and "✅ Verified" or "⚠️ Experimental"))
    
    -- Launch button for each game
    GamesTab:CreateButton({
        Name = "Launch " .. gameInfo.Name,
        Callback = function()
            if PlaceId == placeId then
                -- Load game-specific script
                loadGitHubModule(gameInfo.Loader)(Window, Rayfield)
                Rayfield:Notify({
                    Title = "Loading Game",
                    Content = "Loading " .. gameInfo.Name .. " features...",
                    Duration = 3
                })
            else
                Rayfield:Notify({
                    Title = "Game Mismatch",
                    Content = "This script is for " .. gameInfo.Name .. "\nCurrent game: " .. GameName,
                    Duration = 5
                })
            end
        end
    })
    
    GamesTab:CreateDivider()
end

-- Universal Features Tab
local UniversalTab = Window:CreateTab("⚙️ Universal Features", 4483362458)

UniversalTab:CreateSection("Core Features")

UniversalTab:CreateButton({
    Name = "👁️ ESP System",
    Callback = function()
        local ESPModule = loadGitHubModule("Universal/ESP.lua")
        if ESPModule then
            ESPModule(Window, Rayfield)
        end
    end
})

UniversalTab:CreateButton({
    Name = "🔍 Remote Finder",
    Callback = function()
        local RemoteFinderModule = loadGitHubModule("Universal/RemoteFinder.lua")
        if RemoteFinderModule then
            RemoteFinderModule(Window, Rayfield)
        end
    end
})

UniversalTab:CreateButton({
    Name = "⚡ Speed Hack",
    Callback = function()
        local SpeedModule = loadGitHubModule("Universal/Speed.lua")
        if SpeedModule then
            SpeedModule(Window, Rayfield)
        end
    end
})

UniversalTab:CreateButton({
    Name = "🎯 Aim Assist",
    Callback = function()
        local AimModule = loadGitHubModule("Universal/Aim.lua")
        if AimModule then
            AimModule(Window, Rayfield)
        end
    end
})

-- Settings Tab
local SettingsTab = Window:CreateTab("⚙️ Settings", 4483362458)

SettingsTab:CreateSection("Hub Settings")

SettingsTab:CreateButton({
    Name = "🔄 Refresh Game List",
    Callback = function()
        Rayfield:Notify({
            Title = "Refreshing",
            Content = "Checking for game updates...",
            Duration = 3
        })
    end
})

SettingsTab:CreateButton({
    Name = "📊 Hub Statistics",
    Callback = function()
        local supportedCount = 0
        for _ in pairs(SupportedGames) do
            supportedCount = supportedCount + 1
        end
        
        Rayfield:Notify({
            Title = "Hub Statistics",
            Content = "Supported Games: " .. supportedCount .. "\nCurrent Game: " .. GameName,
            Duration = 5
        })
    end
})

SettingsTab:CreateButton({
    Name = "🚫 Unload Hub",
    Callback = function()
        Rayfield:Destroy()
        Rayfield:Notify({
            Title = "Hub Unloaded",
            Content = "Sense ESP Hub has been closed",
            Duration = 3
        })
    end
})

-- Initial notification
Rayfield:Notify({
    Title = "Sense ESP Hub Loaded",
    Content = "Welcome to the Universal Hub!\nGame: " .. GameName .. "\nPlace ID: " .. PlaceId,
    Duration = 6,
    Image = 4483362458
})
