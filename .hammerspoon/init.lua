require("variables")

-- Global hotkey modifiers
hotkey1 = {"alt"}
hotkey2 = {"shift", "alt"}

------------------------------------------------
------------- Appplicaion focusing -------------
------------------------------------------------

-- Windows with letter bindings
apps = {
 ["Firefox"] = "f",
 ["iTerm2"] = "i",
}

function focus_app(name)
    -- Get the app however we can.
    local app = hs.appfinder.appFromName(name)
    if app == nil then
        app = hs.appfinder.appFromWindowTitle(name)
    end
    if app == nil then
        app = hs.appfinder.appFromWindowTitlePattern(name)
    end

    if app == nil then
        hs.alert.show("Could not find " .. name, 1)
    else
        app:activate(true)
    end
    return app
end

-- Bind windows to hotkeys
for name, key in pairs(apps) do
    hs.hotkey.bind(hotkey1, key, function() focus_app(name) end)
end

------------------------------------------------
------------ Wifi ssid based tasks -------------
------------------------------------------------

local wifiWatcher = nil
local lastSSID = hs.wifi.currentNetwork()

function writeLocationToFile(text)    
    local file = io.open(automate_location_wifi, "w+")
    file:write(text)
    file:flush()
    file:close()
end

function showBrowser()
    local wv = hs.webview.new(hs.screen.primaryScreen():frame())
    wv:url("http://www.google.com"):windowStyle({"titled", "closable", "resizable"}) :show()
    -- bring the webview to front
    hs.application.get("Hammerspoon"):activate()
end
 
function ssidChangedCallback()
    newSSID = hs.wifi.currentNetwork()
    
    if newSSID == homeSSID and lastSSID ~= homeSSID then
        hs.notify.new({title="You are at Home", informativeText="Relax"}):send()
        writeLocationToFile("home")
        -- showBrowser()
    elseif (newSSID == officePrimarySSID or  newSSID == officeSecondarySSID) and (lastSSID ~= officePrimarySSID and lastSSID ~= officeSecondarySSID) then
        hs.notify.new({title="You are at Office", informativeText="Let's brew some code"}):send()
        writeLocationToFile("office")
    else
        writeLocationToFile("unknown")
    end
    
    lastSSID = newSSID
end

wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()


