-- InitSpaceStation.server.lua
-- Скрипт для ініціалізації космічної станції при запуску гри

-- Почекаємо поки всі сервіси будуть доступні
game:GetService("RunService").Heartbeat:Wait()

print("Почекаємо, поки завантажиться гра...")
wait(2) -- Чекаємо 2 секунди для завантаження всіх компонентів

local SpaceStationBuilder = require(script.Parent.SpaceStationBuilder)

-- Ініціалізуємо станцію при завантаженні серверу
print("Починаю будівництво космічної станції...")

local success, result = pcall(function()
    return SpaceStationBuilder:BuildSpaceStation()
end)

if success then
    print("Космічну станцію збудовано успішно!")
else
    warn("Помилка при будівництві станції: " .. tostring(result))
end
