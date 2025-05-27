-- InitSpaceStation.lua
-- Скрипт для ініціалізації космічної станції при запуску гри

local SpaceStationBuilder = require(script.Parent.SpaceStationBuilder)

-- Ініціалізуємо станцію при завантаженні серверу
local function init()
	SpaceStationBuilder:BuildSpaceStation()
end

-- Запускаємо ініціалізацію
init()
