local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local TweenService = game:GetService("TweenService")

local SpaceStationBuilder = {}
SpaceStationBuilder.__index = SpaceStationBuilder

-- Конфігурація
local CONFIG = {
    RoomSize = Vector3.new(50, 20, 50),
    WallThickness = 1,
    WallMaterial = Enum.Material.Metal,
    WallColor = Color3.fromRGB(100, 120, 150),
    FloorMaterial = Enum.Metal,
    FloorColor = Color3.fromRGB(80, 100, 130),
    CeilingMaterial = Enum.Metal,
    CeilingColor = Color3.fromRGB(80, 100, 130),
    CorridorSize = Vector3.new(10, 10, 10),
    SpawnPoints = 8
}

-- Кольори для кімнат для кращої навігації
local ROOM_COLORS = {
    Laboratory = Color3.fromRGB(0, 170, 255),  -- Синій
    ServerRoom = Color3.fromRGB(0, 200, 100),  -- Зелений
    Ventilation = Color3.fromRGB(200, 200, 200), -- Сірий
    Generator = Color3.fromRGB(255, 100, 0)     -- Помаранчевий
}

function SpaceStationBuilder.new()
    local self = setmetatable({}, SpaceStationBuilder)
    self.rooms = {}
    self.spawnPoints = {}
    return self
end

-- Створення кімнати
function SpaceStationBuilder:CreateRoom(position, name, color)
    local room = {}
    room.position = position
    room.name = name
    
    -- Створення підлоги
    local floor = Instance.new("Part")
    floor.Size = Vector3.new(CONFIG.RoomSize.X, CONFIG.WallThickness, CONFIG.RoomSize.Z)
    floor.Position = position + Vector3.new(0, -CONFIG.RoomSize.Y/2 + CONFIG.WallThickness/2, 0)
    floor.Anchored = true
    floor.Material = CONFIG.FloorMaterial
    floor.Color = color or CONFIG.FloorColor
    floor.Name = name.."_Floor"
    floor.Parent = workspace
    
    -- Додавання неонового освітлення
    local light = Instance.new("PointLight")
    light.Brightness = 1
    light.Range = 30
    light.Color = color or Color3.new(1, 1, 1)
    light.Parent = floor
    
    -- Зберігаємо кімнату
    room.floor = floor
    self.rooms[name] = room
    
    return room
end

-- Створення коридору між кімнатами
function SpaceStationBuilder:CreateCorridor(fromRoom, toRoom)
    local startPos = fromRoom.position
    local endPos = toRoom.position
    
    -- Розрахунок напрямку та довжини коридору
    local direction = (endPos - startPos).Unit
    local distance = (endPos - startPos).Magnitude
    
    -- Створення коридору
    local corridor = Instance.new("Part")
    corridor.Size = Vector3.new(
        math.abs(direction.X * distance) + (direction.X ~= 0 and CONFIG.CorridorSize.X or CONFIG.CorridorSize.X),
        CONFIG.CorridorSize.Y,
        math.abs(direction.Z * distance) + (direction.Z ~= 0 and CONFIG.CorridorSize.Z or CONFIG.CorridorSize.Z)
    )
    
    corridor.Position = (startPos + endPos) / 2
    corridor.Anchored = true
    corridor.Material = CONFIG.WallMaterial
    corridor.Color = Color3.fromRGB(150, 150, 150)
    corridor.Name = "Corridor_"..fromRoom.name.."_"..toRoom.name
    corridor.Parent = workspace
    
    -- Додавання освітлення в коридор
    local light = Instance.new("PointLight")
    light.Brightness = 0.8
    light.Range = 20
    light.Parent = corridor
    
    return corridor
end

-- Створення точок спавну
function SpaceStationBuilder:CreateSpawnPoints()
    local spawns = {}
    local angleStep = (2 * math.pi) / CONFIG.SpawnPoints
    
    for i = 1, CONFIG.SpawnPoints do
        local angle = angleStep * i
        local x = math.cos(angle) * 15
        local z = math.sin(angle) * 15
        
        local spawn = Instance.new("SpawnLocation")
        spawn.Position = Vector3.new(x, 5, z)
        spawn.Anchored = true
        spawn.Size = Vector3.new(4, 1, 4)
        spawn.Material = Enum.Material.Neon
        spawn.Color = Color3.fromRGB(0, 255, 0)
        spawn.Name = "SpawnPoint_"..i
        spawn.Parent = workspace
        
        -- Додавання ефекту спавн-точки
        local light = Instance.new("PointLight")
        light.Brightness = 2
        light.Range = 10
        light.Color = Color3.fromRGB(0, 255, 0)
        light.Parent = spawn
        
        table.insert(spawns, spawn)
    end
    
    return spawns
end

-- Основна функція для побудови станції
function SpaceStationBuilder:Build()
    -- Очищення існуючих кімнат
    for _, room in pairs(self.rooms) do
        if room.floor then room.floor:Destroy() end
    end
    self.rooms = {}
    
    -- Створення кімнат
    local lab = self:CreateRoom(Vector3.new(0, 0, 0), "Laboratory", ROOM_COLORS.Laboratory)
    local server = self:CreateRoom(Vector3.new(60, 0, 0), "ServerRoom", ROOM_COLORS.ServerRoom)
    local vent = self:CreateRoom(Vector3.new(0, 0, 60), "Ventilation", ROOM_COLORS.Ventilation)
    local gen = self:CreateRoom(Vector3.new(60, 0, 60), "Generator", ROOM_COLORS.Generator)
    
    -- Створення коридорів
    self:CreateCorridor(lab, server)
    self:CreateCorridor(lab, vent)
    self:CreateCorridor(server, gen)
    self:CreateCorridor(vent, gen)
    
    -- Створення точок спавну
    self.spawnPoints = self:CreateSpawnPoints()
    
    -- Налаштування неба
    local lighting = game:GetService("Lighting")
    lighting.Ambient = Color3.fromRGB(50, 50, 50)
    lighting.Brightness = 2
    lighting.ClockTime = 14
    lighting.GeographicLatitude = 0
    
    -- Додавання туману для космічного ефекту
    local atmosphere = Instance.new("Atmosphere")
    atmosphere.Density = 0.3
    atmosphere.Offset = 0.25
    atmosphere.Color = Color3.fromRGB(200, 220, 255)
    atmosphere.Decay = Color3.fromRGB(100, 100, 150)
    atmosphere.Glare = 0
    atmosphere.Haze = 15
    atmosphere.Parent = lighting
end

return SpaceStationBuilder
