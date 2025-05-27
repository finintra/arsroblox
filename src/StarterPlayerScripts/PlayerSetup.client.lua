local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Налаштування камери
local function setupCamera()
    -- Використовуємо стандартну камеру від третьої особи
    camera.CameraType = Enum.CameraType.Custom
    
    -- Налаштовуємо мінімальну відстань камери
    player.CameraMinZoomDistance = 5
    player.CameraMaxZoomDistance = 20
    
    -- Налаштовуємо швидкість обертання камери
    player.RotationSpeed = 0.8
end

-- Налаштування персонажа
local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Налаштовуємо швидкість руху
    humanoid.WalkSpeed = 16
    humanoid.JumpPower = 50
    
    -- Додаємо ефект появи
    local spawnEffect = Instance.new("ParticleEmitter")
    spawnEffect.Texture = "rbxassetid://6101261905"
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
    
    -- Видаляємо ефект через 2 секунди
    task.delay(2, function()
        spawnEffect.Enabled = false
        spawnEffect:Destroy()
    end)
end

-- Додавання інформаційного інтерфейсу
local function createInfoUI()
    -- Створюємо основний фрейм
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MapInfoUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player.PlayerGui
    
    -- Створюємо інформаційний фрейм
    local infoFrame = Instance.new("Frame")
    infoFrame.Size = UDim2.new(0, 200, 0, 120)
    infoFrame.Position = UDim2.new(0, 10, 0, 10)
    infoFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    infoFrame.BackgroundTransparency = 0.7
    infoFrame.BorderSizePixel = 0
    infoFrame.Parent = screenGui
    
    -- Додаємо заголовок
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = "Sci-Fi Base"
    titleLabel.Parent = infoFrame
    
    -- Додаємо інформацію про поточну локацію
    local locationLabel = Instance.new("TextLabel")
    locationLabel.Size = UDim2.new(1, 0, 0, 20)
    locationLabel.Position = UDim2.new(0, 0, 0, 30)
    locationLabel.BackgroundTransparency = 1
    locationLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    locationLabel.TextSize = 14
    locationLabel.Font = Enum.Font.Gotham
    locationLabel.Text = "Location: Unknown"
    locationLabel.Parent = infoFrame
    
    -- Додаємо інформацію про гравців
    local playersLabel = Instance.new("TextLabel")
    playersLabel.Size = UDim2.new(1, 0, 0, 20)
    playersLabel.Position = UDim2.new(0, 0, 0, 50)
    playersLabel.BackgroundTransparency = 1
    playersLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    playersLabel.TextSize = 14
    playersLabel.Font = Enum.Font.Gotham
    playersLabel.Text = "Players: 0"
    playersLabel.Parent = infoFrame
    
    -- Додаємо кнопку закриття
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 20, 0, 20)
    closeButton.Position = UDim2.new(1, -25, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    closeButton.BackgroundTransparency = 0.5
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 14
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Text = "X"
    closeButton.Parent = infoFrame
    
    -- Додаємо обробник закриття
    closeButton.MouseButton1Click:Connect(function()
        infoFrame.Visible = not infoFrame.Visible
    end)
    
    -- Оновлюємо інформацію про гравців
    RunService.Heartbeat:Connect(function()
        playersLabel.Text = "Players: " .. #Players:GetPlayers()
        
        -- Визначаємо поточну локацію
        local character = player.Character
        if character then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local position = rootPart.Position
                
                -- Перевіряємо, в якій кімнаті знаходиться гравець
                local location = "Unknown"
                
                -- Перевіряємо кожну кімнату
                for _, room in pairs(workspace:GetChildren()) do
                    if room:IsA("BasePart") and room.Name:find("_Floor") then
                        local roomName = room.Name:gsub("_Floor", "")
                        local roomPosition = room.Position
                        local roomSize = room.Size
                        
                        -- Перевіряємо, чи гравець знаходиться в межах кімнати
                        if math.abs(position.X - roomPosition.X) < roomSize.X/2 and
                           math.abs(position.Z - roomPosition.Z) < roomSize.Z/2 then
                            location = roomName
                            break
                        end
                    end
                end
                
                -- Перевіряємо коридори
                if location == "Unknown" then
                    for _, corridor in pairs(workspace:GetChildren()) do
                        if corridor:IsA("BasePart") and corridor.Name:find("Corridor_") then
                            local corridorPosition = corridor.Position
                            local corridorSize = corridor.Size
                            
                            -- Перевіряємо, чи гравець знаходиться в межах коридору
                            if math.abs(position.X - corridorPosition.X) < corridorSize.X/2 and
                               math.abs(position.Z - corridorPosition.Z) < corridorSize.Z/2 then
                                location = "Corridor"
                                break
                            end
                        end
                    end
                end
                
                locationLabel.Text = "Location: " .. location
            end
        end
    end)
end

-- Ініціалізація
local function init()
    -- Налаштовуємо камеру
    setupCamera()
    
    -- Створюємо інтерфейс
    createInfoUI()
    
    -- Підключаємо обробник появи персонажа
    player.CharacterAdded:Connect(setupCharacter)
    
    -- Якщо персонаж вже існує
    if player.Character then
        setupCharacter(player.Character)
    end
end

-- Запускаємо ініціалізацію
init()
