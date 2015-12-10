name = "Minimap HUD"
description = "Adds a minimap to the HUD"
author = "squeek"
version = "1.0.4"
forumthread = "/files/file/352-minimap-hud/"
icon_atlas = "modicon.xml"
icon = "modicon.tex"
dst_compatible = true
client_only_mod = true
all_clients_require_mod = false

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
    {
        name = "FPS",
        label = "FPS throttling",
        hover = "Minimap's throttled updates per second",
        options =
        {
            {description = "Default", data = 0, hover = "Throttling disabled"},
            {description = "10 fps", data = 0.1},
            {description = "8 fps", data = 0.125},
            {description = "6 fps", data = 0.166},
            {description = "5 fps", data = 0.20},
            {description = "4 fps", data = 0.25},
            {description = "3 fps", data = 0.333},
            {description = "2 fps", data = 0.5},
            {description = "1 fps", data = 1},
            {description = "4f/5s", data = 1.25},
            {description = "2f/3s", data = 1.5},
            {description = "1f/2s", data = 2},
            {description = "1f/3s", data = 3},
            {description = "1f/4s", data = 4},
            {description = "1f/5s", data = 5},
            {description = "1f/6s", data = 6},
            {description = "1f/8s", data = 8},
            {description = "1f/10s", data = 10},
        },
        default = 0
    },
}