local drawing_new = Drawing.new
local vector2_new = Vector2.new
local vector3_new = Vector3.new
local cframe_new = CFrame.new
local cframe_angles = CFrame.Angles
local color3_new = Color3.new
local color3_hsv = Color3.fromHSV
local math_floor = math.floor
local raycast_params_new = RaycastParams.new
local enum_rft_blk = Enum.RaycastFilterType.Blacklist

local white = color3_new(255, 255, 255)
local green = color3_new(0, 255, 0)

local players = game:GetService("Players")
local run_service = game:GetService("RunService")
local workspace = game:GetService("Workspace")
local uis = game:GetService("UserInputService")
local rep_storage = game:GetService("ReplicatedStorage")

local frame_wait = run_service.RenderStepped

local local_player = players.LocalPlayer
local mouse = local_player:GetMouse()
local dummy_part = Instance.new("Part", nil)

local camera = workspace:FindFirstChildOfClass("Camera")
local screen_size = camera.ViewportSize
local center_screen = vector2_new((screen_size.X / 2), (screen_size.Y / 2))

--<- allowed modify ->--
local Using = false
local _aimsp_settings; _aimsp_settings = {

    -- aimbot settings
    use_aimbot = true,
    use_wallcheck = true,
    team_check = true,
    loop_all_humanoids = false, -- will allow aimbot to everything that has a humanoid, likely *VERY* laggy
    max_dist = 9e9, -- 9e9 = very big
    allow_toggle = {
        allow = false, -- turning this to false will make the aimbot toggle on right mouse button
        key = Enum.KeyCode.Z;
    },
    prefer = {
        looking_at_you = false, -- buggy
        closest_to_center_screen = false, -- stable
        closest_to_you = true, -- stable
    },
    toggle_hud_key = Enum.KeyCode.P,
    smoothness = 3, -- anything over 5 = aim assist,  1 = lock on (using 1 might get u banned)
    fov_size = 50; -- 150-450 = preferred

    -- esp settings
    esp_toggle_key = Enum.KeyCode.O,
    rainbow_speed = 5,
    use_rainbow = true,
    tracers = true,
    box = true,
    name = true,
    dist = true,
    health = true; -- might not work on some games
}

--<- allowed modify ->--

if getgenv().aimsp_settings then 
    getgenv().aimsp_settings = _aimsp_settings; 
    return 
end
getgenv().aimsp_settings = _aimsp_settings

local objects; objects = {
    fov = nil,
    text = nil,
    chams = {},
    tracers = {},
    quads = {},
    labels = {},
    look_at = {
        tracer = nil,
        point = nil;
    };
}

local debounces; debounces = {
    start_aim = false,
    custom_players = false,
    spoofs_hum_health = false;
}

local utility; utility = {
    get_rainbow = function()
        return color3_hsv((tick() % aimsp_settings.rainbow_speed / aimsp_settings.rainbow_speed), 1, 1)
    end,

    get_part_corners = function(part)
        local size = part.Size * vector3_new(1, 1.5, 0)

        return {
            top_right = (part.CFrame * cframe_new(-size.X, -size.Y, 0)).Position,
            bottom_right = (part.CFrame * cframe_new(-size.X, size.Y, 0)).Position,
            top_left = (part.CFrame * cframe_new(size.X, -size.Y, 0)).Position,
            bottom_left = (part.CFrame * cframe_new(size.X, size.Y, 0)).Position,
        }
    end,

    run_player_check = function()
        local plrs = players:GetChildren()

        for idx, val in pairs(objects.tracers) do
            if not plrs[idx] then
                utility.remove_esp(idx)
            end
        end
    end,

    remove_esp = function(name)
        utility.update_drawing(objects.tracers, name, {
            Visible = false,
            instance = "Line";
        })

        utility.update_drawing(objects.quads, name, {
            Visible = false,
            instance = "Quad";
        })

        utility.update_drawing(objects.labels, name, {
            Visible = false,
            instance = "Text";
        })
    end,

    update = function(str)
        if _G.Visible then
            objects.text.Text = str
            objects.text.Visible = true

            task.wait(1)

            objects.text.Visible = false
        end
    end,

    is_inside_fov = function(point)
        return (point.x - objects.fov.Position.X) ^ 2 + (point.y - objects.fov.Position.Y) ^ 2 <= objects.fov.Radius ^ 2
    end,
    
    to_screen = function(point)
        local screen_pos, in_screen = camera:WorldToScreenPoint(point)
        
        return (in_screen and vector2_new(screen_pos.X, screen_pos.Y)) or -1
    end,

    is_part_visible = function(origin_part, part)
        if not _G.VisibilityCheck then
            return true
        end

        local function run_cast(origin_pos)
            local BlackList = {origin_part.Parent}
            if camera:FindFirstChild("ViewModel") then
                table.insert(BlackList, camera:FindFirstChild("ViewModel"))
            end

            local raycast_params = raycast_params_new()
            raycast_params.FilterType = enum_rft_blk
            raycast_params.FilterDescendantsInstances = BlackList
            raycast_params.IgnoreWater = true
            
            local raycast_result = workspace:Raycast(origin_pos, (part.Position - origin_pos).Unit * aimsp_settings.max_dist, raycast_params)

            return ((raycast_result and raycast_result.Instance) or dummy_part):IsDescendantOf(part.Parent) 
        end

        local head_pos = (origin_part.Position + (origin_part.CFrame.LookVector))

        local cast_table = {
            origin_part.CFrame.UpVector * 2,
            -origin_part.CFrame.UpVector * 2,
            origin_part.CFrame.RightVector * 2,
            -origin_part.CFrame.RightVector * 2,
            vector3_new(0, 0, 0);
        }

        for idx, val in pairs(cast_table) do
            if run_cast(head_pos + val) == true then
                return true
            end
        end

        return false
    end,
    
    is_dead = function(char)
        if debounces.spoofs_hum_health then
            local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
            if torso and #(torso:GetChildren()) < 10 then
                return true
            end
        else
            local hum = char:FindFirstChild("Humanoid")
            if hum and hum.Health == 0 then
                return true
            end
        end

        return false
    end,

    update_drawing = function(tbl, child, val)
        if not tbl[child] then
            tbl[child] = utility.new_drawing(val.instance)(val)
        end
        
        for idx, val in pairs(val) do
            if idx ~= "instance" then
                tbl[child][idx] = val
            end
        end
        
        return tbl[child]
    end,
    
    new_drawing = function(classname)
        return function(tbl)
            local draw = drawing_new(classname)
            
            for idx, val in pairs(tbl) do
                if idx ~= "instance" then
                    draw[idx] = val
                end
            end
            
            return draw
        end
    end
}

objects.text = utility.new_drawing("Text"){
    Transparency = 1,
    Visible = false,
    Center = true,
    Size = 24,
    Color = white,
    Position = vector2_new(screen_size.X - 100, 36);
}

objects.fov = utility.new_drawing("Circle"){
    Thickness = 1,
    Transparency = 1,
    Visible = true,
    Color = white,
    Position = center_screen,
    Radius = aimsp_settings.fov_size;
}


uis.InputBegan:Connect(function(key, gmp)
    if gmp then return end

    if key.UserInputType == Enum.UserInputType.MouseButton2 and _G.AimLock then
       Using = true
    end
end)

uis.InputEnded:Connect(function(key, gmp)
    if gmp then return end

    if key.UserInputType == Enum.UserInputType.MouseButton2 and _G.AimLock then
       Using = false
    end
end)

function delay()
    frame_wait:Wait()
    --[[
        if you are lagging, replace this comment with the line below
        frame_wait:Wait()
    ]]
    return true
end

local get_players; -- create custom function for every game so that it doesnt check placeid every frame

if aimsp_settings.loop_all_humanoids then -- self explanitory
    get_players = function()
        local instance_table = {}

        for idx, val in pairs(workspace:GetDescendants()) do
            if val:IsA("Model") and val:FindFirstChildOfClass("Humanoid") then
                instance_table[#instance_table + 1] = val
            end
        end

        return instance_table
    end
elseif game.PlaceId == 18164449 then -- base wars
    debounces.spoofs_hum_health = true
elseif game.PlaceId == 292439477 then -- phantom forces
    debounces.custom_players = true

    get_players = function()
        local local_team = local_player.Character.Parent -- your character is not nil

        local get_team;

        if local_team then
            if aimsp_settings.team_check then
                if local_team.Name == "Phantoms" then
                    get_team = "Ghosts"
                else
                    get_team = "Phantoms"
                end
    
                return local_team.Parent[get_team]:GetChildren()
            else
                local instance_table = {}

                for idx, val in pairs(local_team.Parent.Phantoms:GetChildren()) do
                    if val:IsA("Model") then
                        instance_table[#instance_table + 1] = val
                    end
                end

                for idx, val in pairs(local_team.Parent.Ghosts:GetChildren()) do
                    if val:IsA("Model") then
                        instance_table[#instance_table + 1] = val
                    end
                end

                return instance_table -- return both teams
            end
        end

        return {} -- player is likely dead, return empty table so the mouse doesnt go apeshit
    end
--[[
    elseif game.PlaceId == 3233893879 then -- bad business

    local TS = require(rep_storage:WaitForChild("TS"))
    local net_module

    for idx, val in pairs(rep_storage:GetChildren()) do
        local children = val:GetChildren()
        if val.Name == " " and #children ~= 1 then
            for _idx, _val in pairs(children) do
                local module = require(_val)
                if module.Fire then
                    net_module = module -- found it
                end
            end
        end
    end

    get_players = function()
        
    end

    return {}
]]
else -- normal players
    get_players = function()
        return players:GetChildren()
    end
end

local function characterType(player)
    if player.Character or workspace:FindFirstChild(player.Name) then
        local playerCharacter = player.Character or workspace:FindFirstChild(player.Name)
        return playerCharacter
    end
end

function getTarget()
	local closestTarg = math.huge
	local Target = nil

	for _, Player in next, game.Players:GetPlayers() do
        if Player ~= local_player and utility.is_part_visible(local_player.Character.HumanoidRootPart, Player.Character.Head) then
            local playerCharacter = characterType(Player)
            if playerCharacter then
                local playerHumanoid = playerCharacter:FindFirstChild("Humanoid")
                local playerHumanoidRP = playerCharacter:FindFirstChild("Head")
                if playerHumanoidRP and playerHumanoid then
                    local hitVector, onScreen = camera:WorldToScreenPoint(playerHumanoidRP.Position)
                    if onScreen and playerHumanoid.Health > 0 then
                        local CCF = camera.CFrame.p
                        if workspace:FindPartOnRayWithIgnoreList(Ray.new(CCF, (playerHumanoidRP.Position-CCF).Unit * 9e9),{Player}) then
                            local hitTargMagnitude = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(hitVector.X, hitVector.Y)).Magnitude
                            if hitTargMagnitude < closestTarg and hitTargMagnitude <= _G.FOV then
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

coroutine.wrap(function()
    while task.wait() do
        local func, result = pcall(function()
            utility.update_drawing(objects, "fov", {
                Radius = _G.FOV,
                Position = center_screen,
                Color = (aimsp_settings.use_rainbow and utility.get_rainbow()) or white,
                instance = "Circle";
            })

            utility.run_player_check()

            if _G.Visible and _G.AimLock then
                objects.fov.Visible = true
            else
                objects.fov.Visible = false
            end

            if not _G.AimLock then
                Using = false
            end
            
            local closest_player = nil
            local dist = aimsp_settings.max_dist
            
            for idx, plr in pairs(get_players()) do -- continue skips current index
                local plr_char = ((aimsp_settings.loop_all_humanoids or debounces.custom_players) and plr) or plr.Character
                if plr == local_player then continue; end
                if plr_char == nil then continue; end

                if debounces.custom_players then -- teamcheck for games with custom chars
                    if plr_char.Parent == local_player.Character.Parent then continue; end
                end
                
                if aimsp_settings.team_check and not aimsp_settings.loop_all_humanoids and not debounces.custom_players then
                    if plr.Team then
                        if plr.TeamColor == local_player.TeamColor then continue; end
                        if plr.Team == local_player.Team then continue; end
                    end
                end
                
                if not utility.is_dead(plr_char) then
                    local plr_screen = utility.to_screen(plr_char.HumanoidRootPart.Position) -- emulate head pos
                    if aimsp_settings.prefer.looking_at_you then
                        local look_vector = plr_char.HumanoidRootPart.Position + (plr_char.HumanoidRootPart.CFrame.LookVector * mag)

                        local look_vector_lp_head_dist = (look_vector - local_player.Character.HumanoidRootPart.Position).Magnitude
                        if look_vector_lp_head_dist < dist and utility.is_inside_fov(plr_screen) then
                            dist = look_vector_lp_head_dist
                            closest_player = plr_char
                        end
                    elseif aimsp_settings.prefer.closest_to_center_screen then
                        local Target = getTarget()

                        if Target then
                            closest_player = Target.Character
                        end
                    elseif aimsp_settings.prefer.closest_to_you then
                        local plr_dist = (plr_char.HumanoidRootPart.Position - local_player.Character.HumanoidRootPart.Position).Magnitude
                        if plr_dist < dist then
                            dist = plr_dist
                            closest_player = plr_char
                        end
                    end
                else
                    utility.remove_esp(plr_char:GetDebugId())
                end
            end

            local visible_parts = {}
            local last

            if closest_player and aimsp_settings.use_aimbot then
                for idx, part in pairs(closest_player:GetChildren()) do
                    if part:IsA("BasePart") then
                        local screen_pos = utility.to_screen(part.Position)
    
                        if screen_pos ~= -1 then
                            if utility.is_inside_fov(screen_pos) and utility.is_part_visible(local_player.Character.HumanoidRootPart, part) then
                                last = {
                                    scr_pos = screen_pos,
                                    obj = part;
                                };
                                visible_parts[part.Name] = last
                            end
                        end
                    end
                end
                
                if visible_parts["Head"] then
                    visible_parts[0] = visible_parts["Head"]
                elseif visible_parts["UpperTorso"] or visible_parts["Torso"] then
                    visible_parts[0] = visible_parts["UpperTorso"] or visible_parts["Torso"]
                end

                local lock_part = visible_parts["Head"] or last

                if lock_part then
                    local scale = (lock_part.obj.Size.Y / 2)

                    local top = utility.to_screen((lock_part.obj.CFrame * cframe_new(0, scale, 0)).Position);
                    local bottom = utility.to_screen((lock_part.obj.CFrame * cframe_new(0, -scale, 0)).Position);
                    local radius = -(top - bottom).y;

                    utility.update_drawing(objects.look_at, "point", {
                        Transparency = 1,
                        Thickness = 1,
                        Radius = radius / 2,
                        Visible = _G.Visible,
                        Color = (_G.AimLock and green) or white,
                        Position = lock_part.scr_pos,
                        instance = "Circle";
                    })

                    if Using then
                        mousemoverel((lock_part.scr_pos.X - mouse.X) / aimsp_settings.smoothness, (lock_part.scr_pos.Y - (mouse.Y)) / aimsp_settings.smoothness)
                    end
                else
                    utility.update_drawing(objects.look_at, "point", {
                        Visible = false,
                        instance = "Circle";
                    })
                end
            end
        end)
        if not func then --[[warn(result)]] end
    end
end)()