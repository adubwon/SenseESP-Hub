-- Universal Remote Finder
-- Works in any game

return function(Window, Rayfield)
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local ReplicatedFirst = game:GetService("ReplicatedFirst")
    
    local RemoteTab = Window:CreateTab("🔍 Remote Finder", 4483362458)
    RemoteTab:CreateSection("Remote Discovery")
    
    local FoundRemotes = {}
    
    local function findAllRemotes(instance, results)
        if not instance then return results end
        
        if instance:IsA("RemoteFunction") or instance:IsA("RemoteEvent") or 
           instance:IsA("BindableEvent") or instance:IsA("BindableFunction") then
            table.insert(results, {
                Instance = instance,
                Path = instance:GetFullName(),
                Class = instance.ClassName
            })
        end
        
        for _, child in ipairs(instance:GetChildren()) do
            findAllRemotes(child, results)
        end
        
        return results
    end
    
    local StatusLabel = RemoteTab:CreateLabel("Status: Ready")
    local CountLabel = RemoteTab:CreateLabel("Found: 0 remotes")
    
    RemoteTab:CreateButton({
        Name = "🔍 Search All Remotes",
        Callback = function()
            StatusLabel:Set("Status: Searching...")
            FoundRemotes = {}
            
            local repStorageRemotes = findAllRemotes(ReplicatedStorage, {})
            local repFirstRemotes = findAllRemotes(ReplicatedFirst, {})
            
            for _, remote in ipairs(repStorageRemotes) do
                table.insert(FoundRemotes, remote)
            end
            for _, remote in ipairs(repFirstRemotes) do
                table.insert(FoundRemotes, remote)
            end
            
            CountLabel:Set("Found: " .. #FoundRemotes .. " remotes")
            StatusLabel:Set("Status: Found " .. #FoundRemotes .. " remotes")
            
            Rayfield:Notify({
                Title = "Search Complete",
                Content = "Found " .. #FoundRemotes .. " remotes",
                Duration = 3
            })
        end
    })
    
    RemoteTab:CreateButton({
        Name = "📋 Copy ALL Paths",
        Callback = function()
            if #FoundRemotes == 0 then
                Rayfield:Notify({
                    Title = "Error",
                    Content = "Search for remotes first!",
                    Duration = 3
                })
                return
            end
            
            local copyText = "-- REMOTE PATHS --\n\n"
            for _, remote in ipairs(FoundRemotes) do
                copyText = copyText .. remote.Path .. "\n"
            end
            copyText = copyText .. "\n-- Total: " .. #FoundRemotes .. " remotes --"
            
            if setclipboard then
                setclipboard(copyText)
                Rayfield:Notify({
                    Title = "Copied!",
                    Content = "Copied " .. #FoundRemotes .. " paths to clipboard",
                    Duration = 3
                })
            end
        end
    })
    
    RemoteTab:CreateButton({
        Name = "🗑️ Clear Results",
        Callback = function()
            FoundRemotes = {}
            CountLabel:Set("Found: 0 remotes")
            StatusLabel:Set("Status: Cleared")
            Rayfield:Notify({
                Title = "Cleared",
                Content = "Remote results cleared",
                Duration = 2
            })
        end
    })
    
    Rayfield:Notify({
        Title = "Remote Finder Loaded",
        Content = "Remote discovery ready",
        Duration = 3
    })
end
