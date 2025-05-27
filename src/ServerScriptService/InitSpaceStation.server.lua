local ServerScriptService = game:GetService("ServerScriptService")
local SpaceStationBuilder = require(script.Parent.SpaceStationBuilder)

-- Ініціалізація станції
local function cleanupExistingStation()
    -- Видаляємо всі існуючі частини станції
    for _, part in ipairs(workspace:GetChildren()) do
        if part:IsA("BasePart") and 
           (part.Name:find("Room") or 
            part.Name:find("Corridor") or 
            part.Name:find("Spawn")) then
            part:Destroy()
        end
    end
end

local function initStation()
    -- Очищаємо існуючу станцію
    cleanupExistingStation()
    
    -- Чекаємо трохи, щоб усе встигло видалитися
    wait(0.5)
    
    -- Будуємо нову станцію
    local builder = SpaceStationBuilder.new()
    builder:Build()
    
    -- Вивід інформації про створення
    print("Space station has been initialized!")
    print("Created rooms: Laboratory, Server Room, Ventilation, Generator")
    print("Spawn points: 8")
end

-- Запуск ініціалізації при старті гри
game.Players.PlayerAdded:Connect(function(player)
    -- Створюємо станцію при підключенні першого гравця
    if #game.Players:GetPlayers() == 1 then
        initStation()
    end
    
    -- Телепортуємо гравця на спавн точку
    player.CharacterAdded:Connect(function(character)
        wait(0.5) -- Чекаємо поки завантажиться персонаж
        
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        local spawnPoints = workspace:FindFirstChild("SpawnPoints") or {}
        
        if #spawnPoints:GetChildren() > 0 then
            -- Вибираємо випадкову точку спавну
            local spawnPoint = spawnPoints:GetChildren()[math.random(1, #spawnPoints:GetChildren())]
            if spawnPoint and spawnPoint:IsA("BasePart") then
                -- Телепортуємо гравця трохи вище точки спавну
                humanoidRootPart.CFrame = spawnPoint.CFrame + Vector3.new(0, 3, 0)
            end
        end
    end)
end)

-- Ініціалізуємо станцію при старті сервера
initStation()
