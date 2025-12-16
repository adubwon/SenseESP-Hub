-- Remote Finder Module

return function(Window, Rayfield)
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local ReplicatedFirst = game:GetService("ReplicatedFirst")
    
    local RemoteTab = Window:CreateTab("🔍 Remote Finder")
    
    RemoteTab:CreateSection("Remote Discovery")
    
    local FoundRemotes = {}
    
    -- Recursive search function
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
    
    -- Search Button
    RemoteTab:CreateButton({
        Name = "🔍 Search All Remotes",
        Callback = function()
            StatusLabel:Set("Status: Searching...")
            FoundRemotes = {}
            
            -- Search ReplicatedStorage
            local repStorageRemotes = findAllRemotes(ReplicatedStorage, {})
            
            -- Search ReplicatedFirst
            local repFirstRemotes = findAllRemotes(ReplicatedFirst, {})
            
            -- Combine results
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
    
    -- Copy ALL Paths Button
    RemoteTab:CreateButton({
        Name = "📋 Copy ALL Remote Paths",
        Callback = function()
            if #FoundRemotes == 0 then
                Rayfield:Notify({
                    Title = "Error",
                    Content = "Search for remotes first!",
                    Duration = 3
                })
                return
            end
            
            -- Create the text to copy
            local copyText = "-- REMOTE PATHS --\n\n"
            
            for i, remote in ipairs(FoundRemotes) do
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
            else
                Rayfield:Notify({
                    Title = "Error",
                    Content = "Clipboard not available",
                    Duration = 3
                })
                return
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
                if i >= 20 then
                    displayText = displayText .. "... and " .. (#FoundRemotes - 20) .. " more"
                    break
                end
            end
            
            ResultDisplay:Set({
                Title = "Remote Paths (" .. #FoundRemotes .. " found)",
                Content = displayText
            })
        end
    })
    
    -- Filter by Type
    RemoteTab:CreateDropdown({
        Name = "Filter Remotes",
        Options = {"All", "RemoteEvents", "RemoteFunctions", "BindableEvents"},
        CurrentOption = "All",
        Callback = function(Option)
            if #FoundRemotes == 0 then return end
            
            local displayText = "Filtered: " .. Option .. "\n\n"
            local count = 0
            
            for i, remote in ipairs(FoundRemotes) do
                if Option == "All" or 
                   (Option == "RemoteEvents" and remote.Class == "RemoteEvent") or
                   (Option == "RemoteFunctions" and remote.Class == "RemoteFunction") or
                   (Option == "BindableEvents" and remote.Class == "BindableEvent") then
                    
                    displayText = displayText .. i .. ". " .. remote.Path .. "\n"
                    count = count + 1
                    
                    if count >= 15 then
                        displayText = displayText .. "... and " .. (#FoundRemotes - 15) .. " more"
                        break
                    end
                end
            end
            
            ResultDisplay:Set({
                Title = "Filtered: " .. Option .. " (" .. count .. " found)",
                Content = displayText
            })
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
            
            Rayfield:Notify({
                Title = "Cleared",
                Content = "Remote results cleared",
                Duration = 2
            })
        end
    })
    
    Rayfield:Notify({
        Title = "Remote Finder Loaded",
        Content = "Ready to find remotes",
        Duration = 3
    })
    
    return {
        Search = function()
            -- Trigger search
            FoundRemotes = {}
            local repStorageRemotes = findAllRemotes(ReplicatedStorage, {})
            local repFirstRemotes = findAllRemotes(ReplicatedFirst, {})
            
            for _, remote in ipairs(repStorageRemotes) do
                table.insert(FoundRemotes, remote)
            end
            for _, remote in ipairs(repFirstRemotes) do
                table.insert(FoundRemotes, remote)
            end
            
            return FoundRemotes
        end
    }
end
