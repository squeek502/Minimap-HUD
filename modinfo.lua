name = "Minimap HUD"
description = "Adds a minimap to the HUD"
author = "squeek"
version = "1.0.7"
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
        name = "Updates Per Second",
        label = "Update throttling",
        hover = "Minimap's throttled updates per second, can help with FPS issues",
        options =
        {
            {description = "Default", data = 0, hover = "Throttling disabled, always keep map up-to-date"},
            {description = "10 ups", data = 0.1, hover = "Update the map 10 times per second"},
            {description = "8 ups", data = 0.125, hover = "Update the map 8 times per second"},
            {description = "6 ups", data = 0.166, hover = "Update the map 6 times per second"},
            {description = "5 ups", data = 0.20, hover = "Update the map 5 times per second"},
            {description = "4 ups", data = 0.25, hover = "Update the map 4 times per second"},
            {description = "3 ups", data = 0.333, hover = "Update the map 3 times per second"},
            {description = "2 ups", data = 0.5, hover = "Update the map 2 times per second"},
            {description = "1 ups", data = 1, hover = "Update the map every second"},
            {description = "4/5 ups", data = 1.25, hover = "Update the map 4 times in 5 seconds"},
            {description = "2/3 ups", data = 1.5, hover = "Update the map 2 times in 3 seconds"},
            {description = "1/2 ups", data = 2, hover = "Update the map every 2 seconds"},
            {description = "1/3 ups", data = 3, hover = "Update the map every 3 seconds"},
            {description = "1/4 ups", data = 4, hover = "Update the map every 4 seconds"},
            {description = "1/5 ups", data = 5, hover = "Update the map every 5 seconds"},
            {description = "1/6 ups", data = 6, hover = "Update the map every 6 seconds"},
            {description = "1/8 ups", data = 8, hover = "Update the map every 8 seconds"},
            {description = "1/10 ups", data = 10, hover = "Update the map every 10 seconds"},
            {description = "1/30 ups", data = 30, hover = "Update the map every 30 seconds"},
        },
        default = 0
    },
}
