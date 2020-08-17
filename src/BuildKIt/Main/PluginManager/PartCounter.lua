local PluginManager = require(script.Parent)
local Settings = require(script.Parent.Settings)

local GUI, yielded

local function getPartCount()
	local parts = 0
	local instances = 0
	
	for i, p in pairs(workspace:GetDescendants()) do
		if i%Settings.PartCountYield == 0 then
			game["Run Service"].Heartbeat:Wait()
		end
		if not p:FindFirstAncestorOfClass("Camera") then
			if p:IsA("BasePart") then
				parts = parts + 1
			end
			instances = instances + 1
		end
	end
	
	local voxels = workspace.Terrain:CountCells()
	
	return parts, instances, voxels
end

local PartCounter = {}

function PartCounter:run()
	GUI = PluginManager:getGUI().Scroll.PartCount
	
	GUI.Toggle.MouseButton1Click:Connect(function()
		if not yielded then
			yielded = true
			GUI.Toggle.Text = "Getting Data"
			
			local parts, instances, voxels = getPartCount()
			GUI.Parts.Text = "Parts: "..parts
			GUI.Instances.Text = "Instances: "..instances
			GUI.Voxels.Text = "Terrain Voxels: "..voxels
			
			yielded = false
			GUI.Toggle.Text = "Refresh"
		end
	end)
	
	return true
end

return PartCounter
