-- Decompiled with the Synapse X Luau decompiler.

local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local l__UserInputService__2 = game:GetService("UserInputService");
local l__Players__3 = game:GetService("Players");
local l__RunService__4 = game:GetService("RunService");
while true do
	wait(0.1);
	if _G.GVF and _G.WaitForChar and _G.GVF() then
		break;
	end;
end;
local v5 = _G.GVF();
_G.WaitForChar();
local l__LocalPlayer__6 = l__Players__3.LocalPlayer;
local v7 = l__LocalPlayer__6.Character or l__LocalPlayer__6.CharacterAdded:Wait();
local l__Humanoid__8 = v7:WaitForChild("Humanoid");
local l__HumanoidRootPart__9 = v7:WaitForChild("HumanoidRootPart");
local l__PAZ_TA__10 = l__ReplicatedStorage__1:WaitForChild("Events"):WaitForChild("PAZ_TA");
local l__Parent__11 = script.Parent;
local v12 = l__Parent__11:FindFirstChild(require(l__Parent__11:WaitForChild("PassConfig")).HandleName);
local u1 = false;
local u2 = false;
l__Parent__11.Equipped:Connect(function()
	u1 = true;
	l__RunService__4.Heartbeat:Wait();
	if u1 then
		u2 = true;
	end;
end);
l__Parent__11.Unequipped:Connect(function()
	u1 = false;
	l__RunService__4.Heartbeat:Wait();
	if not u1 then
		u2 = false;
	end;
end);
function RayFunc(p1, p2, p3, p4)
	local v13, v14 = workspace:FindPartOnRayWithIgnoreList(Ray.new(p1, (p2 - p1).Unit * p3), p4, true);
	if v13 then
		if v13.Parent then
			if v13:IsDescendantOf(workspace.Characters) then
				if v13.Name == "HumanoidRootPart" then
					if not v13:IsDescendantOf(workspace.Characters) then
						if not v13:IsDescendantOf(workspace.Map) then
							table.insert(p4, v13);
							return RayFunc(p1, p2, p3, p4);
						end;
					end;
				else
					table.insert(p4, v13);
					return RayFunc(p1, p2, p3, p4);
				end;
			elseif not v13:IsDescendantOf(workspace.Characters) then
				if not v13:IsDescendantOf(workspace.Map) then
					table.insert(p4, v13);
					return RayFunc(p1, p2, p3, p4);
				end;
			end;
		end;
	end;
	return v13, v14;
end;
function TryDrop()
	if _G.GSettings then
		if not _G.GSettings.ToolDropping then
			if not _G.GSettings then
				return true;
			end;
		else
			return true;
		end;
	elseif not _G.GSettings then
		return true;
	end;
	l__ReplicatedStorage__1.Events2.Notification:Fire({
		Title = "Dropping disabled", 
		Text = "This action must be enabled in the settings", 
		Duration = 2
	}, "lost");
	return false;
end;
local u3 = false;
local function u4(p5, p6, p7)
	return p5 + (p6 - p5) * p7;
end;
function TryPass()
	if u2 then
		if _G.CheckIfCan() then
			if not _G.CheckIfFlinching() then
				if not u3 then
					u3 = true;
					if TryDrop() then
						local v15 = _G.YLookVecNUM and 0;
						local l__LookVector__16 = l__HumanoidRootPart__9.CFrame.LookVector;
						local l__Velocity__17 = l__HumanoidRootPart__9.Velocity;
						l__PAZ_TA__10:FireServer(l__Parent__11, nil, l__LookVector__16 * 30 * (1 - math.abs(v15)) + l__LookVector__16 * u4(0, 0, 1 - (v15 - 0.5)) + Vector3.new(l__Velocity__17.X * 0.5, l__Velocity__17.Y * 0.5, l__Velocity__17.Z * 0.5) + Vector3.new(0, 20 + v15 * 30, 0));
					end;
					wait(0.35);
					u3 = false;
				end;
			end;
		end;
	end;
end;
l__UserInputService__2.InputBegan:Connect(function(p8, p9)
	if p9 then
		return;
	end;
	if p8.KeyCode == Enum.KeyCode.Backspace then
		TryPass();
	end;
end);
