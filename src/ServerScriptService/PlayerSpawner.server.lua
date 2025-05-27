-- PlayerSpawner.server.lua
-- Цей скрипт гарантує, що гравці з'являються в середині космічної станції

local Players = game:GetService("Players")

-- Координати для спавну гравців у командному центрі
local SPAWN_POSITION = Vector3.new(0, 20, 0) -- Центр командного відсіку

-- Функція для телепортації гравця при входженні в гру
local function onPlayerAdded(player)
	-- Почекаємо, поки гравець повністю завантажиться
	player.CharacterAdded:Connect(function(character)
		print("Гравець " .. player.Name .. " з'явився в грі")
		
		-- Почекаємо секунду для повної завантаження персонажа
		task.wait(1)
		
		-- Перевіряємо, чи існує космічна станція
		local spaceStation = workspace:FindFirstChild("SpaceStation")
		if not spaceStation then
			warn("Космічна станція не знайдена!")
			return
		end
		
		-- Шукаємо командний центр
		local commandCenter = spaceStation:FindFirstChild("CommandCenter")
		if commandCenter then
			-- Телепортуємо гравця в командний центр
			character:SetPrimaryPartCFrame(CFrame.new(commandCenter.Position + Vector3.new(0, 5, 0)))
			print("Гравця " .. player.Name .. " телепортовано в командний центр")
		else
			-- Якщо командний центр не знайдено, телепортуємо на загальну позицію
			character:SetPrimaryPartCFrame(CFrame.new(SPAWN_POSITION))
			print("Гравця " .. player.Name .. " телепортовано на стандартну позицію")
		end
	end)
end

-- Підключаємо функцію для всіх нових гравців
Players.PlayerAdded:Connect(onPlayerAdded)

-- Також перевіряємо гравців, які вже в грі
for _, player in pairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end

print("Система спавну гравців ініціалізована")
