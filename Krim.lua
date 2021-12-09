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
getgenv().CircleVisibility = true
getgenv().Distance = 400
getgenv().CanPickUp = false
getgenv().SafeEsp = false
getgenv().ScrapEsp = false
getgenv().DealerEsp = false
getgenv().SelectedItem = "None"
getgenv().SafeHolder = getgenv().SafeHolder or {}
getgenv().DealerHolder = getgenv().DealerHolder or {}
getgenv().ScrapHolder = getgenv().ScrapHolder or {}
getgenv().AutoLockPick = false
_G.AimLock = false
_G.FOV = 250
_G.Visible = true

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
local AimBot = loadstring(game:HttpGet("https://raw.githubusercontent.com/JuiceWarfare/Silent/master/Aimlock.lua"))()
_G.MainColor = Color3.new()
_G.SecondaryColor = Color3.new(0.866666, 0.447058, 0.058823)
_G.TertiaryColor = Color3.new(0, 0, 0)
_G.ArrowColor = Color3.new(0.733333, 0.356862, 0.050980)

local SilentAim = library:CreateWindow("Aim") -- Creates the window
local Esps = library:CreateWindow("Esps")
local Misc = library:CreateWindow("Misc")

local Aim = SilentAim:CreateFolder("AimLock") -- Creates the folder(U will put here your buttons,etc)

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
    _G.Visible = bool
end)

Aim:Slider("FOV",{
    min = 5; -- min value of the slider
    max = 250; -- max value of the slider
    precise = false; -- max 2 decimals
},function(value)
    getgenv().FOV = value
end)

Aim:Bind("Toggle",Enum.KeyCode.Y,function() --Default bind
    _G.AimLock = not _G.AimLock
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
    task.wait(.3)
    local MF = Gui.MF
    local LPFrame = MF.LP_Frame.Frames
    
    for i,v in pairs(LPFrame:GetChildren()) do
        if not v:IsA("Frame") then continue end
        
        repeat
            task.wait()
        until v.Bar.Position.Y.Offset >= 0 and v.Bar.Position.Y.Offset <= 15
        mouse1click()
        task.wait(.3)
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
