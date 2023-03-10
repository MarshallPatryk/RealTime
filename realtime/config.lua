Config = {}

Config.timeBeforeSync = 30000 -- Interval between sync (msec)
Config.timeBeforeRndmWeather = 1200000 -- Interval between random weather (msec)
Config.startGameYear = 1980 -- year in the game from which years will be counted ex. 1980
Config.startRealYear = 2023 -- the actual year the accrual of years started ex. 2023=1980
-- to freezing
Config.FreezeTime = false
Config.FreezeWeather = false
Config.WeatherOnStartServer = "Clear"
Config.SeasonOnStartServer = 0 -- 0 summer, 1 winter, 2 fall, 3 spring
Config.HourOnStartServer = 12
Config.MinutesOnStartServer = 0

-- Winter weather allowed on the server
Config.winterWeather = {"Clear", "Overcast_Heavy_Winter_01", "Winter_Misty_01", "Winter_Overcast_01",
                        "Winter_Overcast_Windy_01", "Snow_01", "Snow_Const", "SnowLight_01", "SnowShort"}

-- Summer weather allowed on the server
Config.summerWeather = {"Summer_Overcast_Heavy_01", "Clear", "Announce", "Astronomy", "Default_PHY", "FIG_07_Storm",
                        "ForbiddenForest_01", "HighAltitudeOnly", "Intro_01", "LightClouds_01", "LightRain_01",
                        "Misty_01", "MistyOvercast_01", "MKT_Nov11", "Overcast_01", "Overcast_Heavy_01",
                        "Overcast_Windy_01", "Rainy", "Sanctuary_Bog", "Sanctuary_Coastal", "Sanctuary_Forest",
                        "Sanctuary_Grasslands", "Stormy_01", "StormyLarge_01", "TestStormShort", "TestWind"}

-- Spring weather allowed on the server
Config.springWeather = {"Clear", "Announce", "Astronomy", "Default_PHY", "FIG_07_Storm", "ForbiddenForest_01",
                        "HighAltitudeOnly", "Intro_01", "LightClouds_01", "LightRain_01", "Misty_01",
                        "MistyOvercast_01", "MKT_Nov11", "Overcast_01", "Overcast_Heavy_01", "Overcast_Windy_01",
                        "Rainy", "Sanctuary_Bog", "Sanctuary_Coastal", "Sanctuary_Forest", "Sanctuary_Grasslands",
                        "Stormy_01", "StormyLarge_01", "TestStormShort", "TestWind"}

-- Fall weather allowed on the server
Config.fallWeather = {"Clear", "Announce", "Astronomy", "Default_PHY", "FIG_07_Storm", "ForbiddenForest_01",
                      "HighAltitudeOnly", "Intro_01", "LightClouds_01", "LightRain_01", "Misty_01", "MistyOvercast_01",
                      "MKT_Nov11", "Overcast_01", "Overcast_Heavy_01", "Overcast_Windy_01", "Rainy", "Sanctuary_Bog",
                      "Sanctuary_Coastal", "Sanctuary_Forest", "Sanctuary_Grasslands", "Stormy_01", "StormyLarge_01",
                      "TestStormShort", "TestWind"}
