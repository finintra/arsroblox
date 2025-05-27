-- ForcePlayerSpawn.server.lua
-- Скрипт для примусового телепортування гравців у командний центр станції

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Координати командного центру
local COMMAND_CENTER_POSITION = Vector3.new(0, 25, 0)

-- Функція для розміщення гравця на станції
local function teleportToStation(player, attempt)
	attempt = attempt or 1
	if attempt > 10 then return end -- обмеження на кількість спроб
	
	-- Перевірка наявності персонажа
	local character = player.Character
	if not character then
		-- Якщо персонаж ще не створений, чекаємо і намагаємося знову
		task.wait(0.5)
		teleportToStation(player, attempt + 1)
		return
	end
	
	-- Пошук HumanoidRootPart
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		-- Якщо частина персонажа ще не створена, чекаємо і намагаємося знову
		task.wait(0.5)
		teleportToStation(player, attempt + 1)
		return
	end
	
	-- Пошук космічної станції
	local spaceStation = workspace:FindFirstChild("SpaceStation")
	if not spaceStation then
		warn("Космічна станція не знайдена, використовую стандартні координати")
		humanoidRootPart.CFrame = CFrame.new(COMMAND_CENTER_POSITION)
		return
	end
	
	-- Пошук командного центру
	local commandCenter = spaceStation:FindFirstChild("CommandCenter")
	if commandCenter then
		-- Телепортуємо гравця точно в командний центр
		humanoidRootPart.CFrame = CFrame.new(commandCenter.Position + Vector3.new(0, 3, 0))
		
		-- Встановлюємо нульову швидкість для запобігання падіння
		local velocity = humanoidRootPart:FindFirstChild("Velocity")
		if velocity then
			velocity.Velocity = Vector3.new(0, 0, 0)
		end
		
		print("Гравця " .. player.Name .. " успішно телепортовано на станцію")
	else
		-- Якщо командний центр не знайдений, використовуємо стандартні координати
		humanoidRootPart.CFrame = CFrame.new(COMMAND_CENTER_POSITION)
		print("Командний центр не знайдено, використовую стандартні координати")
	end
end

-- Видаляємо стандартні точки спавну
local function removeDefaultSpawnPoints()
	for _, spawnPoint in pairs(workspace:GetDescendants()) do
		if spawnPoint:IsA("SpawnLocation") and spawnPoint.Parent ~= workspace.SpaceStation then
			spawnPoint:Destroy()
			print("Видалено стандартну точку спавну")
		end
	end
end

-- Створюємо власну точку спавну в командному центрі
local function createCustomSpawnPoint()
	local spaceStation = workspace:FindFirstChild("SpaceStation")
	if not spaceStation then return end
	
	local commandCenter = spaceStation:FindFirstChild("CommandCenter")
	if not commandCenter then return end
	
	local existingSpawn = workspace:FindFirstChild("CustomSpawnPoint")
	if existingSpawn then existingSpawn:Destroy() end
	
	local spawnPoint = Instance.new("SpawnLocation")
	spawnPoint.Name = "CustomSpawnPoint"
	spawnPoint.Position = commandCenter.Position + Vector3.new(0, 3, 0)
	spawnPoint.Size = Vector3.new(10, 1, 10)
	spawnPoint.Anchored = true
	spawnPoint.CanCollide = false
	spawnPoint.Transparency = 1
	spawnPoint.Neutral = true
	spawnPoint.Parent = workspace
	
	print("Створено власну точку спавну в командному центрі")
end

-- Обробник появи гравця
local function onPlayerAdded(player)
	print("Гравець " .. player.Name .. " приєднався до гри")
	
	-- Чекаємо трохи, щоб станція встигла збудуватися
	task.wait(1)
	
	-- Телепортуємо гравця на станцію, коли з'явиться персонаж
	player.CharacterAdded:Connect(function(character)
		-- Затримка для гарантії завантаження всіх компонентів
		task.wait(1)
		teleportToStation(player)
	end)
	
	-- Якщо персонаж вже існує, телепортуємо його
	if player.Character then
		teleportToStation(player)
	end
end

-- Ініціалізація
local function initialize()
	print("Ініціалізація системи спавну гравців...")
	
	-- Чекаємо, щоб станція була повністю збудована
	task.wait(3)
	
	-- Видаляємо стандартні точки спавну і створюємо власну
	removeDefaultSpawnPoints()
	createCustomSpawnPoint()
	
	-- Підключаємо обробник для нових гравців
	Players.PlayerAdded:Connect(onPlayerAdded)
	
	-- Обробляємо вже присутніх гравців
	for _, player in pairs(Players:GetPlayers()) do
		onPlayerAdded(player)
	end
	
	print("Система спавну гравців готова")
end

-- Запускаємо ініціалізацію
initialize()
