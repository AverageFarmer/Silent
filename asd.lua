local ugli = {}

for i, v in pairs(game.Workspace:GetDescendants()) do
	if v:IsA("BasePart") then
		print(typeof(v.BrickColor))
		if v.BrickColor == BrickColor.new("Medium stone gray") then
			table.insert(ugli, v)
		end
	end
end
print(ugli)
game:GetService("Selection"):Set(ugli)