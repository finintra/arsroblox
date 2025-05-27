-- InitSpaceStation.server.lua
-- Скрипт для ініціалізації космічної станції при запуску гри

local SpaceStationBuilder = require(script.Parent.SpaceStationBuilder)

-- Ініціалізуємо станцію при завантаженні серверу
local function init()
	print("Починаю будівництво космічної станції...")
	SpaceStationBuilder:BuildSpaceStation()
	print("Космічну станцію збудовано успішно!")
end

-- Запускаємо ініціалізацію
init()
