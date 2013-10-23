
local mapscale = 0.15
local x_pos = -235
local y_pos = -25

----------------------------------------
-- Do the stuff
----------------------------------------

local require = GLOBAL.require
local GetWorld = GLOBAL.GetWorld

local function AddMiniMap( inst )

	-- for some reason, without this the game would crash without an error when calling controls.topright_root:AddChild
	-- too lazy to track down the cause, so just using this workaround
	inst:DoTaskInTime( 0, function() 

		-- add the minimap widget and set its position
		local MiniMapWidget = require "widgets/minimapwidget"

		local controls = inst.HUD.controls
		controls.minimap_small = controls.topright_root:AddChild( MiniMapWidget( mapscale ) )
		controls.minimap_small:SetPosition(x_pos - controls.minimap_small.mapsize.w/2, y_pos - controls.minimap_small.mapsize.h/2, 0)

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

		-- special case: ToggleMap gets bypassed when the map gets hidden while on the map screen
		local MapScreen = require "screens/mapscreen"

		MapScreen_OnControl_base = MapScreen.OnControl
		MapScreen.OnControl = function( self, control, down )
			local ret = MapScreen_OnControl_base(self, control, down)

			if ret and control == GLOBAL.CONTROL_MAP then
				controls.minimap_small:Show()
			end

			return ret
		end

		-- keep track of zooming while on the map screen
		local MapWidget = require "widgets/mapwidget"

		MapWidget_OnZoomIn_base = MapWidget.OnZoomIn
		MapWidget.OnZoomIn = function(self)
			MapWidget_OnZoomIn_base( self )
			if self.shown then
				controls.minimap_small.mapscreenzoom = math.max(0,controls.minimap_small.mapscreenzoom-1)
			end
		end

		MapWidget_OnZoomOut_base = MapWidget.OnZoomOut
		MapWidget.OnZoomOut = function(self)
			MapWidget_OnZoomOut_base( self )
			if self.shown then
				controls.minimap_small.mapscreenzoom = controls.minimap_small.mapscreenzoom+1
			end
		end

	end)

end

AddSimPostInit( AddMiniMap )
