local Settings = require(script.Parent.Settings)

local camera = workspace.CurrentCamera

local Utility = {}

function Utility:isAllowedInstance(n)
	return n and ((n:IsA("Model") and n.PrimaryPart) or n:IsA("BasePart") or n:IsA("Attachment"))
end

function Utility:getCFrame(n)
	if n:IsA("Model") then
		return n:GetPrimaryPartCFrame()
	elseif n:IsA("BasePart") or n:IsA("Attachment") then
		return n.CFrame
	end
	return false
end

function Utility:setCFrame(n, cf)
	if n:IsA("Model") then
		n:SetPrimaryPartCFrame(cf)
	elseif n:IsA("BasePart") or n:IsA("Attachment") then
		n.CFrame = cf
	end
end

function Utility:setPosition(mesh, p)
	if mesh:IsA("BasePart") then
		mesh.Position = p
	elseif mesh:IsA("Model") then
		if mesh.PrimaryPart then
			--The primarypart may not be in the center of model meaning the offset math to keep the model
			--from going into the floor will be off. Get the correct CFrame from the center of the model and 
			--get the offset to calculate with primarypart cframe.
			local centerCFrame = mesh:GetBoundingBox()
			local cfOffset = mesh.PrimaryPart.CFrame:ToObjectSpace(centerCFrame):inverse()
			
			mesh:SetPrimaryPartCFrame(CFrame.new(p) * cfOffset * CFrame.Angles(0, math.pi, 0))
		else
			error("Internal_Build_Kit_Error: No Primary Part For Model")
		end
	end
end

function Utility:getSize(mesh)
	if mesh:IsA("BasePart") then
		return mesh.Size
	elseif mesh:IsA("Model") then
		return mesh:GetExtentsSize()
	end
end

function Utility:getMeshData(mesh)
	local isTable = type(mesh) == "table"
	if isTable then
		return mesh[1], mesh[2]
	else
		return mesh, nil
	end
end

function Utility:getMeshObject(meshName)
	if meshName then
		for _, data in pairs(Settings.MeshData) do
			local mesh = Utility:getMeshData(data)
			if mesh.Name == meshName then
				return mesh
			end
		end
	end
	return nil
end

function Utility:placeObjectAtPointFromCamera(mesh, distance)
	if mesh and distance then
		local size = Utility:getSize(mesh) / 2
		local camCF = camera.CFrame
		
		local magnitude = size.Magnitude
		
		local origin = CFrame.new(camCF.p)
		local direction = CFrame.new(camCF.LookVector * distance * (magnitude + 1))
		
		local position
		
		local ray_data = workspace:Raycast(origin.p, direction.p)
		if ray_data then
			local normal = ray_data.Normal
			local offset = normal * size
			position = ray_data.Position + offset
		else
			position = (origin * direction).p
		end
		
		Utility:setPosition(mesh, position)
		return true
	end
	return false
end

return Utility
