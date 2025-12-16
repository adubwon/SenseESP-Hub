-- Remote Finder Module

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

return function(Window)
    local Rayfield = Window
    
    local RemoteTab = Window:CreateTab("Remote Finder", 4483362458)
    RemoteTab:CreateSection("Remote Path Finder")
    
    local FoundRemotes = {}
    
    -- Search function
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
    
    -- Status label
    local StatusLabel = RemoteTab:CreateLabel("Status: Ready")
    local CountLabel = RemoteTab:CreateLabel("Found: 0 remotes")
    
    -- Search Button
    RemoteTab:CreateButton({
        Name = "🔍 Search All Remotes",
        Callback = function()
            StatusLabel:Set("Status: Searching...")
            FoundRemotes = {}
            
            -- Search ReplicatedStorage
            local repStorageRemotes = findAllRemotes(ReplicatedStorage, {})
            local repFirstRemotes = findAllRemotes(ReplicatedFirst, {})
            
            -- Combine
            for _, remote in ipairs(repStorageRemotes) do
                table.insert(FoundRemotes, remote)
            end
            for _, remote in ipairs(repFirstRemotes) do
                table.insert(FoundRemotes, remote)
            end
            
            CountLabel:Set("Found: " .. #FoundRemotes .. " remotes")
            StatusLabel:Set("Status: Found " .. #FoundRemotes .. " remotes")
            
            Rayfield:Notify({
                Title = "Remote Search Complete",
                Content = "Found " .. #FoundRemotes .. " remotes",
                Duration = 3
            })
        end
    })
    
    -- Copy ALL Paths Button
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
            
            -- Create copy text with ALL paths
            local copyText = "-- REMOTE PATHS --\n\n"
            for _, remote in ipairs(FoundRemotes) do
                copyText = copyText .. remote.Path .. "\n"
            end
            copyText = copyText .. "\n-- Total: " .. #FoundRemotes .. " remotes --"
            
            -- Copy to clipboard
            if setclipboard then
                setclipboard(copyText)
            elseif writeclipboard then
                writeclipboard(copyText)
            elseif syn and syn.write_clipboard then
                syn.write_clipboard(copyText)
            end
            
            Rayfield:Notify({
                Title = "Copied!",
                Content = "Copied " .. #FoundRemotes .. " remote paths to clipboard",
                Duration = 3
            })
        end
    })
    
    -- Display Results
    local ResultDisplay = RemoteTab:CreateParagraph({
        Title = "Remote Paths",
        Content = "Click 'Search All Remotes' to find remotes"
    })
    
    RemoteTab:CreateButton({
        Name = "📄 Display Results",
        Callback = function()
            if #FoundRemotes == 0 then
                ResultDisplay:Set({
                    Title = "Remote Paths",
                    Content = "No remotes found. Search first!"
                })
                return
            end
            
            local displayText = ""
            for i, remote in ipairs(FoundRemotes) do
                displayText = displayText .. i .. ". " .. remote.Path .. " [" .. remote.Class .. "]\n"
                if i >= 15 then
                    displayText = displayText .. "... and " .. (#FoundRemotes - 15) .. " more"
                    break
                end
            end
            
            ResultDisplay:Set({
                Title = "Remote Paths (" .. #FoundRemotes .. " found)",
                Content = displayText
            })
        end
    })
    
    -- Copy Specific Type
    RemoteTab:CreateDropdown({
        Name = "Copy Specific Type",
        Options = {"All", "RemoteEvents", "RemoteFunctions", "BindableEvents"},
        CurrentOption = "All",
        Callback = function(Option)
            if #FoundRemotes == 0 then return end
            
            local filtered = {}
            for _, remote in ipairs(FoundRemotes) do
                if Option == "All" or 
                   (Option == "RemoteEvents" and remote.Class == "RemoteEvent") or
                   (Option == "RemoteFunctions" and remote.Class == "RemoteFunction") or
                   (Option == "BindableEvents" and remote.Class == "BindableEvent") then
                    table.insert(filtered, remote)
                end
            end
            
            if #filtered > 0 then
                local copyText = "-- " .. Option .. " PATHS --\n\n"
                for _, remote in ipairs(filtered) do
                    copyText = copyText .. remote.Path .. "\n"
                end
                copyText = copyText .. "\n-- Total: " .. #filtered .. " " .. Option .. " --"
                
                if setclipboard then
                    setclipboard(copyText)
                end
                
                Rayfield:Notify({
                    Title = "Copied",
                    Content = "Copied " .. #filtered .. " " .. Option,
                    Duration = 3
                })
            end
        end
    })
    
    -- Clear Button
    RemoteTab:CreateButton({
        Name = "🗑️ Clear Results",
        Callback = function()
            FoundRemotes = {}
            CountLabel:Set("Found: 0 remotes")
            StatusLabel:Set("Status: Cleared")
            ResultDisplay:Set({
                Title = "Remote Paths",
                Content = "Results cleared"
            })
        end
    })
end
