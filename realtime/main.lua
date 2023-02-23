local Lang = LoadResource("locales").Fetch()

--don't change
local syncTime = 0
local randomWeather = 0
local weatherSeason = 0
--weather at server startup
local weatherName = "Clear"

local seasonsNames = {
    [1] = Lang.summer,
    [2] = Lang.winter,
    [3] = Lang.fall,
    [4] = Lang.spring,
}

registerForEvent("init", function()
    print("Real Time script made by SamWieszKto (forked from Kruksii)")
    syncWeatherAndTime()
    rndmWeather()
end)

registerForEvent("update", function(delta)
    syncTime = syncTime + delta
    randomWeather = randomWeather + delta

    if syncTime > Config.timeBeforeSync then
        syncTime = 0
        syncWeatherAndTime()
    end

    if randomWeather > Config.timeBeforeRndmWeather then
        randomWeather = 0
        rndmWeather()
    end
end)

function syncWeatherAndTime()
    time = os.date('*t')
    timeHour = time.hour
    timeMinute = time.min
    dateDay = time.day
    dateMonth = time.month
    gameYear = Config.startGameYear + (time.year - Config.startRealYear)

    if (dateMonth == 12 and dateDay >= 21) or dateMonth == 1 or dateMonth == 2 or
        (dateMonth == 3 and dateDay < 21) then
        -- winter
        weatherSeason = 2
    elseif (dateMonth == 3 and dateDay >= 21) or dateMonth == 4 or dateMonth ==
        5 or (dateMonth == 6 and dateDay < 21) then
        -- spring
        weatherSeason = 4
    elseif (dateMonth == 6 and dateDay >= 21) or dateMonth == 7 or dateMonth ==
        8 or (dateMonth == 9 and dateDay < 23) then
        -- summer
        weatherSeason = 1
    else
        -- fall
        weatherSeason = 3
    end

    world.hour = timeHour
    world.minute = timeMinute
    world.day = dateDay
    world.month = dateMonth
	world.year = gameYear
    world.season = weatherSeason
    world.weather = weatherName
    world:RpcSet()
    print(string.format(Lang.syncMessage, timeHour, timeMinute, dateDay, dateMonth, world.year, seasonsNames[weatherSeason]))
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
