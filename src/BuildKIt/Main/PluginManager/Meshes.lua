local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")

local PluginManager = require(script.Parent)
local Utility = require(script.Parent.Utility)
local Settings = require(script.Parent.Settings)

local camera = workspace.CurrentCamera

return function()
	local GUI = PluginManager:getGUI()
	local ui_mesh = GUI.Scroll:WaitForChild("Mesh")
	
	local cl = ui_mesh.List.ITEM_CLONE
	for index, mesh in pairs(Settings.MeshData) do
		local partMesh, customName = Utility:getMeshData(mesh)
		local partName = partMesh.Name
		
		local frame = cl:Clone()
		frame.Visible = true
		frame.Name = index
		frame.LayoutOrder = index
		frame.Text.Text = partName
		
		local color = index % 2 == 0 and Settings.ListColorA or Settings.ListColorB
		frame.BackgroundColor3 = color
		frame.Text.BackgroundColor3 = color
		
		local size = Utility:getSize(partMesh) / 2
		
		--setup viewport
		local vpart = partMesh:Clone()
		Utility:setPosition(vpart, Vector3.new())
		vpart.Parent = frame.Viewport
		
		local vcam = Instance.new("Camera")
		local magnitude = size.magnitude
		local offset = Vector3.new(1, 1, 1) * magnitude
		vcam.CFrame = CFrame.new(offset, Vector3.new())
		
		frame.Viewport.CurrentCamera = vcam
		--
		
		frame.Parent = ui_mesh.List
		
		frame.Button.MouseButton1Click:Connect(function()
			ChangeHistoryService:SetWaypoint("New Mesh")
			local p = partMesh:Clone()

			Utility:placeObjectAtPointFromCamera(p, Settings.MeshSpawnRange)
			
			p.Name = customName or "Part"
			p.Parent = workspace
			
			Selection:Set({p})
			
			ChangeHistoryService:SetWaypoint("New Mesh")
		end)
	end
	
	ui_mesh.List.CanvasSize = UDim2.fromOffset(0, #Settings.MeshData * cl.AbsoluteSize.Y)
end