local Units = workspace._UNITS
local UnitStorage = {}

for i,v in pairs(Units:GetChildren()) do
    if v.Name == "kisuke_evolved" then
        print(v.Name)
        table.insert(UnitStorage, v)
    end
end

repeat
    for i,v in pairs(UnitStorage) do
        if v:FindFirstChild("_stats") then
            if v:FindFirstChild("_stats"):FindFirstChild("player") and v:FindFirstChild("_stats"):FindFirstChild("player").Value == game.Players.LocalPlayer then
                task.spawn(function()
                    game:GetService("ReplicatedStorage").endpoints.client_to_server.use_active_attack:InvokeServer(v)
                end)
                task.wait(30.1)
            end
        end
    end
    task.wait(30)
until false