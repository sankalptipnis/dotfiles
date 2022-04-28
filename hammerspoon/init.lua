-- Mac to PC keyboard mapping:
-- Key Symbol / Key Name : Mac Key -> Windows Key
-- ⌘ / cmd : Command -> Ctrl
-- ⌃ / ctrl : Ctrl    -> Windows
-- ⌥ / alt : Option  -> Alt
-- ⇧ / shift : Shift -> Shift


--------------------------------------------
-- Hyper key definitions
--------------------------------------------
local hyper  = {"⌃", "⌥", "⌘"}
local ultra  = {"⇧", "⌃", "⌥", "⌘"}


--------------------------------------------
-- Reload config
--------------------------------------------
hs.hotkey.bind(hyper, "0", function() hs.reload() end)
hs.notify.new({title="Hammerspoon", informativeText="Config loaded", withdrawAfter=1}):send()


--------------------------------------------
-- Window management
--------------------------------------------
-- grid parameters : 6 columns and 2 rows
hs.grid.setGrid('6x2')
hs.grid.setMargins({0, 0})
hs.window.animationDuration = 0

-- helper function that returns another function that places the current window
-- into a certain grid position

-- position[1] - The row of the left edge of the window
-- position[2] - The column of the top edge of the window
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

-- helper functions that return other functions which move the current window
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
        hs.grid.pushWindowLeft(cur_window)
    end
end

local moveright = function()
    return function()
        cur_window = hs.window.focusedWindow()
        hs.grid.pushWindowRight(cur_window)
        hs.grid.pushWindowRight(cur_window)
    end
end

local maximize = function()
    return function()
        cur_window = hs.window.focusedWindow()
        hs.grid.maximizeWindow(cur_window)
    end
end

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

-- asymmetric placement 2x2
local go_top_left_two_by_two_asym     =  {0, 0, 4, 1}
local go_top_middle_two_by_two_asym   =  {2, 0, 4, 1}
local go_bottom_left_two_by_two_asym  =  {0, 1, 4, 1}
local go_bottom_right_two_by_two_asym =  {2, 1, 4, 1}

hs.hotkey.bind(ultra, 'home',     gridset(go_top_left_two_by_two_asym)) -- top left
hs.hotkey.bind(ultra, 'pageup',   gridset(go_top_middle_two_by_two_asym)) -- top right
hs.hotkey.bind(ultra, 'end',      gridset(go_bottom_left_two_by_two_asym)) -- bottom left
hs.hotkey.bind(ultra, 'pagedown', gridset(go_bottom_right_two_by_two_asym)) -- bottom right

-- asymmetric placement 2x1
local go_left_two_by_one_asym  =  {0, 0, 4, 2}
local go_right_two_by_one_asym =  {2, 0, 4, 2}

hs.hotkey.bind(ultra, 'left',  gridset(go_left_two_by_one_asym)) -- left
hs.hotkey.bind(ultra, 'right', gridset(go_right_two_by_one_asym)) -- right

-- grid movement
hs.hotkey.bind(hyper, "up",    moveup())
hs.hotkey.bind(hyper, "down",  movedown())
hs.hotkey.bind(hyper, "left",  moveleft())
hs.hotkey.bind(hyper, "right", moveright())
hs.hotkey.bind(hyper, "padenter", maximize())


--------------------------------------------
-- Open or focus application
--------------------------------------------
local applicationHotkeys = {
  c = 'Google Chrome',
  s = 'Safari',
  i = 'iTerm',
  b = 'Sublime Text',
  f = 'Finder',
  o = 'Microsoft Outlook',
  p = '1Password 7',
  v = 'Visual Studio Code',
  m = 'Mimestream'
}

for key, app in pairs(applicationHotkeys) do
  hs.hotkey.bind(hyper, key, function()
    hs.application.launchOrFocus(app)
  end)
end


--------------------------------------------
-- Snap to work layout
--------------------------------------------
local workLayout = {
	['Microsoft Outlook' ] = go_top_left_three_by_two,
	['Google Chrome'     ] = go_top_middle_three_by_two,
	['Finder'            ] = go_top_right_three_by_two,
    ['iTerm'             ] = go_bottom_left_three_by_two,   -- need for opening app
	['iTerm2'            ] = go_bottom_middle_three_by_two, -- need for moving app
    ['Sublime Text'      ] = go_bottom_left_three_by_two,
	['Mimestream'        ] = go_bottom_left_three_by_two,
    ['Visual Studio Code'] = go_bottom_right_three_by_two,  -- need for opening app
    ['Code'              ] = go_bottom_right_three_by_two,  -- need for moving app
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
			
			local app = hs.appfinder.appFromName(appName)

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

hs.hotkey.bind(hyper, 'F7', openApps(workLayout))
hs.hotkey.bind(hyper, 'F8', applyLayout(workLayout))


--------------------------------------------
-- Press Cmd+Q twice to quit
--------------------------------------------
local quitModal = hs.hotkey.modal.new('cmd','q')

function quitModal:entered()
    hs.alert.show("Press ⌘+Q again to quit", 1)
    hs.timer.doAfter(1, function() quitModal:exit() end)
end

local function doQuit()
    local res = hs.application.frontmostApplication():selectMenuItem("^Quit.*$")
    quitModal:exit()
end

quitModal:bind('cmd', 'q', doQuit)

quitModal:bind('', 'escape', function() quitModal:exit() end)


--------------------------------------------
-- Control Spotify
--------------------------------------------

function spotifyNowPlaying()
    local album = hs.spotify.getCurrentAlbum()
    local artist = hs.spotify.getCurrentArtist()
    local track = hs.spotify.getCurrentTrack()
    local message = artist .. "\n" .. track .. " - " .. album
    if hs.spotify.isPlaying() then
        hs.notify.new({title=artist, informativeText=track .. " - " .. album, withdrawAfter=3}):send()
    end
end

function spotifyToggleShuffle()
    oldStatus =
    os.execute("/opt/homebrew/bin/spotify toggle shuffle")
    hs.notify.new({title="Spotify", informativeText="Toggled Shuffle", withdrawAfter=1}):send()
end

function spotifyNext()
    hs.spotify.next()
    hs.timer.doAfter(0.5, spotifyNowPlaying)
end

function spotifyPrevious()
    hs.spotify.previous()
    hs.timer.doAfter(0.5, spotifyNowPlaying)
end

function spotifyPlayPause()
    hs.spotify.playpause()
    hs.timer.doAfter(0.5, spotifyNowPlaying)
end

-- pause /resume
hs.hotkey.bind( ultra, "F6", function() spotifyPlayPause() end)

-- pause
hs.hotkey.bind( ultra, "F7", function() hs.spotify.pause() end)

-- next track
hs.hotkey.bind( ultra, "F5", function() spotifyPrevious() end)

-- previous track
hs.hotkey.bind( ultra, "F8", function() spotifyNext() end)

-- toggle shuffle
hs.hotkey.bind( ultra, "s", function() spotifyToggleShuffle() end)

--------------------------------------------
-- Lock screen + start screensaver
--------------------------------------------
hs.hotkey.bind(hyper, "l", function() hs.caffeinate.lockScreen() end)
hs.hotkey.bind(ultra, "l", function() hs.caffeinate.startScreensaver() end)


--------------------------------------------
-- Kill caffeinate
--------------------------------------------
function killCaffeinate()
    logger.d("Looking for any running instances of caffeinate\n")
    if os.execute("pgrep caffeinate") then
        logger.d("Attempting to kill all instances of caffeinate\n")
        if os.execute("killall caffeinate") then
            logger.d("Successfully killed all instances of caffeinate \n")
            hs.notify.new({title="killall caffeinate", informativeText="Succeeded", withdrawAfter=2}):send()
        else
            logger.e("Failed to kill all instances caffeinate\n")
            hs.notify.new({title="killall caffeinate", informativeText="FAILED", withdrawAfter=2}):send()
        end
    else
        logger.d("No running instances of caffeinate\n")
        hs.notify.new({title="killall caffeinate", informativeText="No running instances of caffeinate", withdrawAfter=2}):send()
    end
end

hs.hotkey.bind(ultra, "k", function() killCaffeinate() end)

--------------------------------------------
-- Caffeinate for Borg backup
--------------------------------------------
local backupTimeStr = "0200"

logger = hs.logger.new("Backup Log")

-- Log levels:
-- 0 = nothing
-- 1 = errror
-- 2 = warning
-- 3 = info
-- 4 = debug
-- 5 = verbose
logger.setLogLevel(5)

local backupHour = string.sub(backupTimeStr, 1, 2)
local backupMinute = string.sub(backupTimeStr, 3, 4)
logger.d(string.format("Backup time set to %s\n", backupTimeStr))
logger.v(string.format("Backup hour set to: %s", backupHour))
logger.v(string.format("Backup minute set to: %s\n", backupMinute))

local caffeinateForBackup = function(eventType)
    if eventType == hs.caffeinate.watcher.systemDidWake then
        logger.d("The system woke from sleep\n")

        local now = os.date("*t")
        local now_SecondsSinceEpoch = os.time(now)
        local nowFormatted = os.date("%d/%m/%Y %I:%M%p", now_SecondsSinceEpoch)

        local backupTime_SecondsSinceEpoch = os.time(
            {year=now.year, month=now.month, day=now.day, hour=tonumber(backupHour), min=tonumber(backupMinute)})

        local backupDate = os.date("*t", backupTime_SecondsSinceEpoch)

        logger.v(string.format("Backup date: %02d/%02d/%04d", backupDate.day, backupDate.month, backupDate.year))
        logger.v(string.format("Backup time: %02d:%02d:%02d\n", backupDate.hour, backupDate.min, backupDate.sec))

        logger.v(string.format("Now date: %02d/%02d/%04d", now.day, now.month, now.year))
        logger.v(string.format("Now time: %02d:%02d:%02d\n", now.hour, now.min, now.sec))

        logger.v(string.format("Number of seconds between now and the backup time: %s\n", 
                math.abs(now_SecondsSinceEpoch - backupTime_SecondsSinceEpoch)))

        if math.abs(now_SecondsSinceEpoch - backupTime_SecondsSinceEpoch) < 2.5 * 60  then
            
            logger.d("Attempting to caffeinate for 4 hours")
            if os.execute("caffeinate -dis -t 14400 &") then
                logger.d("Caffeinate succeeded\n")
            else
                logger.e("Caffeinate failed\n")
            end
        end

    elseif eventType == hs.caffeinate.watcher.systemWillSleep then
        logger.d("The system is preparing to sleep\n")
    end
end

hs.caffeinate.watcher.new(caffeinateForBackup):start()
