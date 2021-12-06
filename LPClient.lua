-- Decompiled with the Synapse X Luau decompiler.

local l__Players__1 = game:GetService("Players");
local l__ReplicatedStorage__2 = game:GetService("ReplicatedStorage");
local l__TweenService__3 = game:GetService("TweenService");
local l__UserInputService__4 = game:GetService("UserInputService");
local l__RunService__5 = game:GetService("RunService");
while true do
	wait();
	if _G.ClientLoaded and _G.WaitForChar and _G.GVF then
		break;
	end;
end;
_G.WaitForChar();
local l__LocalPlayer__6 = l__Players__1.LocalPlayer;
local l__mouse__7 = l__LocalPlayer__6:GetMouse();
local l__Parent__8 = script.Parent;
local v9 = l__LocalPlayer__6.Character or l__LocalPlayer__6.CharacterAdded:Wait();
local l__HumanoidRootPart__10 = v9:WaitForChild("HumanoidRootPart");
local l__Humanoid__11 = v9:WaitForChild("Humanoid");
local l__Handle1__12 = l__Parent__8:WaitForChild("Handle1");
local l__Handle2__13 = l__Parent__8:WaitForChild("Handle2");
local l__Uses__14 = l__Parent__8:WaitForChild("Uses");
local l__Event__15 = l__Parent__8:WaitForChild("Event");
local l__Remote__16 = l__Parent__8:WaitForChild("Remote");
local l__AnimsFolder__17 = l__Parent__8:WaitForChild("AnimsFolder");
local v18 = {
	Equip = l__Humanoid__11:LoadAnimation(l__AnimsFolder__17:WaitForChild("Equip")), 
	Use = l__Humanoid__11:LoadAnimation(l__AnimsFolder__17:WaitForChild("Use"))
};
local l__GUIs__19 = l__ReplicatedStorage__2:WaitForChild("Storage"):WaitForChild("GUIs");
local v20 = l__GUIs__19:WaitForChild("LP_BGUI"):Clone();
table.insert(_G.EffectsList, v20);
local l__Map__21 = workspace:WaitForChild("Map");
local v22 = l__GUIs__19:WaitForChild("LockpickGUI"):Clone();
local l__MF__23 = v22:WaitForChild("MF");
local l__LP_Frame__24 = l__MF__23:WaitForChild("LP_Frame");
function lerp(p1, p2, p3)
	return p1 + (p2 - p1) * p3;
end;
local u1 = false;
function Open()
	v22.Parent = l__LocalPlayer__6.PlayerGui;
	u1 = true;
end;
local u2 = false;
local u3 = nil;
function Close()
	v20.Enabled = false;
	v20.Parent = nil;
	if u2 then
		u2.Enabled = true;
	end;
	if not u1 then
		return;
	end;
	u1 = false;
	v22.Parent = nil;
	if u3 then
		u3:Disconnect();
		u3 = nil;
	end;
end;
local l__Attempts__4 = l__MF__23:WaitForChild("Attempts");
local u5 = l__Uses__14.Value;
local u6 = {};
local l__CurrentCamera__7 = workspace.CurrentCamera;
local function u8(p4, p5, p6, p7, p8, p9)
	local v25, v26 = workspace:FindPartOnRayWithWhitelist(Ray.new(p4, (p5.Position - p4).Unit * p6), p7, true);
	local v27 = true;
	if v25 ~= p5 then
		v27 = p8 and v25 and v25:IsDescendantOf(p5) or p9 and (v25 and v25:IsDescendantOf(p5.Parent));
	end;
	return v27;
end;
local u9 = nil;
local u10 = nil;
local u11 = 0;
local u12 = nil;
local u13 = {};
local l__Frames__14 = l__LP_Frame__24:WaitForChild("Frames");
local u15 = false;
local function u16()
	local v28 = 0;
	for v29, v30 in pairs(l__Attempts__4:GetChildren()) do
		if v30:IsA("ImageLabel") then
			local v31 = v28 < u5;
			v30.Visible = v31;
			if v31 then
				v28 = v28 + 1;
			end;
		end;
	end;
end;
local function u17(p10, p11)
	local l__AbsolutePosition__32 = p10.AbsolutePosition;
	local v33 = l__AbsolutePosition__32 + p10.AbsoluteSize;
	local l__AbsolutePosition__34 = p11.AbsolutePosition;
	local v35 = l__AbsolutePosition__34 + p11.AbsoluteSize;
	local v36 = false;
	if l__AbsolutePosition__32.x < v35.x then
		v36 = false;
		if l__AbsolutePosition__34.x < v33.x then
			v36 = false;
			if l__AbsolutePosition__32.y < v35.y then
				v36 = l__AbsolutePosition__34.y < v33.y;
			end;
		end;
	end;
	return v36;
end;
local l__Line__18 = l__LP_Frame__24:WaitForChild("Line");
function MainHandler(p12)
	if u1 then
		return;
	end;
	local v37 = l__Remote__16:InvokeServer("S", u9, u10);
	if not v37 then
		return;
	end;
	u11 = v37;
	if u3 then
		u3:Disconnect();
		u3 = nil;
	end;
	if u12 then
		u12:Cancel();
		u12 = nil;
	end;
	l__LP_Frame__24.BackgroundColor3 = Color3.new(1, 1, 1);
	Open();
	local u19 = {};
	local u20 = nil;
	local u21 = nil;
	local function u22()
		u3:Disconnect();
		if u12 then
			u12:Cancel();
			u12 = nil;
		end;
		l__LP_Frame__24.BackgroundColor3 = Color3.new(1, 1, 1);
		u12 = l__TweenService__3:Create(l__LP_Frame__24, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
			BackgroundColor3 = Color3.new(1, 0, 0), 
			BackgroundTransparency = 0.8
		});
		u12:Play();
		local v38, v39, v40 = pairs(u19);
		while true do
			local v41, v42 = v38(v39, v40);
			if v41 then

			else
				break;
			end;
			if u13[v42] then
				u13[v42]:Cancel();
				u13[v42] = nil;
			end;
			if v42 == u21 then
				v42.Bar.Selection.ImageColor3 = Color3.fromRGB(255, 50, 50);
				v42.Bar.ImageColor3 = Color3.fromRGB(255, 50, 50);
				l__TweenService__3:Create(v42.Bar.Selection, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {
					ImageColor3 = Color3.fromRGB(143, 143, 143)
				}):Play();
				l__TweenService__3:Create(v42.Bar, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {
					ImageColor3 = Color3.fromRGB(143, 143, 143)
				}):Play();
			else
				v42.Bar.Selection.ImageColor3 = Color3.fromRGB(143, 143, 143);
				v42.Bar.ImageColor3 = Color3.fromRGB(143, 143, 143);
			end;		
		end;
		wait(1);
		Close();
	end;
	local function u23()
		local function v43(p13, p14)
			local l__Bar__44 = p13.Bar;
			if u13[p13] then
				u13[p13]:Cancel();
				u13[p13] = nil;
			end;
			if u13[p13.Bar.Selection] then
				u13[p13.Bar.Selection]:Cancel();
				u13[p13.Bar.Selection] = nil;
			end;
			local l__Value__45 = l__Bar__44.PosV.Value;
			l__Bar__44.Position = UDim2.new(l__Bar__44.Position.X.Scale, l__Bar__44.Position.X.Offset, l__Bar__44.Position.Y.Scale, -l__Value__45);
			local v46 = l__TweenService__3:Create(l__Bar__44, TweenInfo.new(p14, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, math.huge, true), {
				Position = UDim2.new(l__Bar__44.Position.X.Scale, l__Bar__44.Position.X.Offset, l__Bar__44.Position.Y.Scale, l__Value__45)
			});
			u13[p13] = v46;
			v46:Play();
		end;
		local v47 = 1 - 1;
		while true do
			local v48 = l__Frames__14["B" .. v47];
			table.insert(u19, v48);
			v48.Visible = true;
			v48.Bar.ImageColor3 = Color3.new(1, 1, 1);
			if v47 == 1 then
				v48.Bar.ImageColor3 = Color3.new(0, 1, 0);
			else
				v48.Bar.ImageColor3 = Color3.new(1, 1, 1);
			end;
			local v49 = 0.5;
			if v47 == 2 then
				v49 = 0.45;
			elseif v47 == 3 then
				v49 = 0.4;
			end;
			v43(v48, v49);
			if 0 <= 1 then
				if v47 < p12 then

				else
					break;
				end;
			elseif p12 < v47 then

			else
				break;
			end;
			v47 = v47 + 1;		
		end;
		u20 = 1;
		u21 = u19[u20];
	end;
	local function u24()
		u15 = true;
		delay(2, function()
			u15 = false;
		end);
		v18.Use:Play();
		u3:Disconnect();
		l__Remote__16:InvokeServer("D", u9, u10, u11);
		local v50, v51, v52 = pairs(l__Attempts__4:GetChildren());
		while true do
			local v53, v54 = v50(v51, v52);
			if v53 then

			else
				break;
			end;
			v52 = v53;
			if v54:IsA("ImageLabel") then
				v54.Visible = false;
			end;		
		end;
		if u12 then
			u12:Cancel();
			u12 = nil;
		end;
		l__LP_Frame__24.BackgroundColor3 = Color3.new(1, 1, 1);
		u12 = l__TweenService__3:Create(l__LP_Frame__24, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
			BackgroundColor3 = Color3.new(0, 1, 0), 
			BackgroundTransparency = 0.8
		});
		u12:Play();
		wait(1);
		Close();
	end;
	u5 = l__Uses__14.Value;
	u23();
	wait();
	if u1 then
		local u25 = false;
		local function u26(p15)
			u21.Bar.ImageColor3 = Color3.fromRGB(100, 255, 100);
			u21.Bar.Selection.ImageColor3 = Color3.fromRGB(100, 255, 100);
			if u13[u21] then
				u13[u21]:Cancel();
			end;
			u13[u21] = l__TweenService__3:Create(u21.Bar, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {
				ImageColor3 = Color3.fromRGB(143, 143, 143)
			});
			u13[u21]:Play();
			if u13[u21.Bar.Selection] then
				u13[u21.Bar.Selection]:Cancel();
			end;
			u13[u21.Bar.Selection] = l__TweenService__3:Create(u21.Bar.Selection, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {
				ImageColor3 = Color3.fromRGB(143, 143, 143)
			});
			u13[u21.Bar.Selection]:Play();
			u21.Bar.Position = p15;
			if p12 <= u20 then
				u24();
				return;
			end;
			if u12 then
				u12:Cancel();
				u12 = nil;
			end;
			l__LP_Frame__24.BackgroundColor3 = Color3.new(1, 1, 1);
			u12 = l__TweenService__3:Create(l__LP_Frame__24, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, true), {
				BackgroundColor3 = Color3.new(0, 1, 0), 
				BackgroundTransparency = 0.8
			});
			u12:Play();
			u20 = u20 + 1;
			u21 = u19[u20];
		end;
		local function u27()
			u5 = u5 + 1;
			spawn(function()
				l__Remote__16:InvokeServer("E");
			end);
			v18.Use:Play();
			u16();
			if l__Uses__14.MaxValue <= u5 then
				u22();
				return;
			end;
			if u12 then
				u12:Cancel();
				u12 = nil;
			end;
			l__LP_Frame__24.BackgroundColor3 = Color3.new(1, 1, 1);
			u12 = l__TweenService__3:Create(l__LP_Frame__24, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, true), {
				BackgroundColor3 = Color3.new(1, 0, 0), 
				BackgroundTransparency = 0.8
			});
			u12:Play();
			local v55, v56, v57 = pairs(u19);
			while true do
				local v58, v59 = v55(v56, v57);
				if v58 then

				else
					break;
				end;
				if u13[v59] then
					u13[v59]:Cancel();
					u13[v59] = nil;
				end;
				if v59 == u21 then
					v59.Bar.Selection.ImageColor3 = Color3.fromRGB(255, 50, 50);
					v59.Bar.ImageColor3 = Color3.fromRGB(255, 50, 50);
					l__TweenService__3:Create(v59.Bar.Selection, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {
						ImageColor3 = Color3.fromRGB(255, 255, 255)
					}):Play();
					l__TweenService__3:Create(v59.Bar, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {
						ImageColor3 = Color3.fromRGB(255, 255, 255)
					}):Play();
				else
					v59.Bar.Selection.ImageColor3 = Color3.fromRGB(255, 255, 255);
					v59.Bar.ImageColor3 = Color3.fromRGB(255, 255, 255);
				end;			
			end;
			u23();
		end;
		u3 = l__UserInputService__4.InputBegan:Connect(function(p16, p17)
			if not p17 then
				if u25 then
					return;
				end;
			else
				return;
			end;
			if p16.UserInputType == Enum.UserInputType.MouseButton1 then
				if u17(l__Line__18, u21.Bar) then

				else
					u27();
					u25 = true;
					delay(0.25, function()
						u25 = false;
					end);
					return;
				end;
			else
				return;
			end;
			u26(u21.Bar.Position);
			u25 = true;
			delay(0.25, function()
				u25 = false;
			end);
		end);
	end;
end;
local u28 = false;
local function u29()
	local v60, v61 = (function()
		if not l__HumanoidRootPart__10 or not l__HumanoidRootPart__10.Parent then
			return;
		end;
		local v62 = workspace:FindPartsInRegion3WithWhiteList(Region3.new(l__HumanoidRootPart__10.Position - Vector3.new(4, 2, 4), l__HumanoidRootPart__10.Position + Vector3.new(4, 2, 4)), u6, 30);
		if #v62 <= 0 then
			return;
		end;
		local v63 = "";
		local v64 = nil;
		local v65 = math.huge;
		local v66, v67, v68 = pairs(v62);
		while true do
			local v69, v70 = v66(v67, v68);
			if not v69 then
				break;
			end;
			if v70:IsDescendantOf(workspace.Map.Doors) then
				local v71 = "d";
			else
				v71 = "s";
			end;
			local l__Magnitude__72 = (l__HumanoidRootPart__10.Position - (v71 == "d" and v70.Parent.DoorBase or v70).CFrame.Position).Magnitude;
			if l__Magnitude__72 < v65 then
				v65 = l__Magnitude__72;
				v64 = v70;
				v63 = v71;
			end;		
		end;
		if not v64 then
			return nil;
		end;
		if v63 ~= "d" then
			return v64.Parent, v63;
		end;
		if v64.Parent:FindFirstChild("IsGarageDoor") or v64.Parent:FindFirstChild("IsElevator1") then
			return nil;
		end;
		if not v64.Parent:FindFirstChild("Knob1") then
			return;
		end;
		local v73 = false;
		if (function(p18, p19)
			if (p18.P.WorldPosition - l__HumanoidRootPart__10.Position).Magnitude < (p19.P.WorldPosition - l__HumanoidRootPart__10.Position).Magnitude then
				return p18;
			end;
			return p19;
		end)(v64.Parent.Knob1, v64.Parent.Knob2) == v64.Parent.Knob2 then
			v73 = v64.Parent;
		end;
		return v73, v63;
	end)();
	if v60 then
		local v74 = v61 == "d" and v60.Knob2 or v60.PosPart;
		local v75, v76 = l__CurrentCamera__7:WorldToScreenPoint(v74.Position);
		if v76 or u1 then
			if (Vector2.new(l__mouse__7.X, l__mouse__7.Y) - Vector2.new(v75.X, v75.Y)).Magnitude > 100 and not u1 then
				return;
			end;
			if u8(l__HumanoidRootPart__10.Position, v74, 4, { workspace.Map }) then
				return v60, v61;
			end;
		end;
	end;
	return nil;
end;
local u30 = false;
local l__Doing__31 = l__Parent__8:WaitForChild("Doing");
l__Parent__8.Equipped:Connect(function()
	u28 = true;
	l__Parent__8.Tool6D1.Part0 = v9["Right Arm"];
	l__Parent__8.Tool6D2.Part0 = v9["Left Arm"];
	v18.Equip:Play();
	u5 = l__Uses__14.Value;
	u16();
	while u28 do
		wait();
		if l__Uses__14.MaxValue <= u5 and not u1 then
			break;
		end;
		if _G.CheckIfCan(v9, "Any") and not _G.CheckIfFlinching(v9, true) then
			local v77, v78 = u29();
			u9 = v77;
			u10 = v78;
			local v79 = u9 and u9.Values;
			if u10 == "d" then
				if u9 and not v79.Broken.Value and v79.Locked.Value and not v79.CantLockpick.Value then
					v20.Frame.ImageLabel.ImageTransparency = 0;
					v20.Frame.ImageLabel.Visible = true;
					if not u15 and v79.CanLock.Value and not v79.Busy.Value and not v79.Busy2.Value and not v79.Busy2_5.Value then
						v20.Frame.Label.TextColor3 = Color3.new(0, 1, 0);
						v20.Frame.ImageLabel.ImageColor3 = Color3.new(0, 1, 0);
						u30 = true;
					else
						v20.Frame.Label.TextColor3 = Color3.new(0.65, 0.65, 0.65);
						v20.Frame.ImageLabel.ImageColor3 = Color3.new(0.65, 0.65, 0.65);
						u30 = false;
					end;
					v20.StudsOffset = Vector3.new(0, -0.55, 0);
					v20.Parent = l__CurrentCamera__7;
					v20.Adornee = u9.Knob2;
					v20.Enabled = not u1;
				else
					v20.Parent = nil;
					v20.Enabled = false;
					u9 = nil;
					u30 = false;
				end;
			elseif u9 and not v79.Broken.Value and u9.Type.Value > 1 then
				u2 = u9.PosPart.BGUI;
				v20.Frame.ImageLabel.ImageTransparency = 0;
				v20.Frame.ImageLabel.Visible = true;
				if not u15 then
					v20.Frame.Label.TextColor3 = Color3.new(0, 1, 0);
					v20.Frame.ImageLabel.ImageColor3 = Color3.new(0, 1, 0);
					u30 = true;
				else
					v20.Frame.Label.TextColor3 = Color3.new(0.65, 0.65, 0.65);
					v20.Frame.ImageLabel.ImageColor3 = Color3.new(0.65, 0.65, 0.65);
					u30 = false;
				end;
				v20.StudsOffset = Vector3.new(0, 0, 0);
				v20.Parent = l__CurrentCamera__7;
				v20.Adornee = u9.PosPart;
				v20.Enabled = not u1;
				u2.Enabled = false;
			else
				v20.Parent = nil;
				v20.Enabled = false;
				u9 = nil;
				u30 = false;
				if u2 then
					u2.Enabled = true;
				end;
			end;
		else
			v20.Parent = nil;
			v20.Enabled = false;
			u9 = nil;
			u30 = false;
			if u2 then
				u2.Enabled = true;
			end;
		end;
		if not u30 then
			Close();
			if l__Doing__31.Value then
				l__Doing__31.Value = nil;
				spawn(function()
					l__Remote__16:InvokeServer("C");
				end);
			end;
		end;	
	end;
	Close();
end);
l__Parent__8.Unequipped:Connect(function()
	u28 = false;
	u30 = false;
	Close();
end);
l__Parent__8.Activated:Connect(function()
	if u28 and not u1 and u5 < 30 and u9 and u30 then
		MainHandler(u9.Values.LockpickBars.Value, u9);
	end;
end);
(function()
	local function v80(p20)
		if not p20:WaitForChild("DFrame", 2) then
			warn("No DFrame in door!");
			return;
		end;
		local l__DFrame__81 = p20.DFrame;
		table.insert(u6, l__DFrame__81);
		local u32 = nil;
		u32 = l__DFrame__81.AncestryChanged:Connect(function(p21, p22)
			if not p22 then
				for v82, v83 in pairs(u6) do
					if v83 == l__DFrame__81 then
						table.remove(u6, v82);
					end;
				end;
				u32:Disconnect();
			end;
		end);
	end;
	for v84, v85 in pairs(l__Map__21.Doors:GetChildren()) do
		v80(v85);
	end;
	l__Map__21.Doors.ChildAdded:Connect(v80);
	local function v86(p23)
		if not p23:WaitForChild("MainPart", 2) then
			warn("No DFrame in door!");
			return;
		end;
		local l__MainPart__87 = p23.MainPart;
		table.insert(u6, l__MainPart__87);
		local u33 = nil;
		u33 = l__MainPart__87.AncestryChanged:Connect(function(p24, p25)
			if not p25 then
				for v88, v89 in pairs(u6) do
					if v89 == l__MainPart__87 then
						table.remove(u6, v88);
					end;
				end;
				u33:Disconnect();
			end;
		end);
	end;
	for v90, v91 in pairs(l__Map__21.BredMakurz:GetChildren()) do
		v86(v91);
	end;
	l__Map__21.BredMakurz.ChildAdded:Connect(v86);
end)();
