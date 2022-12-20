--\\ Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

--// Modules

local src = ReplicatedStorage:WaitForChild("src")
local Data = src:WaitForChild("Data")
local Loader = require(src:WaitForChild("Loader"));
local EndpointsClient = Loader.load_client_service(script, "EndpointsClient");

--//Remotes
local ClientToServer = ReplicatedStorage:WaitForChild("endpoints"):WaitForChild("client_to_server")
local UnitsPlaced = 0

local Player = Players.LocalPlayer
local Units = game:GetService("Workspace")["_UNITS"]
local LatestUnitAdded

local Log = {

}

Units.ChildAdded:Connect(function(Unit)
    local stats = Unit:WaitForChild("_stats") 
    if not stats then return end
    
    if stats:FindFirstChild("player") then
        local playerval = stats:FindFirstChild("player").Value
        if playerval == Player then
            if stats:FindFirstChild("parent_unit") and stats:FindFirstChild("parent_unit").Value then return end
            UnitsPlaced += 1
            LatestUnitAdded = Unit
            Unit:SetAttribute("UnitNum", UnitsPlaced)
        end
    end
end)

local remoteFunctions = {
    ["cycle_priority"] = function(...)
        local args = {...}
        local unit = args[1]
        local unitnum = unit:GetAttribute("UnitNum")
        
        table.insert(Log, {
            ["UnitNum"] = unitnum,
            ["Method"] = "cycle_priority",
        }) 
    end,

    ["upgrade_unit_ingame"] = function(...)
        local args = {...}
        local unit = args[1]
        local unitnum = unit:GetAttribute("UnitNum")
        
        print(unit.Name, unitnum)

        table.insert(Log, {
            ["UnitNum"] = unitnum,
            ["Method"] = "upgrade_unit_ingame",
        })
    end,

    ["spawn_unit"] = function(...)
        local args = {...}
        local unitUUID = args[1]
        local placement = args[2]

        task.spawn(function()
            local currenttime = os.time()
            local waittime = 1.5

            repeat
                if os.time() - currenttime >= waittime then return end
                task.wait()
            until LatestUnitAdded
    
            table.insert(Log, {
                ["Unit"] = unitUUID,
                ["UnitNum"] = UnitsPlaced,
                ["Method"] = "spawn_unit",
                ["args"] = {
                    ["uuid"] = unitUUID,
                    X = placement.X,
                    Y = placement.Y,
                    Z = placement.Z
                }
            })
            
            print(LatestUnitAdded)
            
            LatestUnitAdded = nil
        end)
    end,

    ["sell_unit_ingame"] = function(...)
        local args = {...}
        local unit = args[1]
        local unitnum = unit:GetAttribute("UnitNum")
        
        table.insert(Log, {
            ["UnitNum"] = unitnum,
            ["Method"] = "sell_unit_ingame",
        })
    end
}

local upgradefun = game:GetService("ReplicatedStorage").endpoints["client_to_server"]["upgrade_unit_ingame"]

hookfunction(upgradefun.InvokeServer, function(...)
    return upgradefun:InvokeServer(...)
end)

a = hookmetamethod(game, "__namecall", function(self, ...) 
    local args = {...}
    local namemethod = getnamecallmethod()
    
    if namemethod:lower() == "invokeserver" then
        print(self.Name)

        if remoteFunctions[self.Name] then
            remoteFunctions[self.Name](...)
        end
    end
    
    return a(self, ...)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end

    if input.KeyCode == Enum.KeyCode.L then
        writefile("AnimeAdventureFarmLog.lua", HttpService:JSONEncode(Log))
    end
end)

