local StudioService = game:GetService("StudioService")

local Settings = require(script.Settings)

local widget, plugin, gui, storage

local PluginManager = {}

function PluginManager:init(_widget, _plugin, _gui, _storage)
	widget = _widget
	plugin = _plugin
	gui = _gui
	storage = _storage
	
	return true
end

function PluginManager:getPlugin()
	return plugin
end

function PluginManager:getMouse()
	return plugin:GetMouse()
end

function PluginManager:getGUI()
	return gui
end

function PluginManager:getStorage()
	return storage
end

function PluginManager:getLocalUserId()
	return StudioService:GetUserId()
end

function PluginManager:getData(key)
	local success, data = pcall(function()
		return plugin:GetSetting(key)
	end)
	if success then
		return data
	else
		return nil
	end
end

function PluginManager:setData(key, value)
	local success = pcall(function()
		plugin:SetSetting(key, value)
	end)
	return success
end

return PluginManager
