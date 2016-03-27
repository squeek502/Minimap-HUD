local mapscale = GetModConfigData("Minimap Size")
local position_str = GetModConfigData("Position")
local margin_size_x = GetModConfigData("Horizontal Margin")
local margin_size_y = GetModConfigData("Vertical Margin")
local ups = GetModConfigData("Updates Per Second")

local dir_vert = 0
local dir_horiz = 0
local anchor_vert = 0
local anchor_horiz = 0
local margin_dir_vert = 0
local margin_dir_horiz = 0
local y_align, x_align = position_str:match("(%a+)_(%a+)")

if x_align == "left" then
	dir_horiz = -1
	anchor_horiz = 1
	margin_dir_horiz = 1
elseif x_align == "center" then
	dir_horiz = 0
	anchor_horiz = 0
	margin_dir_horiz = 0
elseif x_align == "right" then
	dir_horiz = 1
	anchor_horiz = -1
	margin_dir_horiz = -1
end

if y_align == "top" then
	dir_vert = 0
	anchor_vert = -1
	margin_dir_vert = -1
elseif y_align == "middle" then
	dir_vert = -1
	anchor_vert = 0
	margin_dir_vert = 0
elseif y_align == "bottom" then
	dir_vert = -2
	anchor_vert = 1
	margin_dir_vert = 1
end

----------------------------------------
-- Do the stuff
----------------------------------------

local require = GLOBAL.require

local function PositionMiniMap(controls, screensize)
	local hudscale = controls.top_root:GetScale()
	local screenw_full, screenh_full = GLOBAL.unpack(screensize)
	local screenw = screenw_full/hudscale.x
	local screenh = screenh_full/hudscale.y
	controls.minimap_small:SetPosition(
		(anchor_horiz*controls.minimap_small.mapsize.w/2)+(dir_horiz*screenw/2)+(margin_dir_horiz*margin_size_x), 
		(anchor_vert*controls.minimap_small.mapsize.h/2)+(dir_vert*screenh/2)+(margin_dir_vert*margin_size_y), 
		0
	)
end

-- holds the minimap widget once its added to the controls widget
local minimap_small = nil

-- create a minimap widget as a child of the controls widget
local function AddMiniMap(controls)

	-- for some reason, without this the game would crash without an error when calling controls.topright_root:AddChild
	-- too lazy to track down the cause, so just using this workaround
	controls.inst:DoTaskInTime( 0, function()

		-- add the minimap widget and set its position
		local MiniMapWidget = require "widgets/minimapwidget"

		controls.minimap_small = controls.top_root:AddChild( MiniMapWidget( mapscale ) )
		local screensize = {GLOBAL.TheSim:GetScreenSize()}
		PositionMiniMap(controls, screensize)

		local OnUpdate_base = controls.OnUpdate
		controls.OnUpdate = function(self, dt)
			OnUpdate_base(self, dt)
			local curscreensize = {GLOBAL.TheSim:GetScreenSize()}
			if curscreensize[1] ~= screensize[1] or curscreensize[2] ~= screensize[2] then
				PositionMiniMap(controls, curscreensize)
				screensize = curscreensize
			end
		end

		-- show and hide the minimap whenever the map gets toggled
		local ToggleMap_base = controls.ToggleMap
		controls.ToggleMap = function( self )
			local wasvisible = controls.minimap_small:IsVisible()

			if wasvisible then
				controls.minimap_small:Hide()
			end

			ToggleMap_base( self )

			if not wasvisible then
				controls.minimap_small:Show()
			end
		end

		controls.minimap_small:SetUPS(ups)

		minimap_small = controls.minimap_small

	end)

end

AddClassPostConstruct( "widgets/controls", AddMiniMap )

-- special case: ToggleMap gets bypassed when the map gets hidden while on the map screen
local MapScreen = require "screens/mapscreen"

MapScreen_OnControl_base = MapScreen.OnControl
MapScreen.OnControl = function( self, control, down )
	local ret = MapScreen_OnControl_base(self, control, down)

	if minimap_small and ret and (control == GLOBAL.CONTROL_MAP or control == GLOBAL.CONTROL_CANCEL) then
		minimap_small:Show()
	end

	return ret
end

-- keep track of zooming while on the map screen
local MapWidget = require "widgets/mapwidget"

MapWidget_OnZoomIn_base = MapWidget.OnZoomIn
MapWidget.OnZoomIn = function(self)
	MapWidget_OnZoomIn_base( self )
	if minimap_small and self.shown then
		minimap_small.mapscreenzoom = math.max(0,minimap_small.mapscreenzoom-1)
	end
end

MapWidget_OnZoomOut_base = MapWidget.OnZoomOut
MapWidget.OnZoomOut = function(self)
	MapWidget_OnZoomOut_base( self )
	if minimap_small and self.shown then
		minimap_small.mapscreenzoom = minimap_small.mapscreenzoom+1
	end
end
