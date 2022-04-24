local SolarisLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/sol"))()
--sad
local UIName = "Creaminality.txt"
local Players = game:GetService("Players")
local UserInput = game:GetService("UserInputService")
local HTTP = game:GetService("HttpService")
local RunServ = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Mouse = LocalPlayer:GetMouse()
local PickUpRemote = game:GetService("ReplicatedStorage")["Events"]["PIC_PU"]
local PickUpCash = game:GetService("ReplicatedStorage")["Events"]["CZDPZUS"]

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
local SafeHolder = {}
local DealerHolder = {}
local ScrapHolder = {}
local Friends = {}

RunServ:UnbindFromRenderStep("Hova Upid")

getgenv().Settings = {
    SafeEsp = false,
    ScrapEsp = false,
    DealerEsp = false,
    
    AutoLockPick = false,
    
    Type = "Mouse",
    SelectedPart = "Head",
    SelectedItem = "None",
    RandomSelect = false,
    AimLock = false,
    FOV = 100,
    CircleVisibility = true,
    HitChance = 100,
    Blacklist = false, -- Friends aren't targeted by silent aim

    KillSwitch = false
}

local PrevSettings = {}

if isfile(UIName) then
    local data = readfile(UIName)
    data = HTTP:JSONDecode(data)

    for i,v in pairs(data) do
        getgenv().Settings[i] = v
    end
    SolarisLib:Notification("Loaded", "Data loaded")
end

local Settings = getgenv().Settings
local rigTypeR6 = {
    "Head",
	"Torso",
	"Left Arm",
	"Right Arm",
	"Left Leg",
	"Right Leg",
}

local SafeOnColor = Color3.fromRGB(34, 226, 16)
local SafeOffColor = Color3.fromRGB(93, 93, 93)
    
local AimBot = loadstring(game:HttpGet("https://raw.githubusercontent.com/JuiceWarfare/Silent/master/Aimlock.lua"))()

local FovCircle = Drawing.new("Circle")
FovCircle.Visible = true
FovCircle.Filled = false
FovCircle.Radius = Settings.FOV
FovCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
FovCircle.Thickness = .1
FovCircle.Color = Color3.new(1, 1, 1)

_G.MainColor = Color3.new()
_G.SecondaryColor = Color3.new(0.866666, 0.447058, 0.058823)
_G.TertiaryColor = Color3.new(0, 0, 0)
_G.ArrowColor = Color3.new(0.733333, 0.356862, 0.050980)

local window = SolarisLib:New({
    Name = "Creaminality",
    FolderToSave = "CreamStuff"
})
local SilentAim = window:Tab("Aim") -- Creates the window
local Esps = window:Tab("Esps")
local Misc = window:Tab("Misc")

local Aim = SilentAim:Section("AimLock") -- Creates the folder(U will put here your buttons,etc)

local SafeEsp = Esps:Section("SafeEsp")
local DealerEsp = Esps:Section("DealerEsp")
local ScrapEsp = Esps:Section("ScrapEsp")

local MiscOptions = Misc:Section("Options")

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

local TDrop = Aim:Dropdown("Targeted Part", rigTypeR6, Settings.SelectedPart, "AimDrop", function(Item) --true/false, replaces the current title "Dropdown" with the option that t
    Settings.SelectedPart = Item
end)

local RndSelect = Aim:Toggle("RandomSelect(Override)", Settings.RandomSelect, "RandomSelect", function(bool)
    Settings.RandomSelect = bool
end)

local AimType = Aim:Dropdown("Aim Type", {"Mouse", "Closest"}, Settings.Type, "AimType", function(Item) --true/false, replaces the current title "Dropdown" with the option that t
    Settings.Type = Item
end)

local CircleVis = Aim:Toggle("Visible", Settings.CircleVisibility, "Visible" ,function(bool)
    Settings.CircleVisibility = bool
end)

local FOV = Aim:Slider("FOV", 20, 250, Settings.FOV, 5, "FOVa", function(value)
   Settings.FOV = value
end)

FOV:Set(Settings.FOV)

Aim:Bind("Aimbot", Enum.KeyCode.Y, false, "Aimbot", function() --Default bind
    Settings.AimLock = not Settings.AimLock
end)

local HitChance = Aim:Slider("Hit Chance", 10, 100, Settings.HitChance, 5, "HitChance",function(value)
    Settings.HitChance = value
end)

HitChance:Set(Settings.HitChance)

Aim:Toggle("Blacklist Friends", Settings.Blacklist, "Blacklist" ,function(bool)
    Settings.Blacklist = bool
end)

local SEsp = SafeEsp:Toggle("Safe", false, "SafeE", function(bool)
    Settings.SafeEsp = bool
    
    if Settings.SafeEsp then
        MakeSafeDots()
    end
end)

local ScEsp = ScrapEsp:Toggle("Scraps", false, "ScrapsE", function(bool)
    Settings.ScrapEsp = bool

    if Settings.ScrapEsp then
        MakeScrapDots()
    end
end)

local DEsp = DealerEsp:Toggle("Dealer", false, "DealerE", function(bool)
    Settings.DealerEsp = bool
end)

DealerEsp:Dropdown("Item Check", ItemList, "", "ItemCheck",function(Item) --true/false, replaces the current title "Dropdown" with the option that t
    Settings.SelectedItem = Item
end)

MiscOptions:Label("Auto")

local AutoLockPick = MiscOptions:Toggle("Auto Lockpick", Settings.AutoLockPick, "LockPick", function(bool)
    Settings.AutoLockPick = bool
end)

MiscOptions:Label("Other")

MiscOptions:Bind("KillSwitch", Enum.KeyCode.N, false, "KillSwitch", function() --Default bind
    Settings.KillSwitch = not Settings.KillSwitch
    
    if Settings.KillSwitch then
        for i, v in pairs(getgenv().Settings) do
            if typeof(v) == "boolean" then
                PrevSettings[i] = v
                getgenv().Settings[i] = false
            end
        end
    else
        for i, v in pairs(getgenv().Settings) do
            if typeof(v) == "boolean" then
                getgenv().Settings[i] = PrevSettings[i]
            end
        end
    end
end)


MiscOptions:Button("Save Settings", function()
    writefile(UIName, HTTP:JSONEncode(Settings))
    SolarisLib:Notification("Saved", "Your data has been saved")
end)

function CheckAvalibility(Dealer)
    for i,v in pairs(Dealer:FindFirstChild("CurrentStocks", true):GetChildren()) do
        if v.Name == Settings.SelectedItem and v.Value ~= 0 then
            return true
        end
    end
    return false
end


function AutoFinishLockPicks(Gui)
    task.wait(1)
    local MF = Gui.MF
    local LPFrame = MF.LP_Frame.Frames
    local Frames = {}
    local FrameNames = {
        "B1",
        "B2",
        "B3"
    }
    
    for i,v in pairs(LPFrame:GetChildren()) do
        if not v:IsA("Frame") then continue end
        if v.Visible then
            Frames[v.Name] = v
        end
    end

    for i, name in pairs(FrameNames) do
        local StartTime = os.time()
        local Frame = Frames[name]

        if Frame then
            repeat
                if os.time() - StartTime >= 3 then return end
                task.wait()
            until Frame.Bar.Position.Y.Offset >= -10 and Frame.Bar.Position.Y.Offset <= 13
        
            mouse1click()
            task.wait(.2)
        else
            continue
        end
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
    if child.Name == "LockpickGUI" and Settings.AutoLockPick then
        AutoFinishLockPicks(child)
    end
end)

function refresh()
    if Settings.SafeEsp then
        for i,v in pairs(SafeHolder) do
            SafeHolder[i][2]:Remove()
            SafeHolder[i] = nil
        end
        
        task.wait()
        MakeSafeDots()
    end

    if Settings.ScrapEsp then
        for i,v in pairs(ScrapHolder) do
            ScrapHolder[i][2]:Remove()
            ScrapHolder[i] = nil
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

		SafeHolder[HTTP:GenerateGUID(false)] = {Model, Rec}

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

		DealerHolder[HTTP:GenerateGUID(false)] = {Model, Rec}
	end
end

function MakeScrapDots()
	for i,v in pairs(ScarpSpawn:GetChildren()) do
		local Model, Rec = MakeEsp(v, "Square", {
			Size = Vector2.new(3,3),
			Filled = false
		})

		ScrapHolder[HTTP:GenerateGUID(false)] = {Model, Rec}
	end
end

MakeDealerDots()
MakeSafeDots()
--MakeScrapDots()

RunServ:BindToRenderStep("Hova upid", 1, function()

    if not Settings.AimLock then
        FovCircle.Visible = false
    else
        FovCircle.Visible = Settings.CircleVisibility
    end
    
    FovCircle.Radius = Settings.FOV
    FovCircle.Position = Vector2.new(Mouse.X , Mouse.Y + 37)

    if not Settings.SafeEsp then
        for i,v in pairs(SafeHolder) do
            SafeHolder[i][2]:Remove()
            SafeHolder[i] = nil
        end
    else
        for i,v in pairs(SafeHolder) do
            local vector, OnScreen = Camera:WorldToScreenPoint(v[1].PrimaryPart.Position)        
            local Size = 3
            local Position = Vector2.new(vector.X + Size/2, vector.Y + Size/2)
    
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

    if not Settings.ScrapEsp then
        for i,v in pairs(ScrapHolder) do
            ScrapHolder[i][2]:Remove()
            ScrapHolder[i] = nil
        end
    else
        for i,v in pairs(ScrapHolder) do
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

    if not Settings.DealerEsp then
        for i,v in pairs(DealerHolder) do
            if DealerHolder[i] then
                if DealerHolder[i][2] then
                    DealerHolder[i][2].Visible = false
                end
            end
        end
    else
        for i,v in pairs(DealerHolder) do
            if v[1] and v[1].PrimaryPart then
                local vector, OnScreen = Camera:WorldToScreenPoint(DealerHolder[i][1].PrimaryPart.Position)        
                local Size = Vector2.new(3,3)
                local Position = Vector2.new(vector.X - Size.X/2, vector.Y - Size.Y/2)
        
                DealerHolder[i][2].Position = Position
                DealerHolder[i][2].Visible = OnScreen
                DealerHolder[i][2].Color = (CheckAvalibility(DealerHolder[i][1].Parent) and Color3.new(0.729411, 0.741176, 0.109803)) or Color3.new(1, 0, 0)
            end
        end
    end
end)
