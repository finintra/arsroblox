local ServerScriptService = game:GetService("ServerScriptService")
local MapBuilder = require(script.Parent.MapBuilder)

-- Функція ініціалізації карти
local function initMap()
    -- Створюємо будівельника карти
    local builder = MapBuilder.new()
    
    -- Будуємо карту
    local success = builder:BuildMap()
    
    if success then
        print("Sci-Fi Base map has been successfully built!")
        print("Created rooms: Laboratory, Server Room, Ventilation Shaft, Generator Room")
        print("Created corridors: 4")
        print("Created spawn points: 8")
    else
        warn("Failed to build the map!")
    end
end

-- Ініціалізуємо карту при старті сервера
initMap()

-- Функція для телепортації гравців на спавн-точки
local function setupPlayerSpawning()
    local Players = game:GetService("Players")
    
    -- Обробник появи нового гравця
    Players.PlayerAdded:Connect(function(player)
        -- Обробник появи персонажа
        player.CharacterAdded:Connect(function(character)
            -- Чекаємо, поки завантажиться персонаж
            task.wait(0.5)
            
            -- Отримуємо HumanoidRootPart
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            
            -- Отримуємо спавн-точки
            local spawnPoints = workspace:FindFirstChild("SpawnPoints")
            if not spawnPoints or #spawnPoints:GetChildren() == 0 then
                warn("No spawn points found!")
                return
            end
            
            -- Вибираємо випадкову точку спавну
            local spawnPoints = spawnPoints:GetChildren()
            local randomSpawn = spawnPoints[math.random(1, #spawnPoints)]
            
            -- Телепортуємо гравця на спавн-точку
            if randomSpawn and humanoidRootPart then
                humanoidRootPart.CFrame = randomSpawn.CFrame + Vector3.new(0, 3, 0)
                
                -- Додаємо ефект телепортації
                local teleportEffect = Instance.new("ParticleEmitter")
                teleportEffect.Texture = "rbxassetid://6101261905"
                teleportEffect.LightEmission = 1
                teleportEffect.LightInfluence = 0
                teleportEffect.Speed = NumberRange.new(5)
                teleportEffect.Lifetime = NumberRange.new(1)
                teleportEffect.Rate = 50
                teleportEffect.RotSpeed = NumberRange.new(0, 180)
                teleportEffect.Size = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.5),
                    NumberSequenceKeypoint.new(0.5, 1),
                    NumberSequenceKeypoint.new(1, 0)
                })
                teleportEffect.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(0.8, 0.5),
                    NumberSequenceKeypoint.new(1, 1)
                })
                teleportEffect.Parent = humanoidRootPart
                
                -- Видаляємо ефект через 2 секунди
                task.delay(2, function()
                    teleportEffect.Enabled = false
                    teleportEffect:Destroy()
                end)
            end
        end)
    end)
end

-- Налаштовуємо спавн гравців
setupPlayerSpawning()
