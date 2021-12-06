--sad

local Players = game:GetService("Players")
local UserInput = game:GetService("UserInputService")
local HTTP = game:GetService("HttpService")
local RunServ = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
PlayerGui:SetTopbarTransparency(1)
local Mouse = LocalPlayer:GetMouse()
local PickUpRemote = game:GetService("ReplicatedStorage")["Events"]["PIC_PU"]
local PickUpCash = game:GetService("ReplicatedStorage")["Events"]["CZDPZUS"]

local CashFolder = game:GetService("Workspace").Filter.SpawnedBread
local ScarpSpawn = game:GetService("Workspace").Filter.SpawnedPiles
local Dealers = game:GetService("Workspace")["Map"]["Shopz"]
local Safes = game:GetService("Workspace")["Map"]["BredMakurz"]
local ItemStats = game:GetService("ReplicatedStorage").Storage.ItemStats
local Melees = ItemStats.Melees:GetChildren()
local Guns = ItemStats.Guns:GetChildren()
local Throwables = ItemStats.Throwables:GetChildren()
local MiscFolder = ItemStats.Misc:GetChildren()
local Armour = ItemStats.Armour:GetChildren()
local ItemList = {}
local LastUpdated = 0

RunServ:UnbindFromRenderStep("Get_Fov")
RunServ:UnbindFromRenderStep("Get_Target")
RunServ:UnbindFromRenderStep("Hova Upid")
RunServ:UnbindFromRenderStep("Dropss")

getgenv().methodsTable = {"Ray", "Raycast"}
getgenv().Rainbow = Color3.new(0.952941, 0.921568, 0.921568)
getgenv().SelectedPart = "Head"
getgenv().VisibiltyCheck = false
getgenv().FOV = 250
getgenv().CircleVisibility = true
getgenv().Distance = 400
getgenv().CanPickUp = false
getgenv().SafeEsp = false
getgenv().ScrapEsp = false
getgenv().DealerEsp = false
getgenv().AutoFOV = false
getgenv().MeleeFOV = 250
getgenv().GunFOV = 150
getgenv().HitChance = 100
getgenv().SelectedItem = "None"
getgenv().SafeHolder = getgenv().SafeHolder or {}
getgenv().DealerHolder = getgenv().DealerHolder or {}
getgenv().ScrapHolder = getgenv().ScrapHolder or {}
getgenv().AutoLockPick = false

local rigType = string.split(tostring(LocalPlayer.Character:WaitForChild("Humanoid").RigType), ".")[3]
local selected_rigType

local rigTypeR6 = {
    "Head",
	"Torso",
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
local SafeOnColor = Color3.fromRGB(34, 226, 16)
local SafeOffColor = Color3.fromRGB(93, 93, 93)

if rigType == "R6" then
    selected_rigType = rigTypeR6
elseif rigType == "R15" then
    selected_rigType = rigTypeR15
end

local library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/AikaV3rm/UiLib/master/Lib.lua')))()
_G.MainColor = Color3.new()
_G.SecondaryColor = Color3.new(0.866666, 0.447058, 0.058823)
_G.TertiaryColor = Color3.new(0, 0, 0)
_G.ArrowColor = Color3.new(0.733333, 0.356862, 0.050980)

local SilentAim = library:CreateWindow("Silent Aim") -- Creates the window
local Esps = library:CreateWindow("Esps")
local Misc = library:CreateWindow("Misc")

local Aim = SilentAim:CreateFolder("Silent Aim") -- Creates the folder(U will put here your buttons,etc)
local WeaponOptions = SilentAim:CreateFolder("WeaponSettings")

local SafeEsp = Esps:CreateFolder("SafeEsp")
local DealerEsp = Esps:CreateFolder("DealerEsp")
local ScrapEsp = Esps:CreateFolder("ScrapEsp")

local MiscOptions = Misc:CreateFolder("Options")

--Aim:Toggle("Enable",function(bool)
--    getgenv().AimToggle = bool
--end)

table.insert(ItemList, "None")
for i,v in pairs(Armour) do
    table.insert(ItemList, v.Name)
end

for i,v in pairs(Melees) do
    table.insert(ItemList, v.Name)
end

for i,v in pairs(Guns) do
    table.insert(ItemList, v.Name)
end

for i,v in pairs(MiscFolder) do
    table.insert(ItemList, v.Name)
end

for i,v in pairs(Throwables) do
    table.insert(ItemList, v.Name)
end


Aim:Label("Targeted Part",{
    TextSize = 16; -- Self Explaining
    TextColor = Color3.fromRGB(0, 0, 0); -- Self Explaining
    BgColor = Color3.new(0.733333, 0.356862, 0.050980); -- Self Explaining 
})

Aim:Dropdown("Head", selected_rigType, true, function(Part) --true/false, replaces the current title "Dropdown" with the option that t
    getgenv().SelectedPart = Part
end)

Aim:Label("Config",{
    TextSize = 16; -- Self Explaining
    TextColor = Color3.fromRGB(0, 0, 0); -- Self Explaining
    BgColor = Color3.new(0.733333, 0.356862, 0.050980); -- Self Explaining 
})

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

Aim:Slider("Distance",{
    min = 50; -- min value of the slider
    max = 1000; -- max value of the slider
    precise = false; -- max 2 decimals
},function(value)
    getgenv().Distance = value
end)

Aim:Bind("Toggle",Enum.KeyCode.Y,function() --Default bind
    getgenv().AimToggle = not getgenv().AimToggle

    if getgenv().AimToggle then
        RunServ:BindToRenderStep("Get_Target",3,function()
            if getgenv().AimToggle then
                local Target = getTarget()
                if not Target then
                    Hit = nil
                    getgenv().SelectedTarget = ""
                else
                    getgenv().SelectedTarget = Target.Name .. "\n" .. math.floor((LocalPlayer.Character[getgenv().SelectedPart].Position - Target.Character[getgenv().SelectedPart].Position).magnitude) .. " Studs"
                end
                if UserInput:IsMouseButtonPressed(0) then
                    LastUpdated = os.time()
        
                    if Target then
                        local Item = CheckForWeapon()
                        if Item == "GunFOV" then
                            if math.random(10,100) >= getgenv().HitChance then
                                Hit = Target.Character[getgenv().SelectedPart]
                            else
                                Hit = nil
                            end
                        else
                            Hit = Target.Character[getgenv().SelectedPart]
                        end
                    end
                else
                    Hit = nil
                end
            end
        end)
    else
        RunServ:UnbindFromRenderStep("Get_Target")
    end
end)

WeaponOptions:Slider("Gun Hit Chance",{
    min = 10; -- min value of the slider
    max = 100; -- max value of the slider
    precise = false; -- max 2 decimals
},function(value)
    getgenv().HitChance = value
end)

WeaponOptions:Slider("GunFOV",{
    min = 5; -- min value of the slider
    max = 250; -- max value of the slider
    precise = false; -- max 2 decimals
},function(value)
    getgenv().GunFOV = value
end)

WeaponOptions:Slider("MeleeFOV",{
    min = 5; -- min value of the slider
    max = 350; -- max value of the slider
    precise = false; -- max 2 decimals
},function(value)
    getgenv().MeleeFOV = value
end)

WeaponOptions:Toggle("Auto FOV", function(bool)
    getgenv().AutoFOV = bool
end)

SafeEsp:Toggle("Toggle", function(bool)
    getgenv().SafeEsp = bool
    
    if getgenv().SafeEsp then
        MakeSafeDots()
    end
end)

ScrapEsp:Toggle("Toggle", function(bool)
    getgenv().ScrapEsp = bool

    if getgenv().ScrapEsp then
        MakeScrapDots()
    end
end)

DealerEsp:Toggle("Toggle", function(bool)
    getgenv().DealerEsp = bool
end)

DealerEsp:Dropdown("None", ItemList, true, function(Item) --true/false, replaces the current title "Dropdown" with the option that t
    getgenv().SelectedItem = Item
end)

MiscOptions:Label("Auto", {
    TextSize = 16; -- Self Explaining
    TextColor = Color3.fromRGB(0, 0, 0); -- Self Explaining
    BgColor = Color3.new(0.733333, 0.356862, 0.050980); -- Self Explaining 
})

MiscOptions:Toggle("Auto Lockpick", function(bool)
    getgenv().AutoLockPick = bool
end)

function CheckAvalibility(Dealer)
    for i,v in pairs(Dealer:FindFirstChild("CurrentStocks", true):GetChildren()) do
        if v.Name == getgenv().SelectedItem and v.Value ~= 0 then
            return true
        end
    end
    return false
end

function AutoFinishLockPicks(Gui)
    task.wait(.2)
    local MF = Gui.MF
    local LPFrame = MF.LP_Frame.Frames
    
    for i,v in pairs(LPFrame:GetChildren()) do
        repeat
            task.wait()
        until v.Bar.AbsolutePosition.Y >= 465 and v.Bar.AbsolutePosition.Y <= 475
        mouse1click()
        task.wait(.2)
    end
end

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

PlayerGui.ChildAdded:Connect(function(child)
    if child.Name == "LockpickGUI" and getgenv().AutoLockPick then
        AutoFinishLockPicks(child)
    end
end)

function refresh()
    if getgenv().SafeEsp then
        for i,v in pairs(getgenv().SafeHolder) do
            getgenv().SafeHolder[i][2]:Remove()
            getgenv().SafeHolder[i] = nil
        end
        
        task.wait()
        MakeSafeDots()
    end

    if getgenv().ScrapEsp then
        for i,v in pairs(getgenv().ScrapHolder) do
            getgenv().ScrapHolder[i][2]:Remove()
            getgenv().ScrapHolder[i] = nil
        end
        
        task.wait()
        MakeScrapDots()
    end
end

local function characterType(player)
    if player.Character or workspace:FindFirstChild(player.Name) then
        local playerCharacter = player.Character or workspace:FindFirstChild(player.Name)
        return playerCharacter
    end
end

function CheckForWeapon()
    local Character = LocalPlayer.Character
    for i,v in pairs(Guns) do
        if Character:FindFirstChild(v.Name) then
            return "GunFOV"
        end
    end

    for i,v in pairs(Melees) do
        if Character:FindFirstChild(v.Name) then
            return "MeleeFOV"
        end
    end

    if Character:FindFirstChild("Fists") then
        return "MeleeFOV"
    end

    return "FOV"
end

function MakeSafeDots()
	for i,v in pairs(Safes:GetChildren()) do
		if not v:FindFirstChild("Values") and v:FindFirstChild("Values"):FindFirstChild("Health") then continue end

		local Broken = v.Values.Broken
		local Model, Rec = MakeEsp(v, "Circle", {
			Radius = 3,
			Filled = true
		})

		getgenv().SafeHolder[HTTP:GenerateGUID(false)] = {Model, Rec}

		if Broken.Value then 
			Rec.Color = SafeOffColor
		else
			Rec.Color = SafeOnColor
		end

		Broken.Changed:Connect(function()
			if Broken.Value  then 
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

		getgenv().DealerHolder[HTTP:GenerateGUID(false)] = {Model, Rec}
	end
end

function MakeScrapDots()
	for i,v in pairs(ScarpSpawn:GetChildren()) do
		local Model, Rec = MakeEsp(v, "Square", {
			Size = Vector2.new(3,3),
			Filled = false
		})

		getgenv().ScrapHolder[HTTP:GenerateGUID(false)] = {Model, Rec}
	end
end

MakeDealerDots()
MakeSafeDots()
--MakeScrapDots()

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

task.spawn(function()
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

    local FOVSize = Instance.new("NumberValue")
    FOVSize.Value = getgenv().FOV

    RunServ:BindToRenderStep("Get_Fov",4,function()
        if getgenv().AimToggle then
            local Length = 10
            local Middle = 37
            Circle.Visible = getgenv().CircleVisibility
            TargetText.Visible = getgenv().CircleVisibility
            Circle.Color = getgenv().Rainbow
            Circle.Position = Vector2.new(Mouse.X,Mouse.Y+Middle)
            TargetText.Position = Vector2.new(Mouse.X,Mouse.Y+Middle-180)
            TargetText.Text = getgenv().SelectedTarget
            local Item = CheckForWeapon()

            if getgenv().AutoFOV then
                TweenService:Create(FOVSize, TweenInfo.new(.2, Enum.EasingStyle.Back), {Value = getgenv()[Item]}):Play()
            else
                TweenService:Create(FOVSize, TweenInfo.new(.2, Enum.EasingStyle.Back), {Value = getgenv().FOV}):Play()
            end

            Circle.Radius = FOVSize.Value
        else
            Circle.Visible = false
            TargetText.Visible = false
        end
    end)
end)

function RayCast(Position, Direction, MaxDistance, IgnoreList, IgnoreWater)
	local Pos
	local RayParams = RaycastParams.new()
	RayParams.FilterDescendantsInstances = IgnoreList
	RayParams.FilterType = Enum.RaycastFilterType.Blacklist
	RayParams.IgnoreWater = IgnoreWater or false

	local Ray = workspace:Raycast(Position, Direction.unit , RayParams)

	if Ray and Ray.Instance then
		return Ray.Instance, Ray.Position, Ray.Material, Ray.Normal
	else
		Pos = (CFrame.new(Position) * CFrame.new(Direction)).p
	end

	return nil, Pos, nil, nil
end

function getTarget()
	local closestTarg = math.huge
	local Target = nil
    
	for _, Player in next, Players:GetPlayers() do
        if Player ~= LocalPlayer and returnVisibility(Player) and teamType(Player) ~= teamType(LocalPlayer) or FFA() and Player ~= LocalPlayer and returnVisibility(Player) then
            local playerCharacter = characterType(Player)
            if playerCharacter then
                local playerHumanoid = playerCharacter:FindFirstChild("Humanoid")
                local playerHumanoidRP = playerCharacter:FindFirstChild(getgenv().SelectedPart)
                if playerHumanoidRP and playerHumanoid and playerHumanoid.Health > 0 then
                    local hitVector, onScreen = Camera:WorldToScreenPoint(playerHumanoidRP.Position)
                    if onScreen and playerHumanoid.Health > 0 then
                        local CCF = Camera.CFrame.Position
                        if workspace:FindPartOnRayWithIgnoreList(Ray.new(CCF, (playerHumanoidRP.Position-CCF).Unit * getgenv().Distance),{Player}) then
                            local hitTargMagnitude = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(hitVector.X, hitVector.Y)).Magnitude
                            if hitTargMagnitude < closestTarg and hitTargMagnitude <= getgenv()[CheckForWeapon()] then
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
            print(rayMethod)
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

hookfunc = hookfunction(workspace.Raycast, function(...)
    local args = {...}
    if Hit then
        returnRay(args, Hit)
    end
    return hookfunc(unpack(args))
end)

RunServ:BindToRenderStep("Hova upid", 1, function()
    if not getgenv().SafeEsp then
        for i,v in pairs(getgenv().SafeHolder) do
            getgenv().SafeHolder[i][2]:Remove()
            getgenv().SafeHolder[i] = nil
        end
    else
        for i,v in pairs(getgenv().SafeHolder) do
            local vector, OnScreen = Camera:WorldToScreenPoint(v[1].PrimaryPart.Position)        
            local Size = 3
            local Position = Vector2.new(vector.X - Size/2, vector.Y - Size/2)
    
            v[2].Position = Position
            v[2].Visible = OnScreen
    
            local Broken = v[1].Values.Broken
    
            if Broken.Value then 
                v[2].Color = SafeOffColor
            else
                v[2].Color = SafeOnColor
            end
        end
    end

    if not getgenv().ScrapEsp then
        for i,v in pairs(getgenv().ScrapHolder) do
            getgenv().ScrapHolder[i][2]:Remove()
            getgenv().ScrapHolder[i] = nil
        end
    else
        for i,v in pairs(getgenv().ScrapHolder) do
            if not v[1] then v[2]:Remove() continue end
            local vector, OnScreen = Camera:WorldToScreenPoint(v[1].PrimaryPart.Position)
    
            v[2].Visible = OnScreen
            v[2].Filled = false
    
            local Size = Vector2.new(3.5,3.5)
            local Position = Vector2.new(vector.X - Size.X/2, vector.Y - Size.Y/2)
            v[2].Position = Position
            v[2].Color = v[1].PrimaryPart:FindFirstChild("Particle").Color.Keypoints[1].Value
        end
    end

    if not getgenv().DealerEsp then
        for i,v in pairs(getgenv().DealerHolder) do
            if getgenv().DealerHolder[i] then
                getgenv().DealerHolder[i][2].Visible = false
            end
        end
    else
        for i,v in pairs(getgenv().DealerHolder) do
            local vector, OnScreen = Camera:WorldToScreenPoint(v[1].PrimaryPart.Position)        
            local Size = Vector2.new(3,3)
            local Position = Vector2.new(vector.X - Size.X/2, vector.Y - Size.Y/2)
    
            v[2].Position = Position
            v[2].Visible = OnScreen
            v[2].Color = (CheckAvalibility(v[1].Parent) and Color3.new(0.729411, 0.741176, 0.109803)) or Color3.new(1, 0, 0)
        end
    end
end)
