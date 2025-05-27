local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Налаштування камери
local function setupCamera()
    local camera = workspace.CurrentCamera
    camera.CameraType = Enum.CameraType.Scriptable
    
    -- Плавне слідкування камери за гравцем
    RunService.RenderStepped:Connect(function()
        if character and humanoid then
            local head = character:FindFirstChild("Head")
            if head then
                camera.CFrame = CFrame.new(head.Position + Vector3.new(0, 2, -10), head.Position)
            end
        end
    end)
end

-- Обробник появи персонажа
local function onCharacterAdded(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
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
    spawnEffect.Parent = character:WaitForChild("HumanoidRootPart")
    
    -- Видалення ефекту через 2 секунди
    delay(2, function()
        spawnEffect.Enabled = false
        spawnEffect:Destroy()
    end)
end

-- Підключення обробників
player.CharacterAdded:Connect(onCharacterAdded)
if character then
    onCharacterAdded(character)
end
