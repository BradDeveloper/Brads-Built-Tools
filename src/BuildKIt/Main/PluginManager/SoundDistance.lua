local PluginManager = require(script.Parent)
local Settings = require(script.Parent.Settings)

local GUI, storage

local visual = nil

local function newBall()
	local p = Instance.new("Part") do
		p.Shape = "Ball"
		p.Anchored = true
		p.Locked = true
		p.Material = Enum.Material.ForceField
		p.Transparency = 0.5
		p.CastShadow = false
	end
	return p
end

local function newSound(s)
	local dist = s.MaxDistance * 2
	local emitSize = s.EmitterSize * 2
	
	local cframe = s.Parent.CFrame
	
	local r = newBall() do
		r.Name = "Distance"
		r.Size = Vector3.new(1, 1, 1) * dist
		r.CFrame = cframe
		r.Color = Color3.new(1, 0, 0)
	end
	local e = newBall() do
		e.Name = "Emitter"
		e.Size = Vector3.new(1, 1, 1) * emitSize
		e.CFrame = cframe
		e.Transparency = 0.25
		e.Color = Color3.new(0, 1, 0)
	end
	
	return r, e
end

local SoundDistance = {}
local enabled = false
local yielded = false

function SoundDistance:setEnabled(toggle)
	enabled = toggle
	if toggle then
		GUI.Toggle.Text = "Getting Data"
		
		visual = storage:FindFirstChild("SOUND_DISTANCE_VISUALIZER")
		if not visual then
			visual = Instance.new("Folder")
			visual.Name = "SOUND_DISTANCE_VISUALIZER"
			visual.Archivable = false
			visual.Parent = storage
		end
		
		for i, p in pairs(workspace:GetDescendants()) do
			if p:IsA("Sound") and (p.Parent:IsA("BasePart") or p.Parent:IsA("Attachment")) then
				if i%Settings.SoundRunYield == 0 then
					game["Run Service"].Heartbeat:Wait()
				end
				
				local a,b = newSound(p)
				a.Parent = visual
				b.Parent = visual
			end
		end
		
		GUI.Toggle.Text = "Toggle Off"
		return true
	else
		if visual then
			visual:Destroy()
			if GUI and GUI:FindFirstChild("Toggle") then
				GUI.Toggle.Text = "Toggle On"
			end
		end
	end
	return false
end

function SoundDistance:run()
	GUI = PluginManager:getGUI().Scroll.Sound
	storage = PluginManager:getStorage()
	
	GUI.Toggle.MouseButton1Click:Connect(function()
		if not yielded then
			yielded = true
			
			enabled = not enabled
			SoundDistance:setEnabled(enabled)
			
			yielded = false
		end
	end)
	
	return true
end

return SoundDistance
