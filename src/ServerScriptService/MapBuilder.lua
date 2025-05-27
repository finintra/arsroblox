local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local MapBuilder = {}
MapBuilder.__index = MapBuilder

-- Конфігурація карти
local CONFIG = {
    -- Розміри кімнат
    RoomSizes = {
        Laboratory = Vector3.new(40, 10, 40),
        ServerRoom = Vector3.new(35, 10, 35),
        Ventilation = Vector3.new(30, 20, 30),
        Generator = Vector3.new(45, 12, 45)
    },
    -- Позиції кімнат
    RoomPositions = {
        Laboratory = Vector3.new(0, 0, 0),
        ServerRoom = Vector3.new(60, 0, 0),
        Ventilation = Vector3.new(60, 0, 60),
        Generator = Vector3.new(0, 0, 60)
    },
    -- Кольори кімнат
    RoomColors = {
        Laboratory = Color3.fromRGB(0, 170, 255),  -- Синій
        ServerRoom = Color3.fromRGB(0, 200, 100),  -- Зелений
        Ventilation = Color3.fromRGB(200, 200, 200), -- Сірий
        Generator = Color3.fromRGB(255, 100, 0)     -- Помаранчевий
    },
    -- Налаштування коридорів
    CorridorWidth = 8,
    CorridorHeight = 8,
    -- Налаштування спавн-точок
    SpawnHeight = 5,
    -- Загальні налаштування
    WallThickness = 1,
    WallMaterial = Enum.Material.SmoothPlastic,
    FloorMaterial = Enum.Material.Metal,
    CeilingMaterial = Enum.Material.Metal
}

-- Ініціалізація будівельника
function MapBuilder.new()
    local self = setmetatable({}, MapBuilder)
    self.rooms = {}
    self.corridors = {}
    self.spawnPoints = {}
    return self
end

-- Створення кімнати
function MapBuilder:CreateRoom(name, position, size, color)
    local room = {
        name = name,
        position = position,
        size = size,
        color = color,
        parts = {}
    }
    
    -- Створення підлоги
    local floor = Instance.new("Part")
    floor.Size = Vector3.new(size.X, CONFIG.WallThickness, size.Z)
    floor.Position = position + Vector3.new(0, -size.Y/2 + CONFIG.WallThickness/2, 0)
    floor.Anchored = true
    floor.CanCollide = true
    floor.Material = CONFIG.FloorMaterial
    floor.Color = color
    floor.Name = name .. "_Floor"
    floor.Parent = workspace
    room.parts.floor = floor
    
    -- Створення стелі
    local ceiling = Instance.new("Part")
    ceiling.Size = Vector3.new(size.X, CONFIG.WallThickness, size.Z)
    ceiling.Position = position + Vector3.new(0, size.Y/2 - CONFIG.WallThickness/2, 0)
    ceiling.Anchored = true
    ceiling.CanCollide = true
    ceiling.Material = CONFIG.CeilingMaterial
    ceiling.Color = color
    ceiling.Name = name .. "_Ceiling"
    ceiling.Parent = workspace
    room.parts.ceiling = ceiling
    
    -- Створення стін
    -- Передня стіна
    local frontWall = Instance.new("Part")
    frontWall.Size = Vector3.new(size.X, size.Y, CONFIG.WallThickness)
    frontWall.Position = position + Vector3.new(0, 0, size.Z/2)
    frontWall.Anchored = true
    frontWall.CanCollide = true
    frontWall.Material = CONFIG.WallMaterial
    frontWall.Color = color
    frontWall.Name = name .. "_FrontWall"
    frontWall.Parent = workspace
    room.parts.frontWall = frontWall
    
    -- Задня стіна
    local backWall = Instance.new("Part")
    backWall.Size = Vector3.new(size.X, size.Y, CONFIG.WallThickness)
    backWall.Position = position + Vector3.new(0, 0, -size.Z/2)
    backWall.Anchored = true
    backWall.CanCollide = true
    backWall.Material = CONFIG.WallMaterial
    backWall.Color = color
    backWall.Name = name .. "_BackWall"
    backWall.Parent = workspace
    room.parts.backWall = backWall
    
    -- Ліва стіна
    local leftWall = Instance.new("Part")
    leftWall.Size = Vector3.new(CONFIG.WallThickness, size.Y, size.Z)
    leftWall.Position = position + Vector3.new(-size.X/2, 0, 0)
    leftWall.Anchored = true
    leftWall.CanCollide = true
    leftWall.Material = CONFIG.WallMaterial
    leftWall.Color = color
    leftWall.Name = name .. "_LeftWall"
    leftWall.Parent = workspace
    room.parts.leftWall = leftWall
    
    -- Права стіна
    local rightWall = Instance.new("Part")
    rightWall.Size = Vector3.new(CONFIG.WallThickness, size.Y, size.Z)
    rightWall.Position = position + Vector3.new(size.X/2, 0, 0)
    rightWall.Anchored = true
    rightWall.CanCollide = true
    rightWall.Material = CONFIG.WallMaterial
    rightWall.Color = color
    rightWall.Name = name .. "_RightWall"
    rightWall.Parent = workspace
    room.parts.rightWall = rightWall
    
    -- Додавання освітлення
    local light = Instance.new("PointLight")
    light.Brightness = 1
    light.Range = size.X
    light.Color = color
    light.Parent = floor
    
    -- Додавання додаткових елементів відповідно до типу кімнати
    self:AddRoomDetails(room)
    
    -- Зберігаємо кімнату
    self.rooms[name] = room
    return room
end

-- Додавання деталей до кімнати відповідно до її типу
function MapBuilder:AddRoomDetails(room)
    local name = room.name
    local position = room.position
    local size = room.size
    
    if name == "Laboratory" then
        -- Додаємо лабораторні столи
        for i = 1, 3 do
            local table = Instance.new("Part")
            table.Size = Vector3.new(10, 3, 5)
            table.Position = position + Vector3.new(-10 + i * 10, -size.Y/2 + 1.5, 0)
            table.Anchored = true
            table.CanCollide = true
            table.Material = Enum.Material.SmoothPlastic
            table.Color = Color3.fromRGB(200, 200, 200)
            table.Name = "LabTable_" .. i
            table.Parent = workspace
            
            -- Додаємо колби та обладнання
            local equipment = Instance.new("Part")
            equipment.Size = Vector3.new(2, 3, 2)
            equipment.Position = position + Vector3.new(-10 + i * 10, -size.Y/2 + 4, 0)
            equipment.Anchored = true
            equipment.CanCollide = true
            equipment.Material = Enum.Material.Glass
            equipment.Color = Color3.fromRGB(0, 255, 255)
            equipment.Transparency = 0.5
            equipment.Name = "LabEquipment_" .. i
            equipment.Parent = workspace
        end
        
    elseif name == "ServerRoom" then
        -- Додаємо сервери
        for i = 1, 4 do
            for j = 1, 2 do
                local server = Instance.new("Part")
                server.Size = Vector3.new(3, 8, 6)
                server.Position = position + Vector3.new(-12 + i * 8, -size.Y/2 + 4, -10 + j * 20)
                server.Anchored = true
                server.CanCollide = true
                server.Material = Enum.Material.Metal
                server.Color = Color3.fromRGB(50, 50, 50)
                server.Name = "Server_" .. i .. "_" .. j
                server.Parent = workspace
                
                -- Додаємо індикатори
                local indicator = Instance.new("Part")
                indicator.Size = Vector3.new(0.5, 0.5, 0.5)
                indicator.Position = position + Vector3.new(-12 + i * 8, -size.Y/2 + 6, -10 + j * 20 + 2)
                indicator.Anchored = true
                indicator.CanCollide = false
                indicator.Material = Enum.Material.Neon
                indicator.Color = Color3.fromRGB(0, 255, 0)
                indicator.Name = "ServerIndicator_" .. i .. "_" .. j
                indicator.Parent = workspace
                
                -- Додаємо світло від індикатора
                local light = Instance.new("PointLight")
                light.Brightness = 0.5
                light.Range = 3
                light.Color = Color3.fromRGB(0, 255, 0)
                light.Parent = indicator
            end
        end
        
    elseif name == "Ventilation" then
        -- Додаємо вентиляційні труби
        for i = 1, 3 do
            local vent = Instance.new("Part")
            vent.Size = Vector3.new(3, size.Y * 0.8, 3)
            vent.Position = position + Vector3.new(-10 + i * 10, 0, 0)
            vent.Anchored = true
            vent.CanCollide = true
            vent.Material = Enum.Material.Metal
            vent.Color = Color3.fromRGB(150, 150, 150)
            vent.Name = "VentPipe_" .. i
            vent.Parent = workspace
            
            -- Додаємо решітки
            for j = 1, 3 do
                local grate = Instance.new("Part")
                grate.Size = Vector3.new(5, 0.5, 5)
                grate.Position = position + Vector3.new(-10 + i * 10, -size.Y/2 + j * 6, 0)
                grate.Anchored = true
                grate.CanCollide = true
                grate.Material = Enum.Material.Metal
                grate.Color = Color3.fromRGB(100, 100, 100)
                grate.Name = "VentGrate_" .. i .. "_" .. j
                grate.Parent = workspace
            end
        end
        
    elseif name == "Generator" then
        -- Додаємо генератори
        local mainGenerator = Instance.new("Part")
        mainGenerator.Size = Vector3.new(15, 8, 15)
        mainGenerator.Position = position + Vector3.new(0, -size.Y/2 + 4, 0)
        mainGenerator.Anchored = true
        mainGenerator.CanCollide = true
        mainGenerator.Material = Enum.Material.Metal
        mainGenerator.Color = Color3.fromRGB(80, 80, 80)
        mainGenerator.Name = "MainGenerator"
        mainGenerator.Parent = workspace
        
        -- Додаємо енергетичне ядро
        local core = Instance.new("Part")
        core.Size = Vector3.new(5, 5, 5)
        core.Position = position + Vector3.new(0, -size.Y/2 + 8, 0)
        core.Anchored = true
        core.CanCollide = false
        core.Material = Enum.Material.Neon
        core.Color = Color3.fromRGB(255, 100, 0)
        core.Transparency = 0.3
        core.Name = "EnergyCore"
        core.Parent = workspace
        
        -- Додаємо світло від ядра
        local light = Instance.new("PointLight")
        light.Brightness = 2
        light.Range = 20
        light.Color = Color3.fromRGB(255, 100, 0)
        light.Parent = core
        
        -- Додаємо допоміжні генератори
        for i = 1, 4 do
            local angle = math.rad(i * 90)
            local auxGen = Instance.new("Part")
            auxGen.Size = Vector3.new(6, 5, 6)
            auxGen.Position = position + Vector3.new(math.cos(angle) * 15, -size.Y/2 + 2.5, math.sin(angle) * 15)
            auxGen.Anchored = true
            auxGen.CanCollide = true
            auxGen.Material = Enum.Material.Metal
            auxGen.Color = Color3.fromRGB(100, 100, 100)
            auxGen.Name = "AuxGenerator_" .. i
            auxGen.Parent = workspace
        end
    end
end

-- Створення коридору між кімнатами
function MapBuilder:CreateCorridor(room1Name, room2Name)
    local room1 = self.rooms[room1Name]
    local room2 = self.rooms[room2Name]
    
    if not room1 or not room2 then
        warn("Cannot create corridor: one or both rooms don't exist")
        return
    end
    
    local pos1 = room1.position
    local pos2 = room2.position
    local size1 = room1.size
    local size2 = room2.size
    
    -- Визначаємо напрямок коридору
    local direction = (pos2 - pos1).Unit
    local distance = (pos2 - pos1).Magnitude
    
    -- Визначаємо розміри коридору
    local corridorLength = distance - (size1.X/2 + size2.X/2)
    local corridorWidth = CONFIG.CorridorWidth
    local corridorHeight = CONFIG.CorridorHeight
    
    -- Створюємо коридор
    local corridor = Instance.new("Part")
    
    -- Визначаємо орієнтацію коридору (по X чи по Z)
    if math.abs(direction.X) > math.abs(direction.Z) then
        -- Коридор по осі X
        corridor.Size = Vector3.new(corridorLength, corridorHeight, corridorWidth)
    else
        -- Коридор по осі Z
        corridor.Size = Vector3.new(corridorWidth, corridorHeight, corridorLength)
    end
    
    -- Встановлюємо позицію коридору
    corridor.Position = pos1 + direction * (size1.X/2 + corridorLength/2)
    corridor.Anchored = true
    corridor.CanCollide = true
    corridor.Material = CONFIG.WallMaterial
    corridor.Color = Color3.fromRGB(150, 150, 150)
    corridor.Name = "Corridor_" .. room1Name .. "_" .. room2Name
    corridor.Parent = workspace
    
    -- Додаємо освітлення
    local light1 = Instance.new("PointLight")
    light1.Brightness = 0.8
    light1.Range = corridorWidth * 2
    light1.Color = Color3.fromRGB(200, 200, 255)
    light1.Parent = corridor
    
    -- Додаємо аварійне освітлення
    local emergencyLight = Instance.new("Part")
    emergencyLight.Size = Vector3.new(0.5, 0.5, 0.5)
    emergencyLight.Position = corridor.Position + Vector3.new(0, corridorHeight/2 - 1, 0)
    emergencyLight.Anchored = true
    emergencyLight.CanCollide = false
    emergencyLight.Material = Enum.Material.Neon
    emergencyLight.Color = Color3.fromRGB(255, 0, 0)
    emergencyLight.Name = "EmergencyLight_" .. room1Name .. "_" .. room2Name
    emergencyLight.Parent = workspace
    
    local emergencyLightSource = Instance.new("PointLight")
    emergencyLightSource.Brightness = 0.5
    emergencyLightSource.Range = corridorWidth
    emergencyLightSource.Color = Color3.fromRGB(255, 0, 0)
    emergencyLightSource.Parent = emergencyLight
    
    -- Зберігаємо коридор
    table.insert(self.corridors, corridor)
    return corridor
end

-- Створення точок спавну
function MapBuilder:CreateSpawnPoints()
    local spawnLocations = {
        -- 1. Laboratory entrance
        {
            position = self.rooms["Laboratory"].position + Vector3.new(0, 0, self.rooms["Laboratory"].size.Z/2 - 5),
            name = "SpawnLaboratoryEntrance"
        },
        -- 2. Server Room doorway
        {
            position = self.rooms["ServerRoom"].position + Vector3.new(0, 0, -self.rooms["ServerRoom"].size.Z/2 + 5),
            name = "SpawnServerRoomDoorway"
        },
        -- 3. Top of Ventilation Shaft
        {
            position = self.rooms["Ventilation"].position + Vector3.new(0, self.rooms["Ventilation"].size.Y/2 - 3, 0),
            name = "SpawnVentilationTop"
        },
        -- 4. Generator Room exit
        {
            position = self.rooms["Generator"].position + Vector3.new(-self.rooms["Generator"].size.X/2 + 5, 0, 0),
            name = "SpawnGeneratorExit"
        }
    }
    
    -- Додаємо спавн-точки в коридорах
    -- 5. Corridor between Laboratory and Server Room
    if #self.corridors >= 1 then
        table.insert(spawnLocations, {
            position = self.corridors[1].Position,
            name = "SpawnCorridorLabServer"
        })
    end
    
    -- 6. Corridor between Ventilation Shaft and Generator Room
    if #self.corridors >= 3 then
        table.insert(spawnLocations, {
            position = self.corridors[3].Position,
            name = "SpawnCorridorVentGenerator"
        })
    end
    
    -- 7. Main corridor near Laboratory
    if #self.corridors >= 4 then
        table.insert(spawnLocations, {
            position = self.corridors[4].Position + Vector3.new(0, 0, 5),
            name = "SpawnMainCorridorLab"
        })
    end
    
    -- 8. Main corridor near Generator Room
    if #self.corridors >= 4 then
        table.insert(spawnLocations, {
            position = self.corridors[4].Position + Vector3.new(0, 0, -5),
            name = "SpawnMainCorridorGenerator"
        })
    end
    
    -- Створюємо спавн-точки
    local spawnFolder = Instance.new("Folder")
    spawnFolder.Name = "SpawnPoints"
    spawnFolder.Parent = workspace
    
    for i, spawnData in ipairs(spawnLocations) do
        local spawn = Instance.new("SpawnLocation")
        spawn.Position = spawnData.position
        spawn.Size = Vector3.new(4, 1, 4)
        spawn.Anchored = true
        spawn.CanCollide = true
        spawn.Material = Enum.Material.Neon
        spawn.Color = Color3.fromRGB(0, 255, 0)
        spawn.Name = spawnData.name
        spawn.Neutral = true
        spawn.Parent = spawnFolder
        
        -- Додаємо світло
        local light = Instance.new("PointLight")
        light.Brightness = 1
        light.Range = 10
        light.Color = Color3.fromRGB(0, 255, 0)
        light.Parent = spawn
        
        table.insert(self.spawnPoints, spawn)
    end
    
    return self.spawnPoints
end

-- Налаштування освітлення
function MapBuilder:SetupLighting()
    -- Налаштування загального освітлення
    Lighting.Ambient = Color3.fromRGB(40, 40, 60)
    Lighting.Brightness = 2
    Lighting.ClockTime = 0
    Lighting.FogColor = Color3.fromRGB(0, 0, 30)
    Lighting.FogEnd = 500
    Lighting.FogStart = 100
    
    -- Додаємо атмосферу
    local atmosphere = Instance.new("Atmosphere")
    atmosphere.Density = 0.3
    atmosphere.Offset = 0.25
    atmosphere.Color = Color3.fromRGB(200, 220, 255)
    atmosphere.Decay = Color3.fromRGB(100, 100, 150)
    atmosphere.Glare = 0
    atmosphere.Haze = 10
    atmosphere.Parent = Lighting
    
    -- Додаємо ефект розмиття
    local blur = Instance.new("BlurEffect")
    blur.Size = 2
    blur.Parent = Lighting
end

-- Очищення існуючої карти
function MapBuilder:CleanupExistingMap()
    -- Видаляємо всі існуючі частини карти
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("BasePart") or obj:IsA("Model") or obj:IsA("Folder") then
            if obj.Name:find("_") or obj.Name:find("Spawn") or obj.Name:find("Corridor") then
                obj:Destroy()
            end
        end
    end
    
    -- Видаляємо ефекти освітлення
    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("Atmosphere") or obj:IsA("BlurEffect") then
            obj:Destroy()
        end
    end
end

-- Побудова всієї карти
function MapBuilder:BuildMap()
    -- Очищення існуючої карти
    self:CleanupExistingMap()
    
    -- Створення кімнат
    local laboratory = self:CreateRoom("Laboratory", CONFIG.RoomPositions.Laboratory, CONFIG.RoomSizes.Laboratory, CONFIG.RoomColors.Laboratory)
    local serverRoom = self:CreateRoom("ServerRoom", CONFIG.RoomPositions.ServerRoom, CONFIG.RoomSizes.ServerRoom, CONFIG.RoomColors.ServerRoom)
    local ventilation = self:CreateRoom("Ventilation", CONFIG.RoomPositions.Ventilation, CONFIG.RoomSizes.Ventilation, CONFIG.RoomColors.Ventilation)
    local generator = self:CreateRoom("Generator", CONFIG.RoomPositions.Generator, CONFIG.RoomSizes.Generator, CONFIG.RoomColors.Generator)
    
    -- Створення коридорів
    self:CreateCorridor("Laboratory", "ServerRoom")
    self:CreateCorridor("ServerRoom", "Ventilation")
    self:CreateCorridor("Ventilation", "Generator")
    self:CreateCorridor("Generator", "Laboratory")
    
    -- Створення точок спавну
    self:CreateSpawnPoints()
    
    -- Налаштування освітлення
    self:SetupLighting()
    
    return true
end

return MapBuilder
