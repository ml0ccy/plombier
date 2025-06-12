-- Подключаем сервисы
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

-- Получаем локального игрока
local player = Players.LocalPlayer
local character = player.Character
local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
local humanoid = character and character:FindFirstChild("Humanoid")

-- Переменные для функций
local noClipEnabled = false
local flyEnabled = false
local airJumpEnabled = false
local spinnerEnabled = false
local flySpeed = 50
local spinnerSpeed = 50
local isInvisible = false
local guiVisible = true

-- Создаем GUI
local gui = Instance.new("ScreenGui")
gui.Name = "CheatMenu"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

-- Размытый фон
local blur = Instance.new("BlurEffect")
blur.Size = 10
blur.Parent = game:GetService("Lighting")

-- Основной фрейм
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 480)
frame.Position = UDim2.new(0.5, -175, 0.5, -240)
frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
frame.BackgroundTransparency = 0.7
frame.BorderSizePixel = 0
frame.Parent = gui
local uiGradient = Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 100, 100))
}
uiGradient.Rotation = 45
uiGradient.Parent = frame
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = frame

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Cheat Menu"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextStrokeTransparency = 0.8
title.Parent = frame

-- Координаты
local coordsLabel = Instance.new("TextLabel")
coordsLabel.Size = UDim2.new(0, 120, 0, 15)
coordsLabel.Position = UDim2.new(0, 10, 0, 45)
coordsLabel.BackgroundTransparency = 1
coordsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
coordsLabel.TextSize = 10
coordsLabel.Font = Enum.Font.SourceSans
coordsLabel.TextXAlignment = Enum.TextXAlignment.Left
coordsLabel.Parent = frame

-- Обновление координат
RunService.Heartbeat:Connect(function()
    if character and humanoidRootPart then
        local pos = humanoidRootPart.Position
        coordsLabel.Text = string.format("X: %.1f Y: %.1f Z: %.1f", pos.X, pos.Y, pos.Z)
    else
        coordsLabel.Text = "X: N/A Y: N/A Z: N/A"
    end
end)

-- Поле для скорости
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 100, 0, 25)
speedLabel.Position = UDim2.new(0, 10, 0, 70)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Скорость:"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextSize = 14
speedLabel.Font = Enum.Font.SourceSans
speedLabel.Parent = frame

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0, 100, 0, 25)
speedInput.Position = UDim2.new(0, 120, 0, 70)
speedInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
speedInput.BackgroundTransparency = 0.8
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.Text = "16"
speedInput.TextSize = 14
speedInput.Font = Enum.Font.SourceSans
speedInput.Parent = frame
local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 5)
speedCorner.Parent = speedInput

-- Поле для скорости спиннера
local spinnerSpeedLabel = Instance.new("TextLabel")
spinnerSpeedLabel.Size = UDim2.new(0, 100, 0, 25)
spinnerSpeedLabel.Position = UDim2.new(0, 10, 0, 100)
spinnerSpeedLabel.BackgroundTransparency = 1
spinnerSpeedLabel.Text = "Скорость спин:"
spinnerSpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
spinnerSpeedLabel.TextSize = 14
spinnerSpeedLabel.Font = Enum.Font.SourceSans
spinnerSpeedLabel.Parent = frame

local spinnerSpeedInput = Instance.new("TextBox")
spinnerSpeedInput.Size = UDim2.new(0, 100, 0, 25)
spinnerSpeedInput.Position = UDim2.new(0, 120, 0, 100)
spinnerSpeedInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
spinnerSpeedInput.BackgroundTransparency = 0.8
spinnerSpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
spinnerSpeedInput.Text = "50"
spinnerSpeedInput.TextSize = 14
spinnerSpeedInput.Font = Enum.Font.SourceSans
spinnerSpeedInput.Parent = frame
local spinnerSpeedCorner = Instance.new("UICorner")
spinnerSpeedCorner.CornerRadius = UDim.new(0, 5)
spinnerSpeedCorner.Parent = spinnerSpeedInput

-- Поля для координат
local xLabel = Instance.new("TextLabel")
xLabel.Size = UDim2.new(0, 30, 0, 25)
xLabel.Position = UDim2.new(0, 10, 0, 140)
xLabel.BackgroundTransparency = 1
xLabel.Text = "X:"
xLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
xLabel.TextSize = 14
xLabel.Font = Enum.Font.SourceSans
xLabel.Parent = frame

local xInput = Instance.new("TextBox")
xInput.Size = UDim2.new(0, 70, 0, 25)
xInput.Position = UDim2.new(0, 40, 0, 140)
xInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
xInput.BackgroundTransparency = 0.8
xInput.TextColor3 = Color3.fromRGB(255, 255, 255)
xInput.Text = "0"
xInput.TextSize = 14
xInput.Font = Enum.Font.SourceSans
xInput.Parent = frame
local xCorner = Instance.new("UICorner")
xCorner.CornerRadius = UDim.new(0, 5)
xCorner.Parent = xInput

local yLabel = Instance.new("TextLabel")
yLabel.Size = UDim2.new(0, 30, 0, 25)
yLabel.Position = UDim2.new(0, 120, 0, 140)
yLabel.BackgroundTransparency = 1
yLabel.Text = "Y:"
yLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
yLabel.TextSize = 14
yLabel.Font = Enum.Font.SourceSans
yLabel.Parent = frame

local yInput = Instance.new("TextBox")
yInput.Size = UDim2.new(0, 70, 0, 25)
yInput.Position = UDim2.new(0, 150, 0, 140)
yInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
yInput.BackgroundTransparency = 0.8
yInput.TextColor3 = Color3.fromRGB(255, 255, 255)
yInput.Text = "50"
yInput.TextSize = 14
yInput.Font = Enum.Font.SourceSans
yInput.Parent = frame
local yCorner = Instance.new("UICorner")
yCorner.CornerRadius = UDim.new(0, 5)
yCorner.Parent = yInput

local zLabel = Instance.new("TextLabel")
zLabel.Size = UDim2.new(0, 30, 0, 25)
zLabel.Position = UDim2.new(0, 230, 0, 140)
zLabel.BackgroundTransparency = 1
zLabel.Text = "Z:"
zLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
zLabel.TextSize = 14
zLabel.Font = Enum.Font.SourceSans
zLabel.Parent = frame

local zInput = Instance.new("TextBox")
zInput.Size = UDim2.new(0, 70, 0, 25)
zInput.Position = UDim2.new(0, 260, 0, 140)
zInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
zInput.BackgroundTransparency = 0.8
zInput.TextColor3 = Color3.fromRGB(255, 255, 255)
zInput.Text = "0"
zInput.TextSize = 14
zInput.Font = Enum.Font.SourceSans
zInput.Parent = frame
local zCorner = Instance.new("UICorner")
zCorner.CornerRadius = UDim.new(0, 5)
zCorner.Parent = zInput

-- Кнопка телепорта
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0, 100, 0, 30)
teleportButton.Position = UDim2.new(0, 125, 0, 180)
teleportButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
teleportButton.BackgroundTransparency = 0.3
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Text = "Телепорт"
teleportButton.TextSize = 14
teleportButton.Font = Enum.Font.Gotham
teleportButton.Parent = frame
local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0, 5)
teleportCorner.Parent = teleportButton

-- Кнопка невидимости
local invisibleButton = Instance.new("TextButton")
invisibleButton.Size = UDim2.new(0, 100, 0, 30)
invisibleButton.Position = UDim2.new(0, 125, 0, 220)
invisibleButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
invisibleButton.BackgroundTransparency = 0.3
invisibleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
invisibleButton.Text = "Невидимость: Выкл"
invisibleButton.TextSize = 14
invisibleButton.Font = Enum.Font.Gotham
invisibleButton.Parent = frame
local invisibleCorner = Instance.new("UICorner")
invisibleCorner.CornerRadius = UDim.new(0, 5)
invisibleCorner.Parent = invisibleButton

-- Кнопки для NoClip, Fly, AirJump, Spinner
local noClipButton = Instance.new("TextButton")
noClipButton.Size = UDim2.new(0, 80, 0, 30)
noClipButton.Position = UDim2.new(0, 10, 0, 260)
noClipButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
noClipButton.BackgroundTransparency = 0.3
noClipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noClipButton.Text = "NoClip (N)"
noClipButton.TextSize = 14
noClipButton.Font = Enum.Font.Gotham
noClipButton.Parent = frame
local noClipCorner = Instance.new("UICorner")
noClipCorner.CornerRadius = UDim.new(0, 5)
noClipCorner.Parent = noClipButton

local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 80, 0, 30)
flyButton.Position = UDim2.new(0, 95, 0, 260)
flyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
flyButton.BackgroundTransparency = 0.3
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.Text = "Fly (F)"
flyButton.TextSize = 14
flyButton.Font = Enum.Font.Gotham
flyButton.Parent = frame
local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 5)
flyCorner.Parent = flyButton

local airJumpButton = Instance.new("TextButton")
airJumpButton.Size = UDim2.new(0, 80, 0, 30)
airJumpButton.Position = UDim2.new(0, 180, 0, 260)
airJumpButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
airJumpButton.BackgroundTransparency = 0.3
airJumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
airJumpButton.Text = "AirJump (J)"
airJumpButton.TextSize = 14
airJumpButton.Font = Enum.Font.Gotham
airJumpButton.Parent = frame
local airJumpCorner = Instance.new("UICorner")
airJumpCorner.CornerRadius = UDim.new(0, 5)
airJumpCorner.Parent = airJumpButton

local spinnerButton = Instance.new("TextButton")
spinnerButton.Size = UDim2.new(0, 80, 0, 30)
spinnerButton.Position = UDim2.new(0, 265, 0, 260)
spinnerButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
spinnerButton.BackgroundTransparency = 0.3
spinnerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
spinnerButton.Text = "Spinner (P)"
spinnerButton.TextSize = 14
spinnerButton.Font = Enum.Font.Gotham
spinnerButton.Parent = frame
local spinnerCorner = Instance.new("UICorner")
spinnerCorner.CornerRadius = UDim.new(0, 5)
spinnerCorner.Parent = spinnerButton

-- Выпадающий список игроков
local playerList = Instance.new("ScrollingFrame")
playerList.Size = UDim2.new(0, 330, 0, 150)
playerList.Position = UDim2.new(0, 10, 0, 310)
playerList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
playerList.BackgroundTransparency = 0.8
playerList.ScrollBarThickness = 5
playerList.Parent = frame
local playerListCorner = Instance.new("UICorner")
playerListCorner.CornerRadius = UDim.new(0, 5)
playerListCorner.Parent = playerList

-- Функция для обновления списка игроков
local function updatePlayerList()
    playerList:ClearAllChildren()
    local yOffset = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, -10, 0, 30)
            button.Position = UDim2.new(0, 5, 0, yOffset)
            button.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
            button.BackgroundTransparency = 0.3
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.Text = p.Name
            button.TextSize = 14
            button.Font = Enum.Font.Gotham
            button.Parent = playerList
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 5)
            buttonCorner.Parent = button
            button.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and humanoidRootPart then
                    humanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
                end
            end)
            yOffset = yOffset + 35
        end
    end
    playerList.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

-- Обновляем список игроков при входе/выходе
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
updatePlayerList()

-- Функция изменения скорости
speedInput.FocusLost:Connect(function()
    if humanoid then
        local speed = tonumber(speedInput.Text)
        if speed then
            humanoid.WalkSpeed = speed
        end
    end
end)

-- Функция изменения скорости спиннера
spinnerSpeedInput.FocusLost:Connect(function()
    local speed = tonumber(spinnerSpeedInput.Text)
    if speed then
        spinnerSpeed = math.clamp(speed, 0, 500)
    end
end)

-- Функция телепортации
teleportButton.MouseButton1Click:Connect(function()
    if humanoidRootPart then
        local x = tonumber(xInput.Text) or 0
        local y = tonumber(yInput.Text) or 50
        local z = tonumber(zInput.Text) or 0
        humanoidRootPart.CFrame = CFrame.new(x, y, z)
    end
end)

-- Функция невидимости
invisibleButton.MouseButton1Click:Connect(function()
    if not isInvisible then
        isInvisible = true
        invisibleButton.Text = "Невидимость: Вкл"
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("Decal") then
                    part.Transparency = 1
                end
            end
            if humanoid then
                humanoid.WalkSpeed = 0
            end
        end
    else
        isInvisible = false
        invisibleButton.Text = "Невидимость: Выкл"
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = part.Name == "HumanoidRootPart" and 1 or 0
                elseif part:IsA("Decal") then
                    part.Transparency = 0
                end
            end
            if humanoid then
                humanoid.WalkSpeed = tonumber(speedInput.Text) or 16
            end
        end
    end
end)

-- Функция NoClip
noClipButton.MouseButton1Click:Connect(function()
    noClipEnabled = not noClipEnabled
    noClipButton.Text = "NoClip (N): " .. (noClipEnabled and "Вкл" or "Выкл")
end)

RunService.Stepped:Connect(function()
    if noClipEnabled and character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Функция полёта
flyButton.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    flyButton.Text = "Fly (F): " .. (flyEnabled and "Вкл" or "Выкл")
    if flyEnabled and humanoidRootPart then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = humanoidRootPart
        while flyEnabled and humanoidRootPart do
            local moveDirection = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + humanoidRootPart.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - humanoidRootPart.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection - humanoidRootPart.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + humanoidRootPart.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDirection = moveDirection + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveDirection = moveDirection - Vector3.new(0, 1, 0)
            end
            bodyVelocity.Velocity = moveDirection * flySpeed
            wait()
        end
        bodyVelocity:Destroy()
    end
end)

-- Функция AirJump
airJumpButton.MouseButton1Click:Connect(function()
    airJumpEnabled = not airJumpEnabled
    airJumpButton.Text = "AirJump (J): " .. (airJumpEnabled and "Вкл" or "Выкл")
end)

UserInputService.JumpRequest:Connect(function()
    if airJumpEnabled and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Функция спиннера
local spinnerConnection
local initialHRPPosition -- Начальная позиция HumanoidRootPart при активации
local rotationAxis = Vector3.new(0, 0, 1) -- Ось, на которую смотрит "вентилятор" (стена, например, по Z)
local rotationDirection = -1 -- -1 для вращения по часовой стрелке, 1 для против часовой
local currentRotationAngle = 0 -- Текущий угол вращения вокруг этой оси

spinnerButton.MouseButton1Click:Connect(function()
    spinnerEnabled = not spinnerEnabled
    spinnerButton.Text = "Spinner (P): " .. (spinnerEnabled and "Вкл" or "Выкл")

    if spinnerEnabled then
        -- Отключаем другие физические эффекты
        if flyEnabled then
            flyButton:Activate()
        end
        if noClipEnabled then
            noClipButton:Activate()
        end

        -- Убедимся, что character и humanoidRootPart существуют
        if not character or not humanoidRootPart or not humanoid then
            warn("Character, HumanoidRootPart or Humanoid not found for Spinner function.")
            spinnerEnabled = false
            spinnerButton.Text = "Spinner (P): Выкл"
            return
        end

        -- Сохраняем начальную позицию HRP (точка "взлёта")
        initialHRPPosition = humanoidRootPart.Position + Vector3.new(0, 5, 0) -- Немного поднимаем
        currentRotationAngle = 0 -- Сбрасываем угол

        -- Проверка и удаление существующих BodyGyro и BodyVelocity/BodyPosition
        local existingGyro = humanoidRootPart:FindFirstChildOfClass("BodyGyro")
        if existingGyro then
            existingGyro:Destroy()
        end
        local existingVelocity = humanoidRootPart:FindFirstChildOfClass("BodyVelocity")
        if existingVelocity then
            existingVelocity:Destroy()
        end
        local existingPosition = humanoidRootPart:FindFirstChildOfClass("BodyPosition")
        if existingPosition then
            existingPosition:Destroy()
        end

        -- Создаем BodyGyro для контроля ориентации
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro.P = 10000 
        bodyGyro.Parent = humanoidRootPart
        humanoid.PlatformStand = true -- Замораживаем персонажа

        -- Создаем BodyPosition для удержания на месте
        local bodyPosition = Instance.new("BodyPosition")
        bodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyPosition.Position = initialHRPPosition
        bodyPosition.Parent = humanoidRootPart

        -- Отключаем старое соединение, если оно есть
        if spinnerConnection then
            spinnerConnection:Disconnect()
            spinnerConnection = nil
        end

        -- Вращение как лопасть вентилятора, смотрящего на стену (с сохранением центра HRP)
        spinnerConnection = RunService.RenderStepped:Connect(function(delta)
            if spinnerEnabled and humanoidRootPart and humanoid then
                currentRotationAngle = currentRotationAngle + spinnerSpeed * delta * rotationDirection
                
                local fixedLookVector = rotationAxis -- Лицо смотрит на стену (например, +Z)
                local fixedRightVector = Vector3.new(0, -1, 0) -- Правый бок смотрит вниз (к полу)
                local fixedUpVector = fixedLookVector:Cross(fixedRightVector) -- Голова вверх/вниз по кругу
                
                local baseOrientationCFrame = CFrame.fromMatrix(Vector3.new(0,0,0), fixedRightVector, fixedUpVector, -fixedLookVector)
                
                local rotationCFrame = CFrame.fromAxisAngle(rotationAxis, math.rad(currentRotationAngle))
                
                local finalCFrame = CFrame.new(initialHRPPosition) * rotationCFrame * baseOrientationCFrame
                
                local fixedLookVector = rotationAxis 
                
                local rightX = math.cos(math.rad(currentRotationAngle + 90)) -- Сдвиг на 90, чтобы он был "боком"
                local rightY = math.sin(math.rad(currentRotationAngle + 90))
                local rightVector = Vector3.new(rightX, rightY, 0).Unit * rotationDirection -- правый бок "вниз" по кругу
                
                local upX = math.cos(math.rad(currentRotationAngle))
                local upY = math.sin(math.rad(currentRotationAngle))
                local upVector = Vector3.new(upX, upY, 0).Unit * rotationDirection -- голова "вверх" по кругу
                
                local fanRotation = CFrame.Angles(0, 0, math.rad(currentRotationAngle * rotationDirection))
                
                local bladeTiltAndDirection = CFrame.Angles(math.rad(-90), math.rad(90), 0) 
                
                local finalCFrame = CFrame.new(initialHRPPosition) * fanRotation * bladeTiltAndDirection
                
                bodyGyro.CFrame = finalCFrame
                bodyPosition.Position = initialHRPPosition -- Удерживаем HRP в фиксированной точке

            else
                -- Если спиннер отключен, разрываем соединение
                if spinnerConnection then
                    spinnerConnection:Disconnect()
                    spinnerConnection = nil
                end
            end
        end)
    else
        -- Отключаем спиннер
        if spinnerConnection then
            spinnerConnection:Disconnect()
            spinnerConnection = nil
        end
        if humanoidRootPart then
            local existingGyro = humanoidRootPart:FindFirstChildOfClass("BodyGyro")
            if existingGyro then
                existingGyro:Destroy()
            end
            local existingVelocity = humanoidRootPart:FindFirstChildOfClass("BodyVelocity")
            if existingVelocity then
                existingVelocity:Destroy()
            end
            local existingPosition = humanoidRootPart:FindFirstChildOfClass("BodyPosition")
            if existingPosition then
                existingPosition:Destroy()
            end
        end
        if humanoid then
            humanoid.PlatformStand = false -- Размораживаем персонажа
        end
    end
end)

-- Управление видимостью GUI и активацией функций
UserInputService.InputBegan:Connect(function(input, isProcessed)
    if not isProcessed then
        if input.KeyCode == Enum.KeyCode.K then
            guiVisible = not guiVisible
            frame.Visible = guiVisible
            blur.Enabled = guiVisible
        elseif input.KeyCode == Enum.KeyCode.N then
            noClipButton:Activate()
        elseif input.KeyCode == Enum.KeyCode.F then
            flyButton:Activate()
        elseif input.KeyCode == Enum.KeyCode.J then
            airJumpButton:Activate()
        elseif input.KeyCode == Enum.KeyCode.P then
            spinnerButton:Activate()
        end
    end
end)

-- Обновление персонажа при респавне
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")
    if isInvisible then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = 1
            end
        end
        humanoid.WalkSpeed = 0
    end
    if spinnerEnabled then
        spinnerButton:Activate()
        spinnerButton:Activate()
    end
end)

-- Удаление размытия и очистка спиннера при уничтожении GUI
gui.AncestryChanged:Connect(function()
    blur:Destroy()
    if spinnerConnection then
        spinnerConnection:Disconnect()
        spinnerConnection = nil
    end
    if humanoidRootPart then
        local existingGyro = humanoidRootPart:FindFirstChildOfClass("BodyGyro")
        if existingGyro then
            existingGyro:Destroy()
        end
        local existingVelocity = humanoidRootPart:FindFirstChildOfClass("BodyVelocity")
        if existingVelocity then
            existingVelocity:Destroy()
        end
    end
    if humanoid then
        humanoid.PlatformStand = false
    end
end)
