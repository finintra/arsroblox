local ServerScriptService = game:GetService("ServerScriptService")
local SpaceStationBuilder = require(script.Parent.SpaceStationBuilder)

-- Ініціалізація станції
local function initStation()
    local builder = SpaceStationBuilder.new()
    builder:Build()
    
    -- Вивід інформації про створення
    print("Space station has been initialized!")
    print("Created rooms: Laboratory, Server Room, Ventilation, Generator")
    print("Spawn points: 8")
end

-- Запуск ініціалізації при старті гри
game.Players.PlayerAdded:Connect(function(player)
    if #game.Players:GetPlayers() == 1 then
        -- Перевірка, чи станція вже існує
        if not workspace:FindFirstChild("Laboratory_Floor") then
            initStation()
        end
    end
end)

-- Якщо сервер вже запущений, перевірити чи потрібно ініціалізувати станцію
if #game.Players:GetPlayers() > 0 then
    if not workspace:FindFirstChild("Laboratory_Floor") then
        initStation()
    end
end
