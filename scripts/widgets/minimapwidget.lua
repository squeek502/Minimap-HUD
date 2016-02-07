local Widget = require "widgets/widget"
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"

local MiniMapWidget = Class(Widget, function(self, mapscale)
    Widget._ctor(self, "MiniMapWidget")
	self.owner = ThePlayer

	mapscale = mapscale or 1

    self.minimap = TheWorld.minimap.MiniMap

    self.bg = self:AddChild(Image("images/hud.xml", "map.tex"))
	self.bg.inst.ImageWidget:SetBlendMode( BLENDMODE.Premultiplied )

    self.img = self:AddChild(Image())
    self.img.inst.ImageWidget:SetBlendMode( BLENDMODE.Additive )

	self:UpdateTexture()

	local map_w, map_h = self.bg:GetSize()
	local map_w, map_h = map_w*mapscale, map_h*mapscale

	self.mapsize = {w=map_w, h=map_h}

	self.img:SetSize(map_w,map_h,0)
	self.bg:SetSize(map_w,map_h,0)

	self.bg:SetTint(1,1,1,0.75)
	self.bg:SetClickable(false)

    self.togglebutton = self:AddChild(ImageButton())
    self.togglebutton:SetScale(.7,.7,.7)
    self.togglebutton:SetOnClick( function() self:ToggleOpen() end )
    self.togglebutton:Hide()

	-- ups stuff, needs to be before SetOpen()
	self.ups = 0 -- 0 if disabled, otherwise delay till next update
	self.task_ups = nil -- the next update task

    self:SetOpen( true )

	self.mapscreenzoom = 1
	self.minimapzoom = 0
	self.lastpos = nil
	self.uvscale = 1
    
	--self.minimap:ResetOffset()	
	self:StartUpdating()
	self:Show()
end)

function MiniMapWidget:ToggleOpen()
	self:SetOpen( not self:IsOpen() )
end

function MiniMapWidget:SetOpen( state )
	if state == nil then state = true end

	if state then
		self.open = true
		local newbuttonpos = Point(0, -self.mapsize.h/2, 0)
		self.togglebutton.o_pos = newbuttonpos
	    self.togglebutton:SetPosition(newbuttonpos:Get())
	    self.togglebutton:SetText("Close Minimap")
    	self.img:Show()
    	self.bg:SetPosition( 0,0,0 )
    	self.bg:SetSize( self.mapsize.w, self.mapsize.h )
		self:EnableMinimapUpdating()
	else
		self.open = false
		local newbuttonpos = Point(0, self.mapsize.h/2 - 20, 0)
		self.togglebutton.o_pos = newbuttonpos
	    self.togglebutton:SetPosition(newbuttonpos:Get())
    	self.togglebutton:SetText("Open Minimap")
    	self.img:Hide()
    	self.bg:SetPosition( 0, self.mapsize.h/2 - 20, 0 )
    	self.bg:SetSize( self.mapsize.w, 5 )
		self:DisableMinimapUpdating()
	end
end

function MiniMapWidget:IsOpen()
	return self.open
end

function MiniMapWidget:OnControl( control, down )
	if MiniMapWidget._base.OnControl(self, control, down) then return true end
	if down and control == CONTROL_MAP_ZOOM_IN then
		self:OnZoomIn()
		return true
	elseif down and control == CONTROL_MAP_ZOOM_OUT then
		self:OnZoomOut()
		return true
	end
end

function MiniMapWidget:OnGainFocus()
	self.bg:SetTint(1,1,1,1)

	-- horrible way to stop camera zooming, but oh well
	self.camera_controllable_reset = TheCamera:IsControllable()
	TheCamera:SetControllable(false)

	if self:IsOpen() then
		self.togglebutton:Show()
	end
end

function MiniMapWidget:OnLoseFocus()
	self.bg:SetTint(1,1,1,0.75)

	-- reset to orig value
	TheCamera:SetControllable(self.camera_controllable_reset)

	if self:IsOpen() then
		self.togglebutton:Hide()
	end
end

function MiniMapWidget:SetTextureHandle(handle)
	self.img.inst.ImageWidget:SetTextureHandle( handle )
end

function MiniMapWidget:OnZoomIn(  )
    if self.shown then
        if self.minimapzoom == 0 then
            self.uvscale = math.min(1.875, (2.0 + self.uvscale)/2)
        end
        self.img:SetUVScale(self.uvscale, self.uvscale)
        self.minimap:Zoom( -1 )
        self.minimapzoom = math.max(0,self.minimapzoom-1)
    end
end
 
function MiniMapWidget:OnZoomOut( )
    if self.shown then
        local dozoom = true
        if self.minimapzoom == 0 then
            if self.uvscale - 1 > 0.05 then
                self.uvscale = math.max(1, 2*self.uvscale - 2)
                dozoom = false
            else
                self.uvscale = 1
            end
            self.img:SetUVScale(self.uvscale, self.uvscale)
        end
        if dozoom then
            self.minimap:Zoom( 1 )
            self.minimapzoom = self.minimapzoom+1
        end
    end
end

function MiniMapWidget:UpdateTexture()
	local handle = self.minimap:GetTextureHandle()
	self:SetTextureHandle( handle )
end

function MiniMapWidget:OnUpdate(dt)
	if not self.shown then return end
	if not self.focus then return end
	if not self.img.focus then return end

	if TheInput:IsControlPressed(CONTROL_PRIMARY) then
		local pos = TheInput:GetScreenPosition()
		if self.lastpos then
			local scale = 1/(self.uvscale*self.uvscale)
			local dx = scale * ( pos.x - self.lastpos.x )
			local dy = scale * ( pos.y - self.lastpos.y )
			self.minimap:Offset( dx, dy )
		end
		
		self.lastpos = pos
	else
		self.lastpos = nil
	end
end

function MiniMapWidget:Offset(dx,dy)
	self.minimap:Offset(dx,dy)
end

function MiniMapWidget:OnShow()
	if self:IsOpen() then
		self:EnableMinimapUpdating()
	end
	self.minimap:Zoom(-1000)
	self.minimap:Zoom(self.minimapzoom)
	self.minimap:ResetOffset()
end

function MiniMapWidget:OnHide()
	self:DisableMinimapUpdating()
	self.minimap:Zoom(-1000)
	self.minimap:Zoom(self.mapscreenzoom)
end

function MiniMapWidget:ToggleVisibility()
	if self:IsVisible() then
		self:Hide()
	else
		self:Show()
	end
end

function MiniMapWidget:IsMinimapUpdating()
	if self.ups > 0 then
		-- ups throttling enabled
		return self.task_ups ~= nil
	else
		-- ups throttling disabled
		return self.minimap:IsVisible()
	end
end

function MiniMapWidget:EnableMinimapUpdating()
	if self.ups > 0 then
		-- ups throttling enabled
		-- need to check this, function is called twice in succession on startup (on creation and when first shown)
		if self.task_ups ~= nil then
			self.task_ups:Cancel()
			self.task_ups = nil
		end
		self:ScheduleUpdate()
	else
		-- ups throttling disabled
		if not self.minimap:IsVisible() then
			self.minimap:ToggleVisibility()
		end
	end
end

function MiniMapWidget:DisableMinimapUpdating()
	if self.ups > 0 then
		-- ups throttling enabled
		if self.task_ups ~= nil then
			self.task_ups:Cancel()
			self.task_ups = nil
		end
	else
		-- ups throttling disabled
		if self.minimap:IsVisible() then
			self.minimap:ToggleVisibility()
		end
	end
end

-- schedule task starting minimap updating
-- assumes ups throttling is enabled
function MiniMapWidget:ScheduleUpdate()
	self.task_ups = self.inst:DoTaskInTime(self.ups, function()
		if not self.minimap:IsVisible() then
			self.minimap:ToggleVisibility()
		end
		self:StopUpdatingAndReschedule()
	end)
end

-- schedule task ending minimap updating
-- assumes ups throttling is enabled
function MiniMapWidget:StopUpdatingAndReschedule()
	self.task_ups = self.inst:DoTaskInTime(0, function()
		if self.minimap:IsVisible() then
			self.minimap:ToggleVisibility()
		end
		self:ScheduleUpdate()
	end)
end

function MiniMapWidget:SetUPS(ups)
	local wasenabled = self:IsMinimapUpdating()

	self:DisableMinimapUpdating()
	self.ups = ups
	if wasenabled then
		self:EnableMinimapUpdating()
	end
end

return MiniMapWidget