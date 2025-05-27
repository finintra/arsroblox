local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Налаштування камери
local function setupCamera()
    -- Встановлюємо стандартну камеру від першої особи
    camera.CameraType = Enum.CameraType.Custom
    
    -- Налаштовуємо відстань камери
    local cameraOffset = Vector3.new(0, 2, -10)
    
    -- Оновлення позиції камери
    local function updateCamera()
        if not character or not humanoid or not humanoidRootPart then return end
        
        local targetCFrame = CFrame.new(humanoidRootPart.Position + Vector3.new(0, 3, 0))
        camera.CFrame = CFrame.new(
            targetCFrame.Position + cameraOffset,
            targetCFrame.Position
        )
    end
    
    -- Запускаємо оновлення камери
    RunService.RenderStepped:Connect(updateCamera)
end

-- Обробник появи персонажа
local function onCharacterAdded(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = 16 -- Звичайна швидкість ходьби
    humanoid.JumpPower = 50 -- Сила стрибка
    
    -- Чекаємо, поки завантажиться HumanoidRootPart
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Налаштовуємо камеру
    setupCamera()
    
    -- Додавання ефекту спавну
    local spawnEffect = Instance.new("ParticleEmitter")
    spawnEffect.Texture = "rbxassetid://296874871"
    spawnEffect.LightEmission = 1
    spawnEffect.LightInfluence = 0
    spawnEffect.Speed = NumberRange.new(5)
    spawnEffect.Lifetime = NumberRange.new(1)
    spawnEffect.Rate = 50
    spawnEffect.RotSpeed = NumberRange.new(0, 180)
    spawnEffect.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.5),
        NumberSequenceKeypoint.new(0.5, 1),
        NumberSequenceKeypoint.new(1, 0)
    })
    spawnEffect.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.8, 0.5),
        NumberSequenceKeypoint.new(1, 1)
    })
    spawnEffect.Parent = humanoidRootPart
    
    -- Видалення ефекту через 2 секунди
    delay(2, function()
        spawnEffect.Enabled = false
        spawnEffect:Destroy()
    end)
end

-- Обробник помилок
local function onError(message)
    print("Player setup error:", message)
end

-- Ініціалізація
xpcall(function()
    -- Підключення обробників
    player.CharacterAdded:Connect(onCharacterAdded)
    
    -- Якщо персонаж вже існує
    if character then
        onCharacterAdded(character)
    end
end, onError)
