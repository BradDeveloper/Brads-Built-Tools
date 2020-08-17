local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Players = game:GetService("Players")

local PluginManager = require(script.Parent)
local Utility = require(script.Parent.Utility)
local Settings = require(script.Parent.Settings)

local GUI, setUser

local function getUsernameFromUserId(userid)
	return pcall(function()
		return Players:GetNameFromUserIdAsync(userid or setUser)
	end)
end

local function getThumbnail(typ)
	return setUser and Players:GetUserThumbnailAsync(setUser, typ, Settings.CharThumbnailSize)
end

local function updateUserData()
	local a = getThumbnail(Settings.CharThumbnailA)
	local b = getThumbnail(Settings.CharThumbnailB)
	if setUser and a and b then
		GUI.IconA.Image = a
		GUI.IconB.Image = b
	else
		GUI.IconA.Image = Settings.CharLoadErrorIcon
		GUI.IconB.Image = Settings.CharLoadErrorIcon
	end
end

local CharacterImport = {}
CharacterImport.SavedCharacters = {}--cache new and old existing characters saved

function CharacterImport:removeSavedChar(id)
	local index = table.find(CharacterImport.SavedCharacters, id)
	if index then
		table.remove(CharacterImport.SavedCharacters, index)
		
		local frame = GUI.List:FindFirstChild("Char_"..id)
		if frame then
			frame:Destroy()
		end
		for i, ui in pairs(GUI.List:GetChildren()) do
			if ui:IsA("Frame") and ui.Visible == true then
				local color = (i-1) % 2 == 0 and Settings.ListColorA or Settings.ListColorB
				ui.BackgroundColor3 = color
				ui.Button.BackgroundColor3 = color
			end
		end
		
		GUI.List.CanvasSize = UDim2.fromOffset(0, GUI.List.UIListLayout.AbsoluteContentSize.Y)
	else
		print("Internal_Build_Kit_Error: Failed to remove saved character")
	end
end

function CharacterImport:newSavedChar(id, user)
	local success, username
	if user then
		success = true
		username = user
	else
		success, username = getUsernameFromUserId(id)
	end
	
	local frame = GUI.List.ITEM_CLONE:Clone()
	
	frame.Visible = true
	frame.Name = "Char_"..id
	
	local color = (#GUI.List:GetChildren()-2) % 2 == 0 and Settings.ListColorA or Settings.ListColorB
	frame.BackgroundColor3 = color
	frame.Button.BackgroundColor3 = color
	
	if success then
		frame.Button.Text = username
	else
		frame.Button.Text = id
	end
	
	frame.Parent = GUI.List
	
	frame.Button.MouseButton1Click:Connect(function()
		GUI.User.Text = username
	end)
	
	frame.Rem.MouseButton1Click:Connect(function()
		CharacterImport:removeSavedChar(id)
	end)
	
	GUI.List.CanvasSize = UDim2.fromOffset(0, GUI.List.UIListLayout.AbsoluteContentSize.Y)
	return true
end

function CharacterImport:importRig(isR6)
	if setUser and isR6 ~= nil then
		local description = Players:GetHumanoidDescriptionFromUserId(setUser)
		if description then
			ChangeHistoryService:SetWaypoint("New Character")			
			local model = isR6 and Utility:getMeshObject("R6 Default"):Clone() or Utility:getMeshObject("R15 Default"):Clone()
			local humanoid = model:FindFirstChildOfClass("Humanoid")
			
			model.Name = "Character"
			model.Parent = game.ReplicatedStorage--place character in datamodel
			
			--remove faces
			if description.Face ~= 0 then
				for _, p in pairs(model.Head:GetChildren()) do
					if p:IsA("Decal") then
						p:Destroy()
					end
				end
			end
			--
			
			humanoid:ApplyDescription(description)
			
			model.Parent = workspace--place character in-game
			Utility:placeObjectAtPointFromCamera(model, Settings.CharSpawnRange)
			
			ChangeHistoryService:SetWaypoint("New Character")
			return true
		end
	end
end

function CharacterImport:run()
	GUI = PluginManager:getGUI().Scroll.Character
	
	GUI.User:GetPropertyChangedSignal("Text"):Connect(function()
		local text = GUI.User.Text
		if not text:match("%s") then
			if text:len() >= 3 and text:match("%a+") then--a username
				local success, userid = pcall(function()
					return Players:GetUserIdFromNameAsync(text)
				end)
				if success then
					setUser = userid
					updateUserData()
				else
					setUser = nil
					GUI.IconA.Image = Settings.CharLoadErrorIcon
					GUI.IconB.Image = Settings.CharLoadErrorIcon	
				end
			else
				setUser = tonumber(text)
				updateUserData()
			end
		end
	end)
	
	--save/load character options
	--(wrapped to prevent yielding of the plugin when loading settings)
	coroutine.wrap(function()
		CharacterImport.SavedCharacters = PluginManager:getData(Settings.DataKey_SavedCharUserId) or {}
		
		for _, userid in pairs(CharacterImport.SavedCharacters) do
			CharacterImport:newSavedChar(userid)
		end
		
		GUI.Save.MouseButton1Click:Connect(function()
			local success, username = getUsernameFromUserId()
			if success then--is an actual user
				if not table.find(CharacterImport.SavedCharacters, setUser) then
					table.insert(CharacterImport.SavedCharacters, 1, setUser)
					CharacterImport:newSavedChar(setUser, username)
				end
			end
		end)
	end)()
	
	--handle buttons
	GUI.ToggleR6.MouseButton1Click:Connect(function()
		CharacterImport:importRig(true)
	end)
	
	GUI.ToggleR15.MouseButton1Click:Connect(function()
		CharacterImport:importRig(false)
	end)
	
	GUI.User.Text = PluginManager:getLocalUserId()
	
	return true
end

function CharacterImport:saveData()
	PluginManager:setData(Settings.DataKey_SavedCharUserId, CharacterImport.SavedCharacters)
end

return CharacterImport
