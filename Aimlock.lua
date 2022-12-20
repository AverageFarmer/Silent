local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game.Players

local LocalPlayer = game.Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

local Filter = workspace:FindFirstChild("Filter")
local Debris = workspace:FindFirstChild("Debris")

local R6 = {
    "Head",
	"Torso",
	"Left Arm",
	"Right Arm",
	"Left Leg",
	"Right Leg",
}

-- Vars
local ValidTargets = {}
local Settings = getgenv().Settings

local AimbotLoop = RunService:BindToRenderStep("updateAimbot", 1, function()
    ValidTargets = {}
    local Type = Settings.Type
    local Index = 3

    if Type == "Closest" then
        Index = 4
    elseif Type == "Mouse" then
        Index = 3
    end

    if not (Settings.AimLock) then return end

    local SelfCharacter = LocalPlayer.Character
    local SelfRootPart, SelfHumanoid = SelfCharacter and SelfCharacter:FindFirstChild("HumanoidRootPart"), SelfCharacter and SelfCharacter:FindFirstChildOfClass("Humanoid")
    if not SelfCharacter or not SelfRootPart or not SelfHumanoid then return end

    local Params                      = RaycastParams.new()
    Params.FilterType                 = Enum.RaycastFilterType.Blacklist
    Params.IgnoreWater                = true
    Params.FilterDescendantsInstances = {Camera, SelfCharacter, Filter, Debris}

    local Closest      = 999999

    local CameraPosition = Camera.CFrame.Position
    local MousePosition  = Vector2.new(Mouse.X, Mouse.Y)

    for _,Player in pairs (Players:GetPlayers()) do
        local Character = Player.Character
        local RootPart, Humanoid = Character and Character:FindFirstChild("HumanoidRootPart"), Character and Character:FindFirstChildOfClass("Humanoid")
        if not Character or not RootPart or not Humanoid then continue end
        if Player == LocalPlayer then continue end
        if Settings.Teams and (Player.Team == LocalPlayer.Team) then continue end
        if Settings.Blacklist then
            if LocalPlayer:IsFriendsWith(Player.UserId) then continue end
        end

        local Head = Character:FindFirstChild("Head")
        if not Head then continue end

        local DistanceFromCharacter = (Camera.CFrame.Position - RootPart.Position).Magnitude

        local Pos, OnScreen = Camera:WorldToViewportPoint(RootPart.Position)
        if not OnScreen then continue end
        local Magnitude = (Vector2.new(Pos.X, Pos.Y) - MousePosition).Magnitude
        if not (Magnitude < Settings.FOV) then continue end

        local Hitbox 
        if Settings.RandomSelect then
            local RandomPart = R6[math.random(1, #R6)]     
            Hitbox = Character:FindFirstChild(RandomPart)
        else
            Hitbox = Character:FindFirstChild(Settings.SelectedPart)
        end

        if not Hitbox then continue end
        table.insert(ValidTargets, {Player, Hitbox, Magnitude, DistanceFromCharacter, Humanoid.Health})
    end
    table.sort(ValidTargets, function(a, b) return a[Index] < b[Index] end)
end)

local OldNamecall; OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = tostring(getnamecallmethod())

    if (method == "Raycast") and (Settings.AimLock) then
        if math.random(1,100) <= Settings.HitChance then
            local Character = LocalPlayer.Character
            local Root = Character.HumanoidRootPart
            if table.find(args[3].FilterDescendantsInstances, LocalPlayer.Character) ~= 1 and table.find(args[3].FilterDescendantsInstances, Camera) ~= 2 and table.find(args[3].FilterDescendantsInstances, LocalPlayer.Character) ~= nil then
                if #ValidTargets ~= 0 then
                    local Target = ValidTargets[1]
                    local Hitbox = Target[2]
                    args[2] = (Hitbox.Position - (Root.CFrame * CFrame.new(0, Root.Size.Y/2, -1.3)).Position ).Unit * (Hitbox.Position - Camera.CFrame.Position).Magnitude
                end
            end
        end
    end

    return OldNamecall(self, unpack(args))
end)