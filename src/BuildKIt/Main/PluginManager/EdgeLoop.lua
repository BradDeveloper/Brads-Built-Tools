local PluginManager = require(script.Parent)
local Utility = require(script.Parent.Utility)
local Settings = require(script.Parent.Settings)

local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")

local GUI, storage

local selectEvent = nil
local visual = nil
local start = nil
local goal = nil

local EdgeLoop = {}

local function verify()
	return Utility:isAllowedInstance(start) and Utility:isAllowedInstance(goal)
end

local function drawVisual()
	local len = tonumber(GUI.Loops.Text)
	if len and len > 0 and verify() then
		len = math.clamp(len, 1, Settings.EdgeLoopCap)
		
		visual:ClearAllChildren()
		
		local points, gap = EdgeLoop:drawLoop(len)
		for _, point in pairs(points) do
			point.Name = "VISUAL"
			if point:IsA("Model") then
				for _, p in pairs(point:GetDescendants()) do
					if p:IsA("BasePart") then
						p.Transparency = 0.75
						p.Locked = true
					end
				end
			elseif point:IsA("BasePart") then
				point.Transparency = 0.75
				point.Locked = true
			end
			if visual then
				point.Parent = visual
			end
		end
		
		GUI.Gap.Text = ("Gap: %s studs"):format(tostring(gap))
	else
		GUI.Gap.Text = ""
	end
end

function EdgeLoop:drawLoop(len)
	local tab = {}
	local gap = 0
	if start and goal and len then
		local step = 1 / (len + 1)
		
		local a = Utility:getCFrame(start)
		local b = Utility:getCFrame(goal)
		if a and b then
			for t = step, 1, step do
				if t >= 0.99 then continue end
				
				local cf = a:lerp(b,t)
				local p = start:Clone()
				
				Utility:setCFrame(p, cf)
				
				table.insert(tab, p)
			end
		end
		
		if #tab > 0 then
			local vector = (a.p - Utility:getCFrame(tab[1]).p)
			gap = vector.magnitude
		end
	end
	
	return tab, gap
end

function EdgeLoop:setEnabled(toggle)
	if toggle then
		visual = storage:FindFirstChild("EDGE_LOOP_VISUALIZER")
		if not visual then
			visual = Instance.new("Folder")
			visual.Name = "EDGE_LOOP_VISUALIZER"
			visual.Archivable = false
			visual.Parent = storage
		end
			
		local get = Selection:Get()
		start = get[1]
		goal = get[2]
		
		selectEvent = Selection.SelectionChanged:Connect(function()
			local get = Selection:Get()
			start = get[1]
			goal = get[2]
			
			if start and goal then
				drawVisual()
			else
				visual:ClearAllChildren()
				GUI.Gap.Text = ""
			end
		end)
		drawVisual()
	else
		if selectEvent then
			selectEvent:Disconnect()
		end
		if visual then
			visual:Destroy()
			visual = nil
		end
	end
end

function EdgeLoop:run()
	GUI = PluginManager:getGUI().Scroll.Edge
	storage = PluginManager:getStorage()
	
	GUI.Loops:GetPropertyChangedSignal("Text"):Connect(function()
		drawVisual()
	end)
	
	GUI.Draw.MouseButton1Click:Connect(function()
		local len = tonumber(GUI.Loops.Text)
		if len and verify() then
			len = math.clamp(len, 1, Settings.EdgeLoopCap)
			
			ChangeHistoryService:SetWaypoint("Edge Loop Start")
			local points = EdgeLoop:drawLoop(len)
			for _, point in pairs(points) do
				point.Parent = start.Parent
			end
			ChangeHistoryService:SetWaypoint("Edge Loop End")
		else
			warn("edge loop failed. make sure you are selecting two models, parts, or attachments")
		end
	end)
	
	return true
end

return EdgeLoop