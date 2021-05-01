local Players = game:GetService("Players")
local UserInput = game:GetService("UserInputService")
local HTTP = game:GetService("HttpService")
local RunServ = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
PlayerGui:SetTopbarTransparency(1)
local Mouse = LocalPlayer:GetMouse()
local PickUpRemote = game:GetService("ReplicatedStorage")["Events"]["PIC_PU"]
local PickUpCash = game:GetService("ReplicatedStorage")["Events"]["CZDPZUS"]

local CashFolder = game:GetService("Workspace").Filter.SpawnedBread
local ScarpSpawn = game:GetService("Workspace")["Filter"]["SpawnedPiles"]
local Dealers = game:GetService("Workspace")["Map"]["Shopz"]
local Safes = game:GetService("Workspace")["Map"]["BredMakurz"]

getgenv().methodsTable = {"Ray", "Raycast", "FindPartOnRay", "FindPartOnRayWithIgnoreList", "FindPartOnRayWithWhitelist"}
getgenv().Rainbow = Color3.new(0.952941, 0.921568, 0.921568)
getgenv().SelectedPart = "Head"
getgenv().VisibiltyCheck = false
getgenv().FOV = 250
getgenv().CircleVisibility = true
getgenv().Distance = 400
getgenv().CanPickUp = false
getgenv().SafeEsp = false
getgenv().DealerEsp = false

local rigType = string.split(tostring(LocalPlayer.Character:WaitForChild("Humanoid").RigType), ".")[3]
local selected_rigType

local rigTypeR6 = {
    "Head",
	"Torso",
	"LowerTorso",
	"Left Arm",
	"Right Arm",
	"Left Leg",
	"Right Leg",
}

local rigTypeR15 = {
    "Head",
    "UpperTorso",
    "LowerTorso",
    "LeftUpperArm",
    "RightUpperArm",
    "RightLowerArm",
    "LeftLowerArm",
    "LeftHand",
    "RightHand",
    "LeftUpperLeg",
    "RightUpperLeg",
    "LeftLowerLeg",
    "RightLowerLeg",
    "LeftFoot",
    "RightFoot",
}
local SafeHolder = {}
local DealerHolder = {}
local SafeOnColor = Color3.fromRGB(34, 226, 16)
local SafeOffColor = Color3.fromRGB(93, 93, 93)
local CanPickUp = false

if rigType == "R6" then
    selected_rigType = rigTypeR6
elseif rigType == "R15" then
    selected_rigType = rigTypeR15
end

local library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/AikaV3rm/UiLib/master/Lib.lua')))()
_G.MainColor = Color3.new()
_G.SecondaryColor = Color3.new(0.098039, 0.533333, 0.098039)
_G.TertiaryColor = Color3.new(0.101960, 0.101960, 0.101960)
_G.ArrowColor = Color3.new(0.690196, 0.925490, 0.690196)

local SilentAim = library:CreateWindow("Silent Aim") -- Creates the window
local Esps = library:CreateWindow("Esps")
local Misc = library:CreateWindow("Misc")

local Aim = SilentAim:CreateFolder("Silent Aim") -- Creates the folder(U will put here your buttons,etc)

local SafeEsp = Esps:CreateFolder("SafeEsp")
local DealerEsp = Esps:CreateFolder("DealerEsp")

local MiscOptions = Misc:CreateFolder("Options")

--Aim:Toggle("Enable",function(bool)
--    getgenv().AimToggle = bool
--end)

Aim:Toggle("Visible", function(bool)
    getgenv().CircleVisibility = bool
end)

Aim:Slider("FOV",{
    min = 5; -- min value of the slider
    max = 250; -- max value of the slider
    precise = false; -- max 2 decimals
},function(value)
    getgenv().FOV = value
end)

Aim:Label("Targeted Part",{
    TextSize = 16; -- Self Explaining
    TextColor = Color3.fromRGB(0, 0, 0); -- Self Explaining
    BgColor = Color3.fromRGB(97, 233, 43); -- Self Explaining 
})

Aim:Dropdown("Head", selected_rigType, true, function(Part) --true/false, replaces the current title "Dropdown" with the option that t
    getgenv().SelectedPart = Part
end)

Aim:Label("Config",{
    TextSize = 16; -- Self Explaining
    TextColor = Color3.fromRGB(0, 0, 0); -- Self Explaining
    BgColor = Color3.fromRGB(97, 233, 43); -- Self Explaining 
})

Aim:Bind("Toggle",Enum.KeyCode.Y,function() --Default bind
    getgenv().AimToggle = not getgenv().AimToggle
end)

Aim:Toggle("Auto FOV", function(bool)
    getgenv().AutoFOV = bool
end)

SafeEsp:Toggle("Toggle", function(bool)
    getgenv().SafeEsp = bool
    
    if getgenv().SafeEsp then
        MakeSafeDots()
    end
end)

DealerEsp:Toggle("Toggle", function(bool)
    getgenv().DealerEsp = bool
end)

MiscOptions:Label("Auto Pick Up", {
    TextSize = 16; -- Self Explaining
    TextColor = Color3.fromRGB(0, 0, 0); -- Self Explaining
    BgColor = Color3.fromRGB(97, 233, 43); -- Self Explaining 
})

MiscOptions:Toggle("Cash and Scrap", function(bool)
    getgenv().CanPickUp = not getgenv().CanPickUp
end)

local MakeEsp = function(Ador, Shape, Properties)
	if not Ador.PrimaryPart then return end
	local vector, OnScreen = Camera:WorldToScreenPoint(Ador.PrimaryPart.Position)

	local Rec = Drawing.new(Shape)

	for Property, Value in pairs(Properties) do
		Rec[Property] = Value
	end

	local Size

	if Shape == "Rectangle" or Shape == "Square" then
		Size = Rec.Size
	else
		Size = Rec.Radius
	end

	local Position = (typeof(Size) == "Vector2" and Vector2.new(vector.X - Size.X/2, vector.Y - Size.Y/2)) or Vector2.new(vector.X - Size/2, vector.Y - Size/2)

	Rec.Position = Position
	Rec.Visible = OnScreen

	return Ador, Rec
end

ScarpSpawn.ChildRemoved:Connect(function(Child)
	refresh()
end)

ScarpSpawn.ChildAdded:Connect(function(Child)
	refresh()
end)

function refresh()
    if getgenv().SafeEsp then
        for i,v in pairs(SafeHolder) do
            SafeHolder[i][2]:Remove()
            SafeHolder[i] = nil
        end
        
        wait()
        MakeSafeDots()
    end
end

function MakeSafeDots()
	for i,v in pairs(Safes:GetChildren()) do
		if not v:FindFirstChild("Values") and v:FindFirstChild("Values"):FindFirstChild("Health") then continue end

		local Health = v.Values.Health
		local Model, Rec = MakeEsp(v, "Circle", {
			Radius = 3,
			Filled = true
		})

		SafeHolder[HTTP:GenerateGUID(false)] = {Model, Rec}

		if Health.Value <= 0 then 
			Rec.Color = SafeOffColor
		else
			Rec.Color = SafeOnColor
		end

		Health.Changed:Connect(function()
			if Health.Value <= 0 then 
				Rec.Color = SafeOffColor
			else
				Rec.Color = SafeOnColor
			end
		end)
	end
end

function MakeDealerDots()
	for i,v in pairs(Dealers:GetChildren()) do
		local Model, Rec = MakeEsp(v:FindFirstChildOfClass("Model"), "Square", {
			Size = Vector2.new(3,3),
			Filled = true,
            Color = Color3.new(0.992156, 0, 0),
            Visible = false
		})

		DealerHolder[HTTP:GenerateGUID(false)] = {Model, Rec}
	end
end

MakeDealerDots()
MakeSafeDots()

local function characterType(player)
    if player.Character or workspace:FindFirstChild(player.Name) then
        local playerCharacter = player.Character or workspace:FindFirstChild(player.Name)
        return playerCharacter
    end
end

local function teamType(player)
    if player.Team or player.TeamColor then
        local teamplayer = player.Team or player.TeamColor
        return teamplayer
    end
end

local function FFA()
    sameTeam = 0
    for _, player in next, Players:GetPlayers() do
        if teamType(player) == teamType(LocalPlayer) then
            sameTeam = sameTeam + 1
        end
    end
    if sameTeam == #Players:GetChildren() then
        return true
    else
        return false
    end
end

local function returnVisibility(player)
    if getgenv().VisibiltyCheck then
        if characterType(player) then 
            if player.Character:FindFirstChild(getgenv().SelectedPart) then 
                CastPoint = {LocalPlayer.Character[getgenv().SelectedPart].Position, player.Character[getgenv().SelectedPart].Position}
                IgnoreList = {player.Character, LocalPlayer.Character}
                local castpointparts = workspace.CurrentCamera:GetPartsObscuringTarget(CastPoint, IgnoreList)
                if unpack(castpointparts) then
                    return false
                end
            end
        end
    end
    return true
end

local function returnRay(args, hit)
    CCF = Camera.CFrame.p
    args[2] = Ray.new(CCF, (hit.Position + Vector3.new(0,(CCF-hit.Position).Magnitude/getgenv().Distance,0) - CCF).unit * (getgenv().Distance * 10))
    return args[2]
end

spawn(function()
    local Circle = Drawing.new('Circle')
    Circle.Transparency = 1
    Circle.Thickness = 1.5
    Circle.Visible = true
    Circle.Color = Color3.fromRGB(255,0,0)
    Circle.Filled = false
    Circle.Radius = getgenv().FOV
    
    local TargetText = Drawing.new("Text")
    getgenv().SelectedTarget = ""
    TargetText.Text = ""
    TargetText.Size = 17
    TargetText.Center = true
    TargetText.Visible = true
    TargetText.Color = Color3.fromRGB(255, 251, 0)
    
    RunServ:BindToRenderStep("Get_Fov",1,function()
        if getgenv().AimToggle then
            local Length = 10
            local Middle = 37
            Circle.Visible = getgenv().CircleVisibility
            TargetText.Visible = getgenv().CircleVisibility
            Circle.Color = getgenv().Rainbow
            Circle.Radius = getgenv().FOV
            Circle.Position = Vector2.new(Mouse.X,Mouse.Y+Middle)
            TargetText.Position = Vector2.new(Mouse.X,Mouse.Y+Middle-180)
            TargetText.Text = getgenv().SelectedTarget
        else
            Circle.Visible = false
            TargetText.Visible = false
        end
    end)
end)

function getTarget()
	local closestTarg = math.huge
	local Target = nil
    
	for _, Player in next, Players:GetPlayers() do
        if Player ~= LocalPlayer and returnVisibility(Player) and teamType(Player) ~= teamType(LocalPlayer) or FFA() and Player ~= LocalPlayer and returnVisibility(Player) then
            local playerCharacter = characterType(Player)
            if playerCharacter then
                local playerHumanoid = playerCharacter:FindFirstChild("Humanoid")
                local playerHumanoidRP = playerCharacter:FindFirstChild(getgenv().SelectedPart)
                if playerHumanoidRP and playerHumanoid then
                    local hitVector, onScreen = Camera:WorldToScreenPoint(playerHumanoidRP.Position)
                    if onScreen and playerHumanoid.Health > 0 then
                        local CCF = Camera.CFrame.p
                        if workspace:FindPartOnRayWithIgnoreList(Ray.new(CCF, (playerHumanoidRP.Position-CCF).Unit * getgenv().Distance),{Player}) then
                            local hitTargMagnitude = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(hitVector.X, hitVector.Y)).Magnitude
                            if hitTargMagnitude < closestTarg and hitTargMagnitude <= getgenv().FOV then
                                Target = Player
                                closestTarg = hitTargMagnitude
                            end
                        else
                        end
                    else
                    end
                end
            end
		end
	end
	return Target
end

local mt = getrawmetatable(game)
setreadonly(mt, false)
local index = mt.__index
local namecall = mt.__namecall
local hookfunc

mt.__namecall = newcclosure(function(...)
    local method = getnamecallmethod()
    local args = {...}
    for _, rayMethod in next, getgenv().methodsTable do
        if tostring(method) == rayMethod and Hit then
            returnRay(args, Hit)
            return namecall(unpack(args))
        end
    end
    return namecall(unpack(args))
end)

mt.__index = newcclosure(function(func, idx)
    if func == Mouse and tostring(idx) == "Hit" and Hit then
        return Hit.CFrame
    end
    return index(func, idx)
end)

hookfunc = hookfunction(workspace.FindPartOnRayWithIgnoreList, function(...)
    local args = {...}
    if Hit then
        returnRay(args, Hit)
    end
    return hookfunc(unpack(args))
end)

RunServ:BindToRenderStep("Get_Target",1,function()
    if getgenv().AimToggle then
        local Target = getTarget()
        if not Target then
            Hit = nil
            getgenv().SelectedTarget = ""
        else
            getgenv().SelectedTarget = Target.Name .. "\n" .. math.floor((LocalPlayer.Character[getgenv().SelectedPart].Position - Target.Character[getgenv().SelectedPart].Position).magnitude) .. " Studs"
        end
        if UserInput:IsMouseButtonPressed(0) then
            if Target then
                Hit = Target.Character[getgenv().SelectedPart]
            end
        else
            Hit = nil
        end
    end
end)

RunServ:BindToRenderStep("Hova upid", 1, function()
    if not getgenv().SafeEsp then
        for i,v in pairs(SafeHolder) do
            SafeHolder[i][2]:Remove()
            SafeHolder[i] = nil
        end
    else
        for i,v in pairs(SafeHolder) do
            local vector, OnScreen = Camera:WorldToScreenPoint(v[1].PrimaryPart.Position)        
            local Size = 3
            local Position = Vector2.new(vector.X - Size/2, vector.Y - Size/2)
    
            v[2].Position = Position
            v[2].Visible = OnScreen
    
            local Health = v[1].Values.Health
    
            if Health.Value <= 0 then 
                v[2].Color = SafeOffColor
            else
                v[2].Color = SafeOnColor
            end
        end
    end

    if not getgenv().DealerEsp then
        for i,v in pairs(DealerHolder) do
            if DealerHolder[i] then
                DealerHolder[i][2].Visible = false
            end
        end
    else
        for i,v in pairs(DealerHolder) do
            local vector, OnScreen = Camera:WorldToScreenPoint(v[1].PrimaryPart.Position)        
            local Size = Vector2.new(2,2)
            local Position = Vector2.new(vector.X - Size.X/2, vector.Y - Size.Y/2)
    
            v[2].Position = Position
            v[2].Visible = OnScreen
        end
    end
end)

while wait() do
	if getgenv().CanPickUp then
		wait(1)
		for i,v in pairs(ScarpSpawn:GetChildren()) do
			if v and v.PrimaryPart then
				local Prim = v.PrimaryPart

				if (LocalPlayer.Character["Left Leg"].Position - Prim.Position).Magnitude <= 4 then
					PickUpRemote:FireServer(Prim)
				end
			end
		end

		for i,v in pairs(CashFolder:GetChildren()) do
			if v then
				if (LocalPlayer.Character["Left Leg"].Position - v.Position).Magnitude <= 4 then
					PickUpCash:FireServer(v)
				end
			end
		end
	end
end