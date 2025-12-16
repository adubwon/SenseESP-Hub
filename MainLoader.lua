-- Universal Hub - Main Loader
-- GitHub: https://github.com/yourusername/SenseESP-Hub
-- Pastebin: https://pastebin.com/raw/YourPastebinID

local function loadModule(url)
    local success, module = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    return success and module or nil
end

local PlaceId = game.PlaceId
local GameModules = {
    [101953168527257] = "https://raw.githubusercontent.com/yourusername/SenseESP-Hub/main/Games/101953168527257.lua",
    -- Add more games here
}

-- Load RayField UI first
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create main window
local Window = Rayfield:CreateWindow({
    Name = "Sense ESP Universal Hub",
    LoadingTitle = "Loading Hub...",
    LoadingSubtitle = "Detecting Game",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "SenseESPHub",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false
})

-- Game detection
local CurrentGameModule = GameModules[PlaceId]

if CurrentGameModule then
    Rayfield:Notify({
        Title = "Game Detected",
        Content = "Loading Spear Fishing scripts...",
        Duration = 3,
        Image = 4483362458
    })
    
    -- Load game-specific module
    loadModule(CurrentGameModule)(Window)
else
    local HomeTab = Window:CreateTab("Home", 4483362458)
    HomeTab:CreateSection("Universal Features")
    
    -- Load universal modules
    local ESP = loadModule("https://raw.githubusercontent.com/yourusername/SenseESP-Hub/main/Modules/ESP.lua")
    local RemoteFinder = loadModule("https://raw.githubusercontent.com/yourusername/SenseESP-Hub/main/Modules/RemoteFinder.lua")
    
    if ESP then ESP(Window) end
    if RemoteFinder then RemoteFinder(Window) end
    
    HomeTab:CreateLabel("This game is not specifically supported")
    HomeTab:CreateLabel("Universal features loaded")
end

-- Settings Tab
local SettingsTab = Window:CreateTab("Settings", 4483362458)
SettingsTab:CreateButton({
    Name = "Unload UI",
    Callback = function()
        Rayfield:Destroy()
    end
})

Rayfield:Notify({
    Title = "Sense ESP Hub Loaded",
    Content = "Game ID: " .. PlaceId,
    Duration = 5,
    Image = 4483362458
})
