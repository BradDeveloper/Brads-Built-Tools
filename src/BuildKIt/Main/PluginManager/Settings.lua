local MESH_DATA = script
local Settings = {}

--Data Keys Format: "TypeID_Version"
Settings.DataKey_SavedCharUserId = "0_0"
--

Settings.ListColorA = Color3.fromRGB(38, 38, 38)
Settings.ListColorB = Color3.fromRGB(45, 45, 45)

Settings.PartCountYield = 500
Settings.SoundRunYield = 25

Settings.EdgeLoopCap = 1000

Settings.CharThumbnailA = Enum.ThumbnailType.AvatarThumbnail
Settings.CharThumbnailB = Enum.ThumbnailType.AvatarBust
Settings.CharThumbnailSize = Enum.ThumbnailSize.Size180x180
Settings.CharLoadErrorIcon = "rbxasset://textures/ui/ErrorIcon.png"
Settings.CharSpawnRange = 10

Settings.MeshSpawnRange = 10
Settings.MeshData = {
	{MESH_DATA["Full Mesh Kit"], "Mesh Kit"},
	
	MESH_DATA["Part"],
	MESH_DATA["Wedge"],
	MESH_DATA["Corner Wedge"],
	MESH_DATA["Cone"],
	MESH_DATA["Corner Pyramid"],
	MESH_DATA["Inner Slope"],
	MESH_DATA["Corner Slope"],
	MESH_DATA["Outer Slope"],
	MESH_DATA["High Res. Outer Slope"],
	MESH_DATA["Half Cone 0.75"],
	MESH_DATA["Half Cone 0.5"],
	MESH_DATA["Half Cone 0.25"],
	MESH_DATA["Corrugated Metal"],
	MESH_DATA["Half Curve"],
	MESH_DATA["Slope Cap"],
	MESH_DATA["X Slope"],
	MESH_DATA["Large Slope Corner"],
	MESH_DATA["Small Slope Corner"],
	MESH_DATA["Honeycomb"],
	MESH_DATA["Grid A"],
	MESH_DATA["Grid B"],
	MESH_DATA["Box Beam"],
	MESH_DATA["I-Beam A"],
	MESH_DATA["I-Beam B"],
	MESH_DATA["T-Beam A"],
	MESH_DATA["T-Beam B"],
	MESH_DATA["Curve"],
	MESH_DATA["Ico A"],
	MESH_DATA["Ico B"],
	MESH_DATA["Twisted Torus"],
	MESH_DATA["Cone Slope Flat"],
	MESH_DATA["Cone Slope Smooth"],
	
	--Characters
	{MESH_DATA["R15 Default"],   "Dummy"},
	{MESH_DATA["R15 Mesh"], 	 "Dummy"},
	{MESH_DATA["R15 Man"], 		 "Dummy"},
	{MESH_DATA["R15 Woman"], 	 "Dummy"},
	{MESH_DATA["R6 Default"], 	 "Dummy"},
	{MESH_DATA["R6 Mesh"], 		 "Dummy"},
	{MESH_DATA["R6 Man"], 		 "Dummy"},
	{MESH_DATA["R6 Woman"], 	 "Dummy"},
	{MESH_DATA["Rthro Normal"],  "Dummy"},
	{MESH_DATA["Rthro Slender"], "Dummy"},
}

return Settings
