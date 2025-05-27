-- PlayerSetup.client.lua
-- Клієнтський скрипт для налаштування гравця

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

-- Функція для налаштування камери гравця
local function setupCamera()
	-- Налаштовуємо камеру на першу особу
	local camera = workspace.CurrentCamera
	camera.CameraType = Enum.CameraType.Custom
	
	print("Камеру налаштовано")
end

-- Функція для налаштування гравця при респавні
local function characterAdded(character)
	print("Персонаж гравця завантажено")
	
	-- Надаємо невелику затримку для завантаження
	task.wait(0.5)
	
	-- Налаштовуємо камеру
	setupCamera()
	
	-- Перевіряємо, чи гравець знаходиться всередині станції
	local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
	if humanoidRootPart then
		local position = humanoidRootPart.Position
		
		-- Перевіряємо позицію відносно космічної станції
		local spaceStation = workspace:FindFirstChild("SpaceStation")
		if spaceStation and spaceStation:FindFirstChild("CommandCenter") then
			local commandCenter = spaceStation.CommandCenter
			local distance = (position - commandCenter.Position).Magnitude
			
			-- Якщо гравець далеко від командного центру, показуємо повідомлення
			if distance > 50 then
				print("Ви знаходитесь не на космічній станції, очікуйте телепортації...")
			else
				print("Ви успішно з'явились на космічній станції")
			end
		end
	end
end

-- Підключаємо функцію до події появи персонажа
localPlayer.CharacterAdded:Connect(characterAdded)

-- Викликаємо функцію для поточного персонажа, якщо він вже завантажений
if localPlayer.Character then
	characterAdded(localPlayer.Character)
end

print("Клієнтський скрипт налаштування гравця ініціалізовано")
