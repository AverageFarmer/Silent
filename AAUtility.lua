local src = game.ReplicatedStorage:WaitForChild("src")
local Data = src:WaitForChild("Data")
local UnitsInfo = require(Data.Units)
local Units = workspace["_UNITS"]

for i,v in pairs(Units:GetChildren()) do
    if v:FindFirstChild("_hitbox") then
        v:FindFirstChild("_hitbox"):Destroy()
    end
end

Units.ChildAdded:Connect(function(Unit)
    task.wait(1)

    if Unit:FindFirstChild("_hitbox") then
        Unit:FindFirstChild("_hitbox"):Destroy()
    end
end)


for i, Info in pairs(UnitsInfo) do
    Info.hill_unit = false
    Info.hybrid_placement = true
end

game:GetService("ReplicatedStorage")["_bounds"]:ClearAllChildren()