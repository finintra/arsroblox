local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local TweenService = game:GetService("TweenService")

local SpaceStationBuilder = {}
SpaceStationBuilder.__index = SpaceStationBuilder

-- Конфігурація
local CONFIG = {
    RoomSize = Vector3.new(50, 20, 50),
    WallThickness = 1,
    WallMaterial = Enum.Material.Neon,
    WallColor = Color3.fromRGB(100, 170, 255),
    FloorMaterial = Enum.Metal,
    FloorColor = Color3.fromRGB(60, 60, 60),
    CeilingMaterial = Enum.Metal,
    CeilingColor = Color3.fromRGB(80, 100, 130),
    CorridorSize = Vector3.new(10, 10, 10),
    SpawnPoints = 8,
    SpawnHeight = 5
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
    floor.Position = position
    floor.Anchored = true
    floor.Material = Enum.Material.Metal
    floor.Color = color or Color3.fromRGB(60, 60, 60)
    floor.Name = name.."_Floor"
    floor.Parent = workspace
    
    -- Створення стін
    local wall1 = Instance.new("Part")
    wall1.Size = Vector3.new(CONFIG.RoomSize.X, CONFIG.RoomSize.Y, CONFIG.WallThickness)
    wall1.Position = position + Vector3.new(0, CONFIG.RoomSize.Y/2, -CONFIG.RoomSize.Z/2)
    wall1.Anchored = true
    wall1.Material = CONFIG.WallMaterial
    wall1.Color = color or CONFIG.WallColor
    wall1.Parent = workspace
    
    local wall2 = wall1:Clone()
    wall2.Position = position + Vector3.new(0, CONFIG.RoomSize.Y/2, CONFIG.RoomSize.Z/2)
    wall2.Parent = workspace
    
    local wall3 = Instance.new("Part")
    wall3.Size = Vector3.new(CONFIG.WallThickness, CONFIG.RoomSize.Y, CONFIG.RoomSize.Z)
    wall3.Position = position + Vector3.new(-CONFIG.RoomSize.X/2, CONFIG.RoomSize.Y/2, 0)
    wall3.Anchored = true
    wall3.Material = CONFIG.WallMaterial
    wall3.Color = color or CONFIG.WallColor
    wall3.Parent = workspace
    
    local wall4 = wall3:Clone()
    wall4.Position = position + Vector3.new(CONFIG.RoomSize.X/2, CONFIG.RoomSize.Y/2, 0)
    wall4.Parent = workspace
    
    -- Додавання неонового освітлення
    local light = Instance.new("PointLight")
    light.Brightness = 2
    light.Range = 50
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
        local radius = 15
        local x = math.cos(angle) * radius
        local z = math.sin(angle) * radius
        
        -- Створюємо платформу для спавну
        local spawn = Instance.new("SpawnLocation")
        spawn.Position = Vector3.new(x, CONFIG.SpawnHeight, z)
        spawn.Size = Vector3.new(4, 1, 4)
        spawn.Anchored = true
        spawn.CanCollide = true
        spawn.Material = Enum.Material.Neon
        spawn.Color = Color3.fromRGB(0, 255, 0)
        spawn.Name = "SpawnPoint_"..i
        spawn.Neutral = true  -- Дозволяє спавнитися всім гравцям
        spawn.Parent = workspace
        
        -- Додаємо підсвітку
        local light = Instance.new("PointLight")
        light.Brightness = 2
        light.Range = 10
        light.Color = Color3.fromRGB(0, 255, 0)
        light.Parent = spawn
        
        -- Додаємо платформу під спавн
        local platform = Instance.new("Part")
        platform.Size = Vector3.new(6, 1, 6)
        platform.Position = Vector3.new(x, CONFIG.SpawnHeight - 0.5, z)
        platform.Anchored = true
        platform.CanCollide = true
        platform.Material = Enum.Material.Metal
        platform.Transparency = 0.5
        platform.Name = "SpawnPlatform_"..i
        platform.Parent = workspace
        
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
