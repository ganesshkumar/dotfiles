require("variables")
require("caffeine")

-- Global hotkey modifiers
hotkey1 = {"alt"}
hotkey2 = {"shift", "alt"}

------------------------------------------------
------------- Appplicaion focusing -------------
------------------------------------------------

-- Windows with letter bindings
apps = {
  ["f"] = "FirefoxDeveloperEdition",
  ["a"] = "Atom",
  ["t"] = "iTerm",
  ["i"] = "IntelliJ IDEA",
  ["d"] = "Dota 2",
  ["s"] = "Spotify",
  ["c"] = "Google Chrome",
  ["1"] = "Finder"
}

-- Bind windows to hotkeys
for key, name in pairs(apps) do
    hs.hotkey.bind(hotkey1, key, function() hs.application.launchOrFocus(name) end)
end

------------------------------------------------
------------ Wifi ssid based tasks -------------
------------------------------------------------

local wifiWatcher = nil

function ssidChangedCallback()
    newSSID = hs.wifi.currentNetwork()

    if newSSID == homeSSID then
        hs.notify.new({title="You are at Home", informativeText="Relax"}):send()
    elseif newSSID == officePrimarySSID then
        hs.execute("connectTo91SBWifi", true)
        hs.notify.new({title="You are at Office", informativeText="Let's brew some code"}):send()
    end
end

wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()
