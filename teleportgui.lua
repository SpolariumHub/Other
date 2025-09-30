local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local SavedPosition = nil
local dragging = false
local dragInput, dragStart, startPos

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TeleportGUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 300)
Frame.Position = UDim2.new(0.5, -150, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
Frame.BorderSizePixel = 0
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.ClipsDescendants = true
Frame.Parent = ScreenGui
local UICornerFrame = Instance.new("UICorner")
UICornerFrame.CornerRadius = UDim.new(0,12)
UICornerFrame.Parent = Frame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1,0,0,40)
TitleBar.Position = UDim2.new(0,0,0,0)
TitleBar.BackgroundColor3 = Color3.fromRGB(60,60,70)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Frame
local UICornerTitle = Instance.new("UICorner")
UICornerTitle.CornerRadius = UDim.new(0,12)
UICornerTitle.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0,10,0,0)
Title.BackgroundTransparency = 1
Title.Text = "🛸 Teleport GUI"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
CloseBtn.Text = "✖"
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar
local UICornerClose = Instance.new("UICorner")
UICornerClose.CornerRadius = UDim.new(0,6)
UICornerClose.Parent = CloseBtn
CloseBtn.MouseButton1Click:Connect(function()
    Frame:Destroy()
end)

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -75, 0, 5)
MinBtn.BackgroundColor3 = Color3.fromRGB(100,100,150)
MinBtn.Text = "➖"
MinBtn.TextColor3 = Color3.fromRGB(255,255,255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.BorderSizePixel = 0
MinBtn.Parent = TitleBar
local UICornerMin = Instance.new("UICorner")
UICornerMin.CornerRadius = UDim.new(0,6)
UICornerMin.Parent = MinBtn

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1,0,1,-40)
Content.Position = UDim2.new(0,0,0,40)
Content.BackgroundTransparency = 1
Content.Parent = Frame

local function drag(frame)
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end
drag(Frame)

local function createButton(name, yPos, emoji)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 280, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(70,70,90)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.Text = emoji.." "..name
    btn.BorderSizePixel = 0
    btn.Parent = Content
    local uic = Instance.new("UICorner")
    uic.CornerRadius = UDim.new(0,8)
    uic.Parent = btn
    return btn
end

local SaveBtn = createButton("Save Location", 20, "💾")
local TeleportBtn = createButton("Teleport to Saved", 70, "🛸")
local CopyBtn = createButton("Copy Location", 120, "📋")

local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(0, 280, 0, 40)
InputBox.Position = UDim2.new(0,10,0,170)
InputBox.BackgroundColor3 = Color3.fromRGB(70,70,90)
InputBox.TextColor3 = Color3.fromRGB(255,255,255)
InputBox.PlaceholderText = "Paste coordinates x,y,z"
InputBox.Font = Enum.Font.Gotham
InputBox.TextSize = 16
InputBox.ClearTextOnFocus = false
InputBox.BorderSizePixel = 0
InputBox.Parent = Content
local UICornerInput = Instance.new("UICorner")
UICornerInput.CornerRadius = UDim.new(0,8)
UICornerInput.Parent = InputBox

local InputTeleportBtn = createButton("Teleport to Input", 220, "🚀")

local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    Content.Visible = not minimized
end)

SaveBtn.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        SavedPosition = LocalPlayer.Character.HumanoidRootPart.Position
        SaveBtn.Text = "💾 Saved!"
        wait(1)
        SaveBtn.Text = "💾 Save Location"
    end
end)

TeleportBtn.MouseButton1Click:Connect(function()
    if SavedPosition and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(SavedPosition)
    end
end)

CopyBtn.MouseButton1Click:Connect(function()
    if SavedPosition then
        setclipboard(tostring(SavedPosition))
        CopyBtn.Text = "📋 Copied!"
        wait(1)
        CopyBtn.Text = "📋 Copy Location"
    end
end)

InputTeleportBtn.MouseButton1Click:Connect(function()
    local text = InputBox.Text
    local x, y, z = text:match("%s*([%-%.%d]+)%s*,%s*([%-%.%d]+)%s*,%s*([%-%.%d]+)%s*")
    if x and y and z then
        local pos = Vector3.new(tonumber(x), tonumber(y), tonumber(z))
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
        end
    else
        InputBox.Text = "❌ Invalid format! x,y,z"
    end
end)