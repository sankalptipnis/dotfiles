-- Mac to PC keyboard mapping:
-- ⌘ / Command -> Ctrl
-- ⌃ / Ctrl    -> Windows
-- ⌥ / Option  -> Alt

local application = require "hs.application"
local appfinder = require "hs.appfinder"

---- DEFINING HYPER KEY ----
local hyper  = {"⌃", "⌥", "⌘"}

---- WINDOW MANAGEMENT ----
-- grid parameters : 6 columns and 2 rows
hs.grid.setGrid('6x2')
hs.grid.setMargins({0, 0})
hs.window.animationDuration = 0

-- a helper function that returns another function that places the current window
-- into a certain grid position

-- position[1] - The column of the left edge of the window
-- position[2] - The row of the top edge of the window
-- position[3] - The number of columns the window occupies
-- position[4] - The number of rows the window occupies
local gridset = function(position)
    return function()
        cur_window = hs.window.focusedWindow()
        hs.grid.set(
            cur_window,
            {x=position[1], y=position[2], w=position[3], h=position[4]},
            cur_window:screen()
        )
    end
end

-- helper function that return another functions which move the current window
-- around the grid
local moveup = function()
    return function()
        cur_window = hs.window.focusedWindow()
        hs.grid.pushWindowUp(cur_window)
    end
end

local movedown = function()
    return function()
        cur_window = hs.window.focusedWindow()
        hs.grid.pushWindowDown(cur_window)
    end
end

local moveleft = function()
    return function()
        cur_window = hs.window.focusedWindow()
        hs.grid.pushWindowLeft(cur_window)
        -- hs.grid.pushWindowLeft(cur_window)
    end
end

local moveright = function()
    return function()
        cur_window = hs.window.focusedWindow()
        hs.grid.pushWindowRight(cur_window)
        -- hs.grid.pushWindowRight(cur_window)
    end
end

local maximize = function()
    return function()
        cur_window = hs.window.focusedWindow()
        hs.grid.maximizeWindow(cur_window)
    end
end

-- grid placement 4x2
local go_top_left_three_by_two      =  {0, 0, 2, 1}
local go_top_middle_three_by_two    =  {2, 0, 2, 1}
local go_top_right_three_by_two     =  {4, 0, 2, 1}
local go_bottom_left_three_by_two   =  {0, 1, 2, 1}
local go_bottom_middle_three_by_two =  {2, 1, 2, 1}
local go_bottom_right_three_by_two  =  {4, 1, 2, 1}

-- grid placement 3x2
local go_top_left_three_by_two      =  {0, 0, 2, 1}
local go_top_middle_three_by_two    =  {2, 0, 2, 1}
local go_top_right_three_by_two     =  {4, 0, 2, 1}
local go_bottom_left_three_by_two   =  {0, 1, 2, 1}
local go_bottom_middle_three_by_two =  {2, 1, 2, 1}
local go_bottom_right_three_by_two  =  {4, 1, 2, 1}

hs.hotkey.bind(hyper, 'pad7', gridset(go_top_left_three_by_two)) -- top left
hs.hotkey.bind(hyper, 'pad8', gridset(go_top_middle_three_by_two)) -- top middle
hs.hotkey.bind(hyper, 'pad9', gridset(go_top_right_three_by_two)) -- top right
hs.hotkey.bind(hyper, 'pad4', gridset(go_bottom_left_three_by_two)) -- bottom left
hs.hotkey.bind(hyper, 'pad5', gridset(go_bottom_middle_three_by_two)) -- bottom middle
hs.hotkey.bind(hyper, 'pad6', gridset(go_bottom_right_three_by_two)) -- bottom right

-- grid placement 2x2
local go_top_left_two_by_two     =  {0, 0, 3, 1}
local go_top_middle_two_by_two   =  {3, 0, 3, 1}
local go_bottom_left_two_by_two  =  {0, 1, 3, 1}
local go_bottom_right_two_by_two =  {3, 1, 3, 1}

hs.hotkey.bind(hyper, 'home',     gridset(go_top_left_two_by_two)) -- top left
hs.hotkey.bind(hyper, 'pageup',   gridset(go_top_middle_two_by_two)) -- top right
hs.hotkey.bind(hyper, 'end',      gridset(go_bottom_left_two_by_two)) -- bottom left
hs.hotkey.bind(hyper, 'pagedown', gridset(go_bottom_right_two_by_two)) -- bottom right

-- grid placement 3x1
local go_left_three_by_one   =  {0, 0, 2, 2}
local go_middle_three_by_one =  {2, 0, 2, 2}
local go_right_three_by_one  =  {4, 0, 2, 2}

hs.hotkey.bind(hyper, 'pad1',  gridset(go_left_three_by_one)) -- left
hs.hotkey.bind(hyper, 'pad2', gridset(go_middle_three_by_one)) -- middle
hs.hotkey.bind(hyper, 'pad3', gridset(go_right_three_by_one)) -- right

-- grid placement 2x1
local go_left_two_by_one  =  {0, 0, 3, 2}
local go_right_two_by_one =  {3, 0, 3, 2}

hs.hotkey.bind(hyper, 'pad0',  gridset(go_left_two_by_one)) -- left
hs.hotkey.bind(hyper, 'pad.', gridset(go_right_two_by_one)) -- right

-- grid movement
hs.hotkey.bind(hyper, "up",    moveup())
hs.hotkey.bind(hyper, "down",  movedown())
hs.hotkey.bind(hyper, "left",  moveleft())
hs.hotkey.bind(hyper, "right", moveright())
hs.hotkey.bind(hyper, "padenter", maximize())

---- EXPOSE ----
-- Keyboard-only expose
-- local expose=hs.expose.new(nil,{showThumbnails=true})
-- hs.hotkey.bind(hyper, 'e', function()expose:toggleShow()end)

-- expose_app = hs.expose.new(nil,{onlyActiveApplication=true}) -- show windows for the current application
-- hs.hotkey.bind(hyper, 'r', function()expose_app:toggleShow()end)

---- APP LAUNCHER ----
-- open and switch to most used applications
local applicationHotkeys = {
  c = 'Google Chrome',
  t = 'iTerm',
  s = 'Sublime Text',
  f = 'Finder',
  o = 'Microsoft Outlook',
  z = 'zoom.us',
  p = '1Password 7',
  v = 'Visual Studio Code',
  k = 'Keep',
  m = 'Mimestream'
}

for key, app in pairs(applicationHotkeys) do
  hs.hotkey.bind(hyper, key, function()
    hs.application.launchOrFocus(app)
  end)
end

---- WORK LAYOUT ----
-- set up work layout

local work_layout = {
	['Microsoft Outlook' ] = go_top_left_three_by_two,
	['Google Chrome'     ] = go_top_middle_three_by_two,
	['Finder'            ] = go_top_right_three_by_two,
--['iTerm'             ] = go_bottom_left_three_by_two,
	['iTerm2'            ] = go_bottom_middle_three_by_two,
--['Sublime Text'      ] = go_bottom_middle_three_by_two,
	['Mimestream'        ] = go_bottom_left_three_by_two,
    ['Code'              ] = go_bottom_right_three_by_two,
--['Visual Studio Code'] = go_bottom_right_three_by_two,
}

function openApps(layout)
	  	return function()
    	for appName, position in pairs(layout) do
				hs.application.launchOrFocus(appName)
    	end
  	end
end


function applyLayout(layout)
  	return function()
    	for appName, position in pairs(layout) do
			
			local app = appfinder.appFromName(appName)

    		if app then
	    		for i, win in ipairs(app:allWindows()) do
	      			hs.grid.set(win, 
	      						{x=position[1], y=position[2], w=position[3], h=position[4]},
	      						win:screen()
	    			)
	    		end
    		end
    	end
  	end
end

hs.hotkey.bind(hyper, 'F7', openApps(work_layout))
hs.hotkey.bind(hyper, 'F8', applyLayout(work_layout))

---- CONFIG RELOAD ----
-- reload config
hs.hotkey.bind(hyper, "0", function() hs.reload() end)
hs.notify.new({title="Hammerspoon", informativeText="Config loaded"}):send()


