name = "Minimap HUD"
description = "Adds a minimap to the HUD"
author = "squeek"
version = "1.0.4"
forumthread = "/files/file/352-minimap-hud/"
icon_atlas = "modicon.xml"
icon = "modicon.tex"
dst_compatible = true

-- this setting is dumb; this mod is likely compatible with all future versions
api_version = 10

configuration_options =
{
    {
        name = "Minimap Size",
        options =
        {
            {description = "Tiny", data = 0.125},
            {description = "Small", data = 0.175},
            {description = "Medium", data = 0.225},
            {description = "Large", data = 0.275},
            {description = "Huge", data = 0.325},
            {description = "Giant", data = 0.375},
        },
        default = 0.225,
    },
    {
        name = "Position",
        options =
        {
            {description = "Top Right", data = "top_right"},
            {description = "Top Left", data = "top_left"},
            {description = "Top Center", data = "top_center"},
            {description = "Middle Left", data = "middle_left"},
            {description = "Middle Center", data = "middle_center"},
            {description = "Middle Right", data = "middle_right"},
            {description = "Bottom Left", data = "bottom_left"},
            {description = "Bottom Center", data = "bottom_center"},
            {description = "Bottom Right", data = "bottom_right"},
        },
        default = "top_right"
    },
    {
        name = "Horizontal Margin",
        options =
        {
            {description = "None", data = 0},
            {description = "Very Tiny", data = 5},
            {description = "Tiny", data = 12.5},
            {description = "Very Small", data = 25},
            {description = "Small", data = 50},
            {description = "Medium", data = 125},
            {description = "Large", data = 235},
            {description = "Huge", data = 350},
            {description = "Giant", data = 450},
        },
        default = 235
    },
    {
        name = "Vertical Margin",
        options =
        {
            {description = "None", data = 0},
            {description = "Very Tiny", data = 5},
            {description = "Tiny", data = 12.5},
            {description = "Very Small", data = 25},
            {description = "Small", data = 50},
            {description = "Medium", data = 125},
            {description = "Large", data = 235},
            {description = "Very Large", data = 300},
            {description = "Huge", data = 350},
            {description = "Giant", data = 450},
        },
        default = 25
    },
}