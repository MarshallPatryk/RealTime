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

registerForEvent("init", function()
    print("Real Time script made by SamWieszKto (forked from Kruksii)")
    syncWeatherAndTime()
    rndmWeather()
end)

registerForEvent("update", function(delta)
    syncTime = syncTime + delta
    randomWeatherTime = randomWeatherTime + delta
    if FreezeTime == false then
        if syncTime > Config.timeBeforeSync then
            syncTime = 0
            syncWeatherAndTime()
        end
    end
    if FreezeWeather == false then
        if randomWeatherTime > Config.timeBeforeRndmWeather then
            randomWeatherTime = 0
            rndmWeather()
        end
    end
end)

function syncWeatherAndTime()
    time = os.date('*t')
    timeHour = time.hour
    timeMinute = time.min
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

    world.hour = timeHour
    world.minute = timeMinute
    world.day = dateDay
    world.month = dateMonth
    world.year = gameYear
    world.season = Season
    world.weather = weatherName
    world:RpcSet()
    print(string.format(Lang.syncMessage, timeHour, timeMinute, dateDay, dateMonth, world.year, seasonsNames[Season]))
end

function rndmWeather()
    if world.season == 2 then
        -- winter
        local weatherRndm = math.random(1, #Config.winterWeather)
        weatherName = Config.winterWeather[weatherRndm]
    elseif world.season == 4 then
        -- spring
        local weatherRndm = math.random(1, #Config.springWeather)
        weatherName = Config.springWeather[weatherRndm]
    elseif world.season == 1 then
        -- summer
        local weatherRndm = math.random(1, #Config.summerWeather)
        weatherName = Config.summerWeather[weatherRndm]
    else
        -- fall
        local weatherRndm = math.random(1, #Config.fallWeather)
        weatherName = Config.fallWeather[weatherRndm]
    end

    world.weather = weatherName
    world:RpcSet()
    print(string.format(Lang.weatherChangeMessage, weatherName))
end

-- Exports

Exports("changeRandomWeather", function()
    rndmWeather()
end)

Exports("changeWeather", function(weatherName)
    world.weather = weatherName
    world:RpcSet()
    print(string.format(Lang.weatherChangeMessage, weatherName))
end)

Exports("SetWorldData", function(data)
    if type(data) == "table" then
        local changed = false
        for i, v in pairs(data) do
            if i == (hour or minute or second or day or month or year or season or weather) then
                changed = true
                world[i] = v
            end
        end
        if changed == true then
            world:RpcSet()
            print(Lang.setWorldSettings)
        end
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

Exports("FreezeBoth", function(state)
    Exports.realtime.FreezeTime(state)
    Exports.realtime.FreezeWeather(state)
end)
