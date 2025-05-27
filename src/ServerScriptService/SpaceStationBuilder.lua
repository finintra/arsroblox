-- SpaceStationBuilder.lua
-- Скрипт для створення космічної станції з 9 відсіками

local SpaceStationBuilder = {}

-- Кольори для різних відсіків
local COLORS = {
	CommandCenter = Color3.fromRGB(0, 100, 255),     -- Синій
	LivingQuarters = Color3.fromRGB(0, 200, 100),    -- Зелений
	ResearchLab = Color3.fromRGB(255, 255, 100),     -- Жовтий
	PowerGenerator = Color3.fromRGB(255, 100, 0),    -- Оранжевий
	StorageBay = Color3.fromRGB(150, 150, 150),      -- Сірий
	MedicalBay = Color3.fromRGB(255, 100, 100),      -- Червоний
	Engineering = Color3.fromRGB(100, 100, 255),     -- Фіолетовий
	Hydroponics = Color3.fromRGB(100, 255, 100),     -- Світло-зелений
	DockingBay = Color3.fromRGB(100, 200, 255)       -- Світло-синій
}

-- Конфігурація відсіків (позиція, розмір, ім'я)
local COMPARTMENTS_CONFIG = {
	{
		name = "CommandCenter",
		position = Vector3.new(0, 20, 0),
		size = Vector3.new(30, 10, 30),
		description = "Командний центр станції, звідки здійснюється управління всіма системами"
	},
	{
		name = "LivingQuarters",
		position = Vector3.new(40, 20, 0),
		size = Vector3.new(25, 10, 30),
		description = "Житлові приміщення для екіпажу станції"
	},
	{
		name = "ResearchLab",
		position = Vector3.new(-40, 20, 0),
		size = Vector3.new(25, 10, 30),
		description = "Лабораторія для проведення наукових досліджень"
	},
	{
		name = "PowerGenerator",
		position = Vector3.new(0, 20, 40),
		size = Vector3.new(25, 10, 25),
		description = "Енергетичний відсік, що забезпечує станцію електроенергією"
	},
	{
		name = "StorageBay",
		position = Vector3.new(0, 20, -40),
		size = Vector3.new(25, 10, 25),
		description = "Складське приміщення для зберігання вантажів та ресурсів"
	},
	{
		name = "MedicalBay",
		position = Vector3.new(40, 20, 40),
		size = Vector3.new(20, 10, 20),
		description = "Медичний відсік для лікування та підтримки здоров'я екіпажу"
	},
	{
		name = "Engineering",
		position = Vector3.new(-40, 20, 40),
		size = Vector3.new(20, 10, 20),
		description = "Інженерний відсік для обслуговування та ремонту систем станції"
	},
	{
		name = "Hydroponics",
		position = Vector3.new(-40, 20, -40),
		size = Vector3.new(20, 10, 20),
		description = "Гідропонна лабораторія для вирощування їжі"
	},
	{
		name = "DockingBay",
		position = Vector3.new(40, 20, -40),
		size = Vector3.new(20, 10, 20),
		description = "Док для стикування космічних кораблів"
	}
}

-- Функція створення основного відсіку
function SpaceStationBuilder:CreateCompartment(config)
	local compartment = Instance.new("Part")
	compartment.Name = config.name
	compartment.Position = config.position
	compartment.Size = config.size
	compartment.Anchored = true
	compartment.Material = Enum.Material.Metal
	compartment.Color = COLORS[config.name]
	compartment.Transparency = 0.2
	compartment.Parent = game.Workspace.SpaceStation
	
	-- Створення інформаційної таблички
	local infoBoard = Instance.new("Part")
	infoBoard.Name = "InfoBoard"
	infoBoard.Size = Vector3.new(5, 2, 0.2)
	infoBoard.Position = config.position + Vector3.new(0, -config.size.Y/2 + 3, config.size.Z/2 - 0.1)
	infoBoard.Orientation = Vector3.new(0, 180, 0)
	infoBoard.Anchored = true
	infoBoard.Material = Enum.Material.SmoothPlastic
	infoBoard.Color = Color3.fromRGB(255, 255, 255)
	infoBoard.Parent = compartment
	
	-- Створення тексту з описом
	local infoText = Instance.new("SurfaceGui")
	infoText.Name = "InfoText"
	infoText.Parent = infoBoard
	
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
	textLabel.Text = config.name .. "\n" .. config.description
	textLabel.TextScaled = true
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.Parent = infoText
	
	-- Додавання внутрішнього інтер'єру відповідно до призначення відсіку
	self:AddInterior(compartment, config)
	
	return compartment
end

-- Функція створення коридору між відсіками
function SpaceStationBuilder:CreateCorridor(compartment1, compartment2)
	local pos1 = compartment1.Position
	local pos2 = compartment2.Position
	
	local direction = (pos2 - pos1).Unit
	local distance = (pos2 - pos1).Magnitude
	
	local corridorLength = distance - (compartment1.Size.Magnitude + compartment2.Size.Magnitude) / 4
	local corridorWidth = 5
	local corridorHeight = 5
	
	local corridor = Instance.new("Part")
	corridor.Name = "Corridor_" .. compartment1.Name .. "_to_" .. compartment2.Name
	corridor.Anchored = true
	corridor.Material = Enum.Material.Metal
	corridor.Color = Color3.fromRGB(200, 200, 200)
	
	-- Визначення орієнтації коридору
	local midPoint = pos1:Lerp(pos2, 0.5)
	corridor.Position = midPoint
	
	-- Якщо коридор прямує по осі X
	if math.abs(direction.X) > math.abs(direction.Z) then
		corridor.Size = Vector3.new(corridorLength, corridorHeight, corridorWidth)
		corridor.CFrame = CFrame.new(midPoint, midPoint + Vector3.new(direction.X, 0, 0))
	else -- Якщо коридор прямує по осі Z
		corridor.Size = Vector3.new(corridorWidth, corridorHeight, corridorLength)
		corridor.CFrame = CFrame.new(midPoint, midPoint + Vector3.new(0, 0, direction.Z))
	end
	
	corridor.Parent = game.Workspace.SpaceStation
	
	return corridor
end

-- Функція додавання спеціалізованого інтер'єру
function SpaceStationBuilder:AddInterior(compartment, config)
	if config.name == "CommandCenter" then
		-- Командний стіл
		local commandTable = Instance.new("Part")
		commandTable.Name = "CommandTable"
		commandTable.Size = Vector3.new(10, 2, 5)
		commandTable.Position = compartment.Position + Vector3.new(0, -3, 0)
		commandTable.Anchored = true
		commandTable.Material = Enum.Material.SmoothPlastic
		commandTable.Color = Color3.fromRGB(50, 50, 100)
		commandTable.Parent = compartment
		
		-- Екрани
		for i = 1, 4 do
			local screen = Instance.new("Part")
			screen.Name = "Screen" .. i
			screen.Size = Vector3.new(5, 3, 0.2)
			local angle = i * math.pi / 2
			screen.Position = compartment.Position + 
				Vector3.new(math.sin(angle) * 10, 0, math.cos(angle) * 10)
			screen.Orientation = Vector3.new(0, i * 90, 0)
			screen.Anchored = true
			screen.Material = Enum.Material.Neon
			screen.Color = Color3.fromRGB(0, 200, 255)
			screen.Parent = compartment
		end
		
	elseif config.name == "LivingQuarters" then
		-- Ліжка
		for i = 1, 4 do
			local bed = Instance.new("Part")
			bed.Name = "Bed" .. i
			bed.Size = Vector3.new(5, 1, 2)
			bed.Position = compartment.Position + 
				Vector3.new(-8 + (i-1) * 5, -4, 8)
			bed.Anchored = true
			bed.Material = Enum.Material.Fabric
			bed.Color = Color3.fromRGB(100, 100, 200)
			bed.Parent = compartment
		end
		
		-- Стіл
		local table = Instance.new("Part")
		table.Name = "DiningTable"
		table.Size = Vector3.new(8, 1, 4)
		table.Position = compartment.Position + Vector3.new(0, -3, -8)
		table.Anchored = true
		table.Material = Enum.Material.Wood
		table.Color = Color3.fromRGB(150, 100, 50)
		table.Parent = compartment
		
	elseif config.name == "ResearchLab" then
		-- Лабораторні столи
		for i = 1, 3 do
			local labTable = Instance.new("Part")
			labTable.Name = "LabTable" .. i
			labTable.Size = Vector3.new(6, 2, 3)
			labTable.Position = compartment.Position + 
				Vector3.new(-10 + (i-1) * 10, -3, 0)
			labTable.Anchored = true
			labTable.Material = Enum.Material.Metal
			labTable.Color = Color3.fromRGB(200, 200, 200)
			labTable.Parent = compartment
			
			-- Обладнання на столах
			local equipment = Instance.new("Part")
			equipment.Name = "Equipment" .. i
			equipment.Size = Vector3.new(2, 2, 2)
			equipment.Position = labTable.Position + Vector3.new(0, 2, 0)
			equipment.Anchored = true
			equipment.Material = Enum.Material.Glass
			equipment.Color = Color3.fromRGB(100, 255, 100)
			equipment.Transparency = 0.5
			equipment.Parent = compartment
		end
		
	elseif config.name == "PowerGenerator" then
		-- Головний генератор
		local generator = Instance.new("Part")
		generator.Name = "MainGenerator"
		generator.Size = Vector3.new(10, 8, 10)
		generator.Position = compartment.Position
		generator.Anchored = true
		generator.Material = Enum.Material.Metal
		generator.Color = Color3.fromRGB(100, 100, 100)
		generator.Parent = compartment
		
		-- Енергетичні трубки
		for i = 1, 4 do
			local pipe = Instance.new("Part")
			pipe.Name = "EnergyPipe" .. i
			pipe.Size = Vector3.new(1, 1, 15)
			local angle = i * math.pi / 2
			pipe.Position = compartment.Position + 
				Vector3.new(math.sin(angle) * 8, 0, math.cos(angle) * 8)
			pipe.Orientation = Vector3.new(0, i * 90, 0)
			pipe.Anchored = true
			pipe.Material = Enum.Material.Neon
			pipe.Color = Color3.fromRGB(255, 150, 0)
			pipe.Parent = compartment
		end
		
	elseif config.name == "StorageBay" then
		-- Контейнери для зберігання
		for i = 1, 3 do
			for j = 1, 3 do
				local container = Instance.new("Part")
				container.Name = "Container_" .. i .. "_" .. j
				container.Size = Vector3.new(5, 5, 5)
				container.Position = compartment.Position + 
					Vector3.new(-8 + (i-1) * 8, -2, -8 + (j-1) * 8)
				container.Anchored = true
				container.Material = Enum.Material.Metal
				container.Color = Color3.fromRGB(100 + i * 20, 100 + j * 20, 100)
				container.Parent = compartment
			end
		end
		
	elseif config.name == "MedicalBay" then
		-- Медичні ліжка
		for i = 1, 3 do
			local medBed = Instance.new("Part")
			medBed.Name = "MedicalBed" .. i
			medBed.Size = Vector3.new(6, 1, 2.5)
			medBed.Position = compartment.Position + 
				Vector3.new(-7 + (i-1) * 7, -4, 5)
			medBed.Anchored = true
			medBed.Material = Enum.Material.SmoothPlastic
			medBed.Color = Color3.fromRGB(255, 255, 255)
			medBed.Parent = compartment
		end
		
		-- Медичне обладнання
		local scanner = Instance.new("Part")
		scanner.Name = "MedicalScanner"
		scanner.Size = Vector3.new(6, 5, 6)
		scanner.Position = compartment.Position + Vector3.new(0, -2, -5)
		scanner.Anchored = true
		scanner.Material = Enum.Material.Metal
		scanner.Color = Color3.fromRGB(200, 200, 255)
		scanner.Parent = compartment
		
	elseif config.name == "Engineering" then
		-- Панелі керування
		for i = 1, 4 do
			local panel = Instance.new("Part")
			panel.Name = "ControlPanel" .. i
			panel.Size = Vector3.new(4, 3, 0.5)
			local angle = i * math.pi / 2
			panel.Position = compartment.Position + 
				Vector3.new(math.sin(angle) * 8, -2, math.cos(angle) * 8)
			panel.Orientation = Vector3.new(0, i * 90 + 180, 0)
			panel.Anchored = true
			panel.Material = Enum.Material.SmoothPlastic
			panel.Color = Color3.fromRGB(50, 50, 50)
			panel.Parent = compartment
			
			-- Кнопки на панелях
			for j = 1, 4 do
				local button = Instance.new("Part")
				button.Name = "Button" .. j
				button.Size = Vector3.new(0.5, 0.5, 0.2)
				button.Position = panel.Position + 
					Vector3.new(-1.5 + j, 0, -0.4)
				button.Orientation = panel.Orientation
				button.Anchored = true
				button.Material = Enum.Material.Neon
				button.Color = Color3.fromRGB(255, j * 50, 0)
				button.Parent = compartment
			end
		end
		
	elseif config.name == "Hydroponics" then
		-- Грядки для рослин
		for i = 1, 2 do
			for j = 1, 3 do
				local plantBed = Instance.new("Part")
				plantBed.Name = "PlantBed_" .. i .. "_" .. j
				plantBed.Size = Vector3.new(6, 1, 3)
				plantBed.Position = compartment.Position + 
					Vector3.new(-7 + (i-1) * 15, -4, -6 + (j-1) * 6)
				plantBed.Anchored = true
				plantBed.Material = Enum.Material.Grass
				plantBed.Color = Color3.fromRGB(50, 150, 50)
				plantBed.Parent = compartment
				
				-- Рослини
				local plant = Instance.new("Part")
				plant.Name = "Plant_" .. i .. "_" .. j
				plant.Size = Vector3.new(0.5, 2, 0.5)
				plant.Position = plantBed.Position + Vector3.new(0, 1.5, 0)
				plant.Anchored = true
				plant.Material = Enum.Material.Grass
				plant.Color = Color3.fromRGB(0, 255, 0)
				plant.Parent = compartment
			end
		end
		
		-- Система поливу
		local waterSystem = Instance.new("Part")
		waterSystem.Name = "WaterSystem"
		waterSystem.Size = Vector3.new(15, 0.5, 15)
		waterSystem.Position = compartment.Position + Vector3.new(0, 1, 0)
		waterSystem.Anchored = true
		waterSystem.Material = Enum.Material.Metal
		waterSystem.Color = Color3.fromRGB(100, 200, 255)
		waterSystem.Transparency = 0.9
		waterSystem.Parent = compartment
		
	elseif config.name == "DockingBay" then
		-- Платформа для стикування
		local dockingPlatform = Instance.new("Part")
		dockingPlatform.Name = "DockingPlatform"
		dockingPlatform.Size = Vector3.new(15, 1, 15)
		dockingPlatform.Position = compartment.Position + Vector3.new(0, -4, 0)
		dockingPlatform.Anchored = true
		dockingPlatform.Material = Enum.Material.Metal
		dockingPlatform.Color = Color3.fromRGB(100, 100, 100)
		dockingPlatform.Parent = compartment
		
		-- Механізми стикування
		for i = 1, 4 do
			local dockingArm = Instance.new("Part")
			dockingArm.Name = "DockingArm" .. i
			dockingArm.Size = Vector3.new(1, 5, 1)
			local angle = i * math.pi / 2
			dockingArm.Position = dockingPlatform.Position + 
				Vector3.new(math.sin(angle) * 6, 3, math.cos(angle) * 6)
			dockingArm.Anchored = true
			dockingArm.Material = Enum.Material.Metal
			dockingArm.Color = Color3.fromRGB(150, 150, 150)
			dockingArm.Parent = compartment
		end
	end
end

-- Головна функція для створення всієї космічної станції
function SpaceStationBuilder:BuildSpaceStation()
	-- Перевіряємо чи існує вже космічна станція, якщо так - видаляємо
	local existingStation = game.Workspace:FindFirstChild("SpaceStation")
	if existingStation then
		existingStation:Destroy()
		print("Видалено існуючу космічну станцію")
	end
	
	-- Створюємо батьківський об'єкт для станції
	local spaceStation = Instance.new("Folder")
	spaceStation.Name = "SpaceStation"
	spaceStation.Parent = game.Workspace
	
	-- Створюємо всі відсіки
	local compartments = {}
	for _, config in ipairs(COMPARTMENTS_CONFIG) do
		compartments[config.name] = self:CreateCompartment(config)
	end
	
	-- Створюємо переходи між відсіками (центральний до всіх)
	local centerCompartment = compartments["CommandCenter"]
	for name, compartment in pairs(compartments) do
		if name ~= "CommandCenter" then
			self:CreateCorridor(centerCompartment, compartment)
		end
	end
	
	-- Додаткові коридори між суміжними відсіками
	self:CreateCorridor(compartments["LivingQuarters"], compartments["MedicalBay"])
	self:CreateCorridor(compartments["ResearchLab"], compartments["Engineering"])
	self:CreateCorridor(compartments["PowerGenerator"], compartments["Engineering"])
	self:CreateCorridor(compartments["StorageBay"], compartments["Hydroponics"])
	self:CreateCorridor(compartments["DockingBay"], compartments["StorageBay"])
	
	print("Космічну станцію збудовано!")
	return spaceStation
end

return SpaceStationBuilder
