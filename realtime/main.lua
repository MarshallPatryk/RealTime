local Lang = LoadResource("locales").Fetch()

-- don't change
local syncTime = 0
local randomWeatherTime = 0
-- weather and season at server startup
local Season = Config.SeasonOnStartServer
local weatherName = Config.WeatherOnStartServer
local FreezeTime = Config.FreezeTime
local FreezeWeather = Config.FreezeWeather
local HourOnStartServer = Config.HourOnStartServer
local MinutesOnStartServer = Config.MinutesOnStartServer

local seasonsNames = {
    [1] = Lang.summer,
    [2] = Lang.winter,
    [3] = Lang.fall,
    [4] = Lang.spring
}
local firstRunTime = true
local firstRunWeather = true
RegisterForEvent("init", function()
    print("Real Time script made by SamWieszKto (forked from Kruksii)")
    firstRun = true
    syncWeatherAndTime()
end)

CreateThread(function()
    while true do
        Wait(Config.timeBeforeSync)
        syncWeatherAndTime()
    end
end)

CreateThread(function()
    while true do
        Wait(Config.timeBeforeRndmWeather)
        rndmWeather()
    end
end)

function syncWeatherAndTime()
    -- tutaj ograniczac przy starcie zmiany
    time = os.date('*t')
    dateDay = time.day
    dateMonth = time.month
    gameYear = Config.startGameYear + (time.year - Config.startRealYear)
    if (dateMonth == 12 and dateDay >= 21) or dateMonth == 1 or dateMonth == 2 or (dateMonth == 3 and dateDay < 21) then
        -- winter
        Season = 2
    elseif (dateMonth == 3 and dateDay >= 21) or dateMonth == 4 or dateMonth == 5 or (dateMonth == 6 and dateDay < 21) then
        -- spring
        Season = 4
    elseif (dateMonth == 6 and dateDay >= 21) or dateMonth == 7 or dateMonth == 8 or (dateMonth == 9 and dateDay < 23) then
        -- summer
        Season = 1
    else
        -- fall
        Season = 3
    end
    if firstRunWeather then
        server.world.weather = weatherName
    end
    if firstRunTime == true then
        server.world.hour = HourOnStartServer
        server.world.minute = MinutesOnStartServer
    end
    if FreezeTime then
        server.world.hour = HourOnStartServer
        server.world.minute = MinutesOnStartServer
        server.world.day = time.day
        server.world.month = time.month
        server.world.year = gameYear
    else
        server.world.hour = time.hour
        server.world.minute = time.min
        server.world.day = dateDay
        server.world.month = dateMonth
    end
    firstRunTime = false
    firstRunWeather = false
    server.world.year = gameYear
    server.world.season = Season
    server.world:RpcSet()
    print(string.format(Lang.syncMessage, server.world.hour, server.world.minute, dateDay, dateMonth, server.world.year,
        seasonsNames[server.world.season], server.world.weather))
end

function rndmWeather()
    if FreezeWeather == false then
        if server.world.season == 2 then
            -- winter
            local weatherRndm = math.random(1, #Config.winterWeather)
            weatherName = Config.winterWeather[weatherRndm]
        elseif server.world.season == 4 then
            -- spring
            local weatherRndm = math.random(1, #Config.springWeather)
            weatherName = Config.springWeather[weatherRndm]
        elseif server.world.season == 1 then
            -- summer
            local weatherRndm = math.random(1, #Config.summerWeather)
            weatherName = Config.summerWeather[weatherRndm]
        else
            -- fall
            local weatherRndm = math.random(1, #Config.fallWeather)
            weatherName = Config.fallWeather[weatherRndm]
        end
        server.world.weather = weatherName
        print(string.format(Lang.weatherChangeMessage, weatherName))
    else
        print(string.format(Lang.weatherNotChangeMessage, server.world.weather))
    end
    server.world:RpcSet()
end

-- Exports

Exports("changeRandomWeather", function()
    randomWeatherTime = 0
    rndmWeather()
end)

Exports("changeWeather", function(weatherName)
    randomWeatherTime = 0
    server.world.weather = weatherName
    server.world:RpcSet()
    print(string.format(Lang.weatherChangeMessage, weatherName))
end)

Exports("SetWorldData", function(data)
    if type(data) == "table" then
        -- chaning time or weather cause freezing (its RP module)
        -- changing day, month or season is in this module not possible (RP)
        if data.hour or data.minute then
            Exports.realtime.FreezeTime(state)
        end
        if data.weather then
            Exports.realtime.FreezeWeather(state)
        end
        for i, v in pairs(data) do
            if i == (hour or minute or weather) then
                server.world[i] = v
            end
        end
        server.world:RpcSet()
        print(Lang.setWorldSettings)
    end
end)

Exports("FreezeTime", function(state)
    if type(state) == "boolean" then
        FreezeTime = state
        if state == true then
            print(Lang.FreezeTimeON)
        else
            print(Lang.FreezeTimeOFF)
        end
    else
        if FreezeTime then
            FreezeTime = false
            print(Lang.FreezeTimeOFF)
        else
            FreezeTime = true
            print(Lang.FreezeTimeON)
        end
    end
end)

Exports("FreezeWeather", function(state)
    if type(state) == "boolean" then
        FreezeWeather = state
        if state == true then
            print(Lang.FreezeWeatherON)
        else
            print(Lang.FreezeWeatherOFF)
        end
    else
        if FreezeWeather then
            FreezeWeather = false
            print(Lang.FreezeWeatherOFF)
        else
            FreezeWeather = true
            print(Lang.FreezeWeatherON)
        end
    end
end)
Exports("SetFreezeBoth", function(state)
    Exports.realtime.FreezeTime(state)
    Exports.realtime.FreezeWeather(state)
end)
Exports("FreezeBoth", function()
    Exports.realtime.FreezeTime(true)
    Exports.realtime.FreezeWeather(true)
end)
Exports("UnFreezeBoth", function()
    Exports.realtime.FreezeTime(false)
    Exports.realtime.FreezeWeather(false)
end)
