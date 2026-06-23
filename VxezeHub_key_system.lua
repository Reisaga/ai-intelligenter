local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

if not isfolder("VxezeHub") then
    makefolder("VxezeHub")
end

local key_file = "VxezeHub/key.txt"

saveKeyToFile = function(key)
    writefile(key_file, key)
end

loadKeyFromFile = function()
    if isfile(key_file) then
        local f = readfile(key_file)
        if f and f ~= "" then
            return f
        end
    end
    return nil
end

deleteKeyFile = function()
    if isfile(key_file) then
        delfile(key_file)
    end
end

local NotificationHolder = Instance.new("ScreenGui")
NotificationHolder.Name = "NotificationHolder"
NotificationHolder.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NotificationHolder.Parent = game:GetService("CoreGui")

local NotificationContainer = Instance.new("Frame")
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.Position = UDim2.new(1, -20, 1, -20)
NotificationContainer.Size = UDim2.new(0, 340, 0, 500)
NotificationContainer.AnchorPoint = Vector2.new(1, 1)
NotificationContainer.Parent = NotificationHolder

local activeNotifications = {}

Notify = function(title, content, duration)
    spawn(function()
        local NotifFrame = Instance.new("Frame")
        local UICorner = Instance.new("UICorner")
        local UIStroke = Instance.new("UIStroke")
        local IconFrame = Instance.new("Frame")
        local IconCorner = Instance.new("UICorner")
        local IconImage = Instance.new("ImageLabel")
        local IconImageCorner = Instance.new("UICorner")
        local ContentFrame = Instance.new("Frame")
        local TitleLabel = Instance.new("TextLabel")
        local ContentLabel = Instance.new("TextLabel")
        local ProgressBar = Instance.new("Frame")
        local ProgressFill = Instance.new("Frame")
        local ProgressCorner = Instance.new("UICorner")
        local ProgressFillCorner = Instance.new("UICorner")

        NotifFrame.Size = UDim2.new(1, 0, 0, 75)
        NotifFrame.Position = UDim2.new(0, 350, 1, 0)
        NotifFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        NotifFrame.BorderSizePixel = 0
        NotifFrame.ClipsDescendants = false
        NotifFrame.Parent = NotificationContainer

        table.insert(activeNotifications, NotifFrame)

        UICorner.CornerRadius = UDim.new(0, 12)
        UICorner.Parent = NotifFrame

        UIStroke.Color = Color3.fromRGB(0, 255, 255)
        UIStroke.Thickness = 2
        UIStroke.Transparency = 0.3
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        UIStroke.Parent = NotifFrame

        IconFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        IconFrame.Size = UDim2.new(0, 50, 0, 50)
        IconFrame.Position = UDim2.new(0, 12, 0.5, 0)
        IconFrame.AnchorPoint = Vector2.new(0, 0.5)
        IconFrame.BorderSizePixel = 0
        IconFrame.Parent = NotifFrame

        IconCorner.CornerRadius = UDim.new(0, 10)
        IconCorner.Parent = IconFrame

        IconImage.Image = "rbxassetid://104202858258775"
        IconImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        IconImage.BackgroundTransparency = 1
        IconImage.Size = UDim2.new(1, -8, 1, -8)
        IconImage.Position = UDim2.new(0.5, 0, 0.5, 0)
        IconImage.AnchorPoint = Vector2.new(0.5, 0.5)
        IconImage.BorderSizePixel = 0
        IconImage.Parent = IconFrame

        IconImageCorner.CornerRadius = UDim.new(0, 8)
        IconImageCorner.Parent = IconImage

        ContentFrame.BackgroundTransparency = 1
        ContentFrame.Position = UDim2.new(0, 72, 0, 10)
        ContentFrame.Size = UDim2.new(1, -82, 1, -20)
        ContentFrame.Parent = NotifFrame

        TitleLabel.Font = Enum.Font.FredokaOne
        TitleLabel.Text = title
        TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
        TitleLabel.TextSize = 15
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.TextYAlignment = Enum.TextYAlignment.Top
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Position = UDim2.new(0, 0, 0, 0)
        TitleLabel.Size = UDim2.new(1, 0, 0, 18)
        TitleLabel.Parent = ContentFrame

        local TitleStroke = Instance.new("UIStroke")
        TitleStroke.Color = Color3.fromRGB(0, 0, 0)
        TitleStroke.Thickness = 1.5
        TitleStroke.Parent = TitleLabel

        ContentLabel.Font = Enum.Font.FredokaOne
        ContentLabel.Text = content
        ContentLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        ContentLabel.TextSize = 13
        ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
        ContentLabel.TextYAlignment = Enum.TextYAlignment.Top
        ContentLabel.TextWrapped = true
        ContentLabel.BackgroundTransparency = 1
        ContentLabel.Position = UDim2.new(0, 0, 0, 20)
        ContentLabel.Size = UDim2.new(1, 0, 1, -20)
        ContentLabel.Parent = ContentFrame

        ProgressBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        ProgressBar.BorderSizePixel = 0
        ProgressBar.Position = UDim2.new(0, 12, 1, -8)
        ProgressBar.Size = UDim2.new(1, -24, 0, 3)
        ProgressBar.Parent = NotifFrame

        ProgressCorner.CornerRadius = UDim.new(1, 0)
        ProgressCorner.Parent = ProgressBar

        ProgressFill.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
        ProgressFill.BorderSizePixel = 0
        ProgressFill.Size = UDim2.new(1, 0, 1, 0)
        ProgressFill.Parent = ProgressBar

        ProgressFillCorner.CornerRadius = UDim.new(1, 0)
        ProgressFillCorner.Parent = ProgressFill

        for i = #activeNotifications - 1, 1, -1 do
            local notif = activeNotifications[i]
            if notif and notif.Parent then
                local currentPos = notif.Position
                TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    Position = UDim2.new(currentPos.X.Scale, currentPos.X.Offset, currentPos.Y.Scale,
                        currentPos.Y.Offset - 85)
                }):Play()
            end
        end

        NotifFrame.Position = UDim2.new(0, 350, 1, 0)

        TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 0, 1, -85)
        }):Play()

        TweenService:Create(UIStroke,
            TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Transparency = 0,
                Thickness = 2.5
            }):Play()

        task.wait(0.5)

        TweenService:Create(UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            Transparency = 0.3,
            Thickness = 2
        }):Play()

        TweenService:Create(ProgressFill, TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 0, 1, 0)
        }):Play()

        task.wait(duration - 0.4)

        TweenService:Create(NotifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Position = UDim2.new(0, 350, NotifFrame.Position.Y.Scale, NotifFrame.Position.Y.Offset)
        }):Play()

        TweenService:Create(UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Transparency = 1
        }):Play()

        TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1
        }):Play()

        TweenService:Create(IconFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1
        }):Play()

        TweenService:Create(IconImage, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            ImageTransparency = 1
        }):Play()

        TweenService:Create(TitleLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            TextTransparency = 1
        }):Play()

        TweenService:Create(TitleStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Transparency = 1
        }):Play()

        TweenService:Create(ContentLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            TextTransparency = 1
        }):Play()

        TweenService:Create(ProgressBar, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1
        }):Play()

        TweenService:Create(ProgressFill, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1
        }):Play()

        task.wait(0.4)

        for i, notif in ipairs(activeNotifications) do
            if notif == NotifFrame then
                table.remove(activeNotifications, i)
                break
            end
        end

        NotifFrame:Destroy()
    end)
end

local function ___S(s)
    local b = {}
    for i = 1, #s do
        b[i] = string.char(string.byte(s, i))
    end
    return table.concat(b)
end

local API_BASE_URL = ___S("https://vxezehub.click")
local LINK4M_URL = ___S("https://vxezehub.click/api/link4m")
local HWID = game:GetService("RbxAnalyticsService"):GetClientId()

getHWID = function()
    return HWID
end

local function ___K()
    local s = {}
    for i = 1, 32 do
        s[i] = string.char(math.random(97, 122))
    end
    return table.concat(s)
end

local function ___V(key)
    local payload = HttpService:JSONEncode({
        key = key,
        hwid = getHWID()
    })
    local response = request({
        Url = API_BASE_URL .. ___S("/api/key/check"),
        Method = ___S("POST"),
        Headers = {[___S("Content-Type")] = ___S("application/json")},
        Body = payload
    })
    local decoded = HttpService:JSONDecode(response.Body)
    return decoded.valid == true, decoded.message or ___S(""), decoded.time_remaining
end

validateKeyWithServer = function(key)
    local r = {___V(key)}
    if r[1] then
        return r[1], r[2], r[3]
    end
    local url = API_BASE_URL .. ___S("/api/validate/key?key=") .. HttpService:UrlEncode(key) .. ___S("&hwid=") .. HttpService:UrlEncode(getHWID())
    local resp = game:HttpGet(url)
    local d = HttpService:JSONDecode(resp)
    return d.valid == true, d.message or ___S(""), d.time_remaining
end

loadImage = function(imageId)
    if not imageId or imageId == "" then
        return ""
    end
    if type(imageId) == "string" then
        if imageId:match("^https?://") then
            return imageId
        elseif imageId:match("^rbxassetid://") then
            return imageId
        elseif tonumber(imageId) then
            return "rbxassetid://" .. imageId
        end
    end
    return "rbxassetid://" .. tostring(imageId)
end

local KeyGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local Background = Instance.new("ImageLabel")
local UICorner_Background = Instance.new("UICorner")
local Character = Instance.new("ImageLabel")
local CharacterIcon = Instance.new("ImageLabel")
local UICorner_Icon = Instance.new("UICorner")
local TitleLabel = Instance.new("TextLabel")
local UIStroke_Title = Instance.new("UIStroke")
local SubTitleLabel = Instance.new("TextLabel")
local KeyInput = Instance.new("TextBox")
local UICorner_Input = Instance.new("UICorner")
local UIStroke_Input = Instance.new("UIStroke")

local GetKeyBtn = Instance.new("ImageLabel")
local UICorner_GetKey = Instance.new("UICorner")
local UIStroke_GetKey = Instance.new("UIStroke")
local GetKeyButton = Instance.new("TextButton")

local CheckKeyBtn = Instance.new("ImageLabel")
local UICorner_CheckKey = Instance.new("UICorner")
local UIStroke_CheckKey = Instance.new("UIStroke")
local CheckKeyButton = Instance.new("TextButton")

local DiscordBtn = Instance.new("ImageLabel")
local UICorner_Discord = Instance.new("UICorner")
local UIStroke_Discord = Instance.new("UIStroke")
local DiscordButton = Instance.new("TextButton")

local TutorialBtn = Instance.new("ImageLabel")
local UICorner_Tutorial = Instance.new("UICorner")
local UIStroke_Tutorial = Instance.new("UIStroke")
local TutorialButton = Instance.new("TextButton")

local ShadowFrame = Instance.new("ImageLabel")
local ShadowCorner = Instance.new("UICorner")

KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
KeyGui.Name = "KeySystemGui"
KeyGui.Parent = game:GetService("CoreGui")

ShadowFrame.Name = "ShadowFrame"
ShadowFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ShadowFrame.BackgroundTransparency = 0.6
ShadowFrame.Size = UDim2.new(1, 40, 1, 40)
ShadowFrame.Position = UDim2.new(0.5, -20, 0.5, -20)
ShadowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
ShadowFrame.ZIndex = 0
ShadowFrame.Image = "rbxassetid://3570695787"
ShadowFrame.ImageColor3 = Color3.fromRGB(0, 255, 255)
ShadowFrame.ImageTransparency = 0.7
ShadowFrame.ScaleType = Enum.ScaleType.Slice
ShadowFrame.SliceCenter = Rect.new(100, 100, 100, 100)
ShadowFrame.Parent = KeyGui

ShadowCorner.CornerRadius = UDim.new(0, 16)
ShadowCorner.Parent = ShadowFrame

MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Name = "MainFrame"
MainFrame.Parent = KeyGui

UICorner.CornerRadius = UDim.new(0, 16)
UICorner.Parent = MainFrame

UIStroke.Color = Color3.fromRGB(0, 255, 255)
UIStroke.Thickness = 3
UIStroke.Transparency = 0
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainFrame

Background.Image = loadImage("133093108462584")
Background.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Background.BackgroundTransparency = 1
Background.BorderColor3 = Color3.fromRGB(0, 0, 0)
Background.BorderSizePixel = 0
Background.Size = UDim2.new(1, 0, 1, 0)
Background.Name = "Background"
Background.ZIndex = 1
Background.Parent = MainFrame

UICorner_Background.CornerRadius = UDim.new(0, 16)
UICorner_Background.Parent = Background

Character.Image = loadImage("117730372760094")
Character.BackgroundTransparency = 1
Character.BorderSizePixel = 0
Character.Position = UDim2.new(1, 40, 0, -65)
Character.AnchorPoint = Vector2.new(1, 0)
Character.Size = UDim2.new(0, 220, 0, 250)
Character.ScaleType = Enum.ScaleType.Fit
Character.ZIndex = 2
Character.Name = "Character"
Character.Parent = MainFrame

CharacterIcon.Image = loadImage("104202858258775")
CharacterIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CharacterIcon.BackgroundTransparency = 1
CharacterIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
CharacterIcon.BorderSizePixel = 0
CharacterIcon.Position = UDim2.new(0, 18, 0, 18)
CharacterIcon.Size = UDim2.new(0, 42, 0, 42)
CharacterIcon.ZIndex = 3
CharacterIcon.Name = "CharacterIcon"
CharacterIcon.Parent = MainFrame

UICorner_Icon.CornerRadius = UDim.new(0, 8)
UICorner_Icon.Parent = CharacterIcon

TitleLabel.Font = Enum.Font.FredokaOne
TitleLabel.Text = "Vxeze Hub Key System"
TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
TitleLabel.TextSize = 22
TitleLabel.TextTransparency = 0
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TitleLabel.BorderSizePixel = 0
TitleLabel.Position = UDim2.new(0, 70, 0, 20)
TitleLabel.Size = UDim2.new(0, 240, 0, 30)
TitleLabel.ZIndex = 3
TitleLabel.Parent = MainFrame

UIStroke_Title.Color = Color3.fromRGB(0, 0, 0)
UIStroke_Title.Thickness = 2
UIStroke_Title.Transparency = 0
UIStroke_Title.Parent = TitleLabel

SubTitleLabel.Font = Enum.Font.FredokaOne
SubTitleLabel.Text = "Enter your key below to continue"
SubTitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SubTitleLabel.TextSize = 13
SubTitleLabel.TextTransparency = 0
SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
SubTitleLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SubTitleLabel.BackgroundTransparency = 1
SubTitleLabel.BorderSizePixel = 0
SubTitleLabel.Position = UDim2.new(0, 70, 0, 50)
SubTitleLabel.Size = UDim2.new(0, 240, 0, 18)
SubTitleLabel.ZIndex = 3
SubTitleLabel.Parent = MainFrame

KeyInput.Font = Enum.Font.FredokaOne
KeyInput.PlaceholderText = "Enter Key Here..."
KeyInput.Text = ""
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextSize = 16
KeyInput.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
KeyInput.BorderSizePixel = 0
KeyInput.Position = UDim2.new(0, 30, 0, 125)
KeyInput.Size = UDim2.new(0, 340, 0, 40)
KeyInput.ClearTextOnFocus = false
KeyInput.ZIndex = 3
KeyInput.Name = "KeyInput"
KeyInput.Parent = MainFrame

UICorner_Input.CornerRadius = UDim.new(0, 10)
UICorner_Input.Parent = KeyInput

UIStroke_Input.Color = Color3.fromRGB(0, 255, 255)
UIStroke_Input.Thickness = 2
UIStroke_Input.Transparency = 0
UIStroke_Input.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke_Input.Parent = KeyInput

GetKeyBtn.Image = loadImage("117928961549219")
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 150)
GetKeyBtn.BackgroundTransparency = 0
GetKeyBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
GetKeyBtn.BorderSizePixel = 0
GetKeyBtn.Position = UDim2.new(0, 30, 0, 195)
GetKeyBtn.Size = UDim2.new(0, 205, 0, 45)
GetKeyBtn.ZIndex = 3
GetKeyBtn.Name = "GetKeyBtn"
GetKeyBtn.Parent = MainFrame

UICorner_GetKey.CornerRadius = UDim.new(0, 10)
UICorner_GetKey.Parent = GetKeyBtn

UIStroke_GetKey.Color = Color3.fromRGB(70, 140, 200)
UIStroke_GetKey.Thickness = 2.5
UIStroke_GetKey.Transparency = 0
UIStroke_GetKey.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke_GetKey.Parent = GetKeyBtn

GetKeyButton.Font = Enum.Font.FredokaOne
GetKeyButton.Text = "Get Key"
GetKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GetKeyButton.TextSize = 16
GetKeyButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GetKeyButton.BackgroundTransparency = 1
GetKeyButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
GetKeyButton.BorderSizePixel = 0
GetKeyButton.Size = UDim2.new(1, 0, 1, 0)
GetKeyButton.ZIndex = 4
GetKeyButton.Name = "GetKeyButton"
GetKeyButton.Parent = GetKeyBtn

local UIStroke_GetKeyText = Instance.new("UIStroke")
UIStroke_GetKeyText.Color = Color3.fromRGB(0, 0, 0)
UIStroke_GetKeyText.Thickness = 2
UIStroke_GetKeyText.Transparency = 0
UIStroke_GetKeyText.Parent = GetKeyButton

CheckKeyBtn.Image = loadImage("122513747232289")
CheckKeyBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 150)
CheckKeyBtn.BackgroundTransparency = 0
CheckKeyBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
CheckKeyBtn.BorderSizePixel = 0
CheckKeyBtn.Position = UDim2.new(0, 265, 0, 195)
CheckKeyBtn.Size = UDim2.new(0, 205, 0, 45)
CheckKeyBtn.ZIndex = 3
CheckKeyBtn.Name = "CheckKeyBtn"
CheckKeyBtn.Parent = MainFrame

UICorner_CheckKey.CornerRadius = UDim.new(0, 10)
UICorner_CheckKey.Parent = CheckKeyBtn

UIStroke_CheckKey.Color = Color3.fromRGB(70, 140, 200)
UIStroke_CheckKey.Thickness = 2.5
UIStroke_CheckKey.Transparency = 0
UIStroke_CheckKey.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke_CheckKey.Parent = CheckKeyBtn

CheckKeyButton.Font = Enum.Font.FredokaOne
CheckKeyButton.Text = "Check Key"
CheckKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CheckKeyButton.TextSize = 16
CheckKeyButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CheckKeyButton.BackgroundTransparency = 1
CheckKeyButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
CheckKeyButton.BorderSizePixel = 0
CheckKeyButton.Size = UDim2.new(1, 0, 1, 0)
CheckKeyButton.ZIndex = 4
CheckKeyButton.Name = "CheckKeyButton"
CheckKeyButton.Parent = CheckKeyBtn

local UIStroke_CheckKeyText = Instance.new("UIStroke")
UIStroke_CheckKeyText.Color = Color3.fromRGB(0, 0, 0)
UIStroke_CheckKeyText.Thickness = 2
UIStroke_CheckKeyText.Transparency = 0
UIStroke_CheckKeyText.Parent = CheckKeyButton

DiscordBtn.Image = loadImage("122513747232289")
DiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
DiscordBtn.BackgroundTransparency = 0
DiscordBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
DiscordBtn.BorderSizePixel = 0
DiscordBtn.Position = UDim2.new(0, 30, 0, 270)
DiscordBtn.Size = UDim2.new(0, 205, 0, 45)
DiscordBtn.ZIndex = 3
DiscordBtn.Name = "DiscordBtn"
DiscordBtn.Parent = MainFrame

UICorner_Discord.CornerRadius = UDim.new(0, 10)
UICorner_Discord.Parent = DiscordBtn

UIStroke_Discord.Color = Color3.fromRGB(108, 121, 255)
UIStroke_Discord.Thickness = 2.5
UIStroke_Discord.Transparency = 0
UIStroke_Discord.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke_Discord.Parent = DiscordBtn

DiscordButton.Font = Enum.Font.FredokaOne
DiscordButton.Text = "Discord"
DiscordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordButton.TextSize = 16
DiscordButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
DiscordButton.BackgroundTransparency = 1
DiscordButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
DiscordButton.BorderSizePixel = 0
DiscordButton.Size = UDim2.new(1, 0, 1, 0)
DiscordButton.ZIndex = 4
DiscordButton.Name = "DiscordButton"
DiscordButton.Parent = DiscordBtn

local UIStroke_DiscordText = Instance.new("UIStroke")
UIStroke_DiscordText.Color = Color3.fromRGB(0, 0, 0)
UIStroke_DiscordText.Thickness = 2
UIStroke_DiscordText.Transparency = 0
UIStroke_DiscordText.Parent = DiscordButton

TutorialBtn.Image = loadImage("103629842357172")
TutorialBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 150)
TutorialBtn.BackgroundTransparency = 0
TutorialBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
TutorialBtn.BorderSizePixel = 0
TutorialBtn.Position = UDim2.new(0, 265, 0, 270)
TutorialBtn.Size = UDim2.new(0, 205, 0, 45)
TutorialBtn.ZIndex = 3
TutorialBtn.Name = "TutorialBtn"
TutorialBtn.Parent = MainFrame

UICorner_Tutorial.CornerRadius = UDim.new(0, 10)
UICorner_Tutorial.Parent = TutorialBtn

UIStroke_Tutorial.Color = Color3.fromRGB(200, 70, 200)
UIStroke_Tutorial.Thickness = 2.5
UIStroke_Tutorial.Transparency = 0
UIStroke_Tutorial.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke_Tutorial.Parent = TutorialBtn

TutorialButton.Font = Enum.Font.FredokaOne
TutorialButton.Text = "Tutorial"
TutorialButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TutorialButton.TextSize = 16
TutorialButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TutorialButton.BackgroundTransparency = 1
TutorialButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TutorialButton.BorderSizePixel = 0
TutorialButton.Size = UDim2.new(1, 0, 1, 0)
TutorialButton.ZIndex = 4
TutorialButton.Name = "TutorialButton"
TutorialButton.Parent = TutorialBtn

local UIStroke_TutorialText = Instance.new("UIStroke")
UIStroke_TutorialText.Color = Color3.fromRGB(0, 0, 0)
UIStroke_TutorialText.Thickness = 2
UIStroke_TutorialText.Transparency = 0
UIStroke_TutorialText.Parent = TutorialButton

local function setSLContentTransparency(val)
    local t = val == 1 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(150, 150, 150)
    Background.ImageTransparency = val
    Character.ImageTransparency = val
    CharacterIcon.ImageTransparency = val
    CharacterIcon.BackgroundTransparency = val
    TitleLabel.TextTransparency = val
    SubTitleLabel.TextTransparency = val
    KeyInput.TextTransparency = val
    KeyInput.BackgroundTransparency = val
    KeyInput.PlaceholderColor3 = t
    GetKeyBtn.ImageTransparency = val
    GetKeyBtn.BackgroundTransparency = val
    GetKeyButton.TextTransparency = val
    CheckKeyBtn.ImageTransparency = val
    CheckKeyBtn.BackgroundTransparency = val
    CheckKeyButton.TextTransparency = val
    DiscordBtn.ImageTransparency = val
    DiscordBtn.BackgroundTransparency = val
    DiscordButton.TextTransparency = val
    TutorialBtn.ImageTransparency = val
    TutorialBtn.BackgroundTransparency = val
    TutorialButton.TextTransparency = val
    UIStroke_Title.Transparency = val
    UIStroke_Input.Transparency = val
    UIStroke_GetKey.Transparency = val
    UIStroke_GetKeyText.Transparency = val
    UIStroke_CheckKey.Transparency = val
    UIStroke_CheckKeyText.Transparency = val
    UIStroke_Discord.Transparency = val
    UIStroke_DiscordText.Transparency = val
    UIStroke_Tutorial.Transparency = val
    UIStroke_TutorialText.Transparency = val
end

local particleEmitters = {}

local function start3DParticles()
    for i = 1, 3 do
        local p = Instance.new("Frame")
        p.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
        p.BackgroundTransparency = 0.7
        p.Size = UDim2.new(0, 4, 0, 4)
        p.Position = UDim2.new(math.random(0, 100) / 100, 0, math.random(0, 100) / 100, 0)
        p.BorderSizePixel = 0
        p.ZIndex = 10
        p.Parent = MainFrame

        local pc = Instance.new("UICorner")
        pc.CornerRadius = UDim.new(1, 0)
        pc.Parent = p

        local velX = (math.random() - 0.5) * 0.02
        local velY = -(math.random() * 0.015 + 0.005)
        local alpha = 0.7

        table.insert(particleEmitters, {frame = p, vx = velX, vy = velY, alpha = alpha})

        coroutine.wrap(function()
            while p.Parent do
                local d = particleEmitters[i]
                if d then
                    local px = p.Position.X.Scale + d.vx
                    local py = p.Position.Y.Scale + d.vy
                    if py < -0.05 then
                        py = 1.05
                        px = math.random(0, 100) / 100
                    end
                    if px < -0.05 or px > 1.05 then
                        px = math.random(0, 100) / 100
                        py = 1.05
                    end
                    p.Position = UDim2.new(px, 0, py, 0)
                end
                task.wait(0.05)
            end
        end)()
    end
end

local function stop3DParticles()
    for _, d in ipairs(particleEmitters) do
        if d.frame and d.frame.Parent then
            d.frame:Destroy()
        end
    end
    particleEmitters = {}
end

local tiltX = 0
local tiltY = 0
local targetTiltX = 0
local targetTiltY = 0

local function update3DTilt()
    RunService.RenderStepped:Connect(function()
        if not MainFrame or not MainFrame.Parent then return end
        tiltX = tiltX + (targetTiltX - tiltX) * 0.08
        tiltY = tiltY + (targetTiltY - tiltY) * 0.08
        local rot = math.clamp(tiltX * 3, -6, 6)
        MainFrame.Rotation = rot
        ShadowFrame.Rotation = rot * 0.5
        ShadowFrame.Position = UDim2.new(0.5 + tiltX * 0.02, -20 + tiltY * 0.5, 0.5 + tiltY * 0.02, -20 - tiltX * 0.5)
    end)
end

createSLOpenEffect = function()
    MainFrame.ClipsDescendants = true

    setSLContentTransparency(1)
    MainFrame.Size = UDim2.new(0, 4, 0, 4)
    MainFrame.BackgroundColor3 = Color3.fromRGB(0, 220, 255)
    MainFrame.BackgroundTransparency = 0
    UICorner.CornerRadius = UDim.new(1, 0)
    UIStroke.Transparency = 1
    UIStroke.Thickness = 3

    task.wait(0.15)

    TweenService:Create(UIStroke, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 0,
        Thickness = 4,
        Color = Color3.fromRGB(0, 255, 255)
    }):Play()

    TweenService:Create(MainFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.2
    }):Play()

    task.wait(0.1)

    TweenService:Create(MainFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundColor3 = Color3.fromRGB(0, 200, 255),
        BackgroundTransparency = 0
    }):Play()

    task.wait(0.12)

    UICorner.CornerRadius = UDim.new(0, 4)

    TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 500, 0, 4),
        BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    }):Play()

    TweenService:Create(UIStroke, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Transparency = 0,
        Thickness = 3,
        Color = Color3.fromRGB(0, 255, 255)
    }):Play()

    task.wait(0.35)

    local barGlow = TweenService:Create(UIStroke, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Thickness = 6,
        Transparency = 0
    })
    barGlow:Play()
    task.wait(0.08)
    TweenService:Create(UIStroke, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Thickness = 3,
        Transparency = 0.1
    }):Play()
    task.wait(0.1)

    UICorner.CornerRadius = UDim.new(0, 16)

    TweenService:Create(MainFrame, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 500, 0, 350),
        BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    }):Play()

    TweenService:Create(UIStroke, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Transparency = 0,
        Thickness = 3,
        Color = Color3.fromRGB(0, 255, 255)
    }):Play()

    task.wait(0.3)

    local scanline = Instance.new("Frame")
    scanline.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    scanline.BackgroundTransparency = 0.4
    scanline.Size = UDim2.new(1, 0, 0, 2)
    scanline.Position = UDim2.new(0, 0, 0, 0)
    scanline.ZIndex = 201
    scanline.BorderSizePixel = 0
    scanline.Parent = MainFrame

    TweenService:Create(scanline, TweenInfo.new(0.18, Enum.EasingStyle.Linear), {
        Position = UDim2.new(0, 0, 1, 0),
        BackgroundTransparency = 0.8
    }):Play()

    task.wait(0.18)
    scanline:Destroy()

    MainFrame.ClipsDescendants = false

    start3DParticles()

    TweenService:Create(Background, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        ImageTransparency = 0
    }):Play()
    TweenService:Create(Character, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        ImageTransparency = 0
    }):Play()
    TweenService:Create(CharacterIcon, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        ImageTransparency = 0,
        BackgroundTransparency = 1
    }):Play()

    task.wait(0.08)

    TweenService:Create(TitleLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    }):Play()
    TweenService:Create(UIStroke_Title, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 0
    }):Play()

    task.wait(0.06)

    TweenService:Create(SubTitleLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    }):Play()

    task.wait(0.08)

    TweenService:Create(KeyInput, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0,
        BackgroundTransparency = 0
    }):Play()
    TweenService:Create(UIStroke_Input, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 0
    }):Play()
    KeyInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)

    task.wait(0.08)

    TweenService:Create(GetKeyBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        ImageTransparency = 0,
        BackgroundTransparency = 0
    }):Play()
    TweenService:Create(GetKeyButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    }):Play()
    TweenService:Create(UIStroke_GetKey, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 0
    }):Play()
    TweenService:Create(UIStroke_GetKeyText, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 0
    }):Play()

    TweenService:Create(CheckKeyBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        ImageTransparency = 0,
        BackgroundTransparency = 0
    }):Play()
    TweenService:Create(CheckKeyButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    }):Play()
    TweenService:Create(UIStroke_CheckKey, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 0
    }):Play()
    TweenService:Create(UIStroke_CheckKeyText, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 0
    }):Play()

    task.wait(0.06)

    TweenService:Create(DiscordBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        ImageTransparency = 0,
        BackgroundTransparency = 0
    }):Play()
    TweenService:Create(DiscordButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    }):Play()
    TweenService:Create(UIStroke_Discord, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 0
    }):Play()
    TweenService:Create(UIStroke_DiscordText, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 0
    }):Play()

    TweenService:Create(TutorialBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        ImageTransparency = 0,
        BackgroundTransparency = 0
    }):Play()
    TweenService:Create(TutorialButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    }):Play()
    TweenService:Create(UIStroke_Tutorial, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 0
    }):Play()
    TweenService:Create(UIStroke_TutorialText, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 0
    }):Play()

    task.wait(0.15)

    TweenService:Create(UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
        Transparency = 0.25,
        Thickness = 3
    }):Play()

    update3DTilt()
end

task.spawn(createSLOpenEffect)

local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

smoothDrag = function(input)
    local delta = input.Position - dragStart
    local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale,
        startPos.Y.Offset + delta.Y)
    TweenService:Create(MainFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        { Position = targetPos }):Play()
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                dragInput = nil
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        smoothDrag(input)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        local viewportSize = UserInputService:GetScreenResolution()
        local mx = input.Position.X / viewportSize.X
        local my = input.Position.Y / viewportSize.Y
        targetTiltX = (mx - 0.5) * 0.4
        targetTiltY = (my - 0.5) * 0.4
    end
end)

GetKeyButton.MouseButton1Down:Connect(function()
    TweenService:Create(GetKeyBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Size = UDim2.new(0, 195, 0, 40) }):Play()
    TweenService:Create(UIStroke_GetKey, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Thickness = 4 }):Play()
end)

GetKeyButton.MouseButton1Up:Connect(function()
    TweenService:Create(GetKeyBtn, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Size = UDim2.new(0, 205, 0, 45) }):Play()
    TweenService:Create(UIStroke_GetKey, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Thickness = 2.5 }):Play()
end)

GetKeyButton.MouseEnter:Connect(function()
    TweenService:Create(UIStroke_GetKey, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Color = Color3.fromRGB(100, 180, 255) }):Play()
end)

GetKeyButton.MouseLeave:Connect(function()
    TweenService:Create(UIStroke_GetKey, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Color = Color3.fromRGB(70, 140, 200) }):Play()
end)

CheckKeyButton.MouseButton1Down:Connect(function()
    TweenService:Create(CheckKeyBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Size = UDim2.new(0, 195, 0, 40) }):Play()
    TweenService:Create(UIStroke_CheckKey, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Thickness = 4 }):Play()
end)

CheckKeyButton.MouseButton1Up:Connect(function()
    TweenService:Create(CheckKeyBtn, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Size = UDim2.new(0, 205, 0, 45) }):Play()
    TweenService:Create(UIStroke_CheckKey, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Thickness = 2.5 }):Play()
end)

CheckKeyButton.MouseEnter:Connect(function()
    TweenService:Create(UIStroke_CheckKey, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Color = Color3.fromRGB(100, 180, 255) }):Play()
end)

CheckKeyButton.MouseLeave:Connect(function()
    TweenService:Create(UIStroke_CheckKey, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Color = Color3.fromRGB(70, 140, 200) }):Play()
end)

DiscordButton.MouseButton1Down:Connect(function()
    TweenService:Create(DiscordBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Size = UDim2.new(0, 195, 0, 40) }):Play()
    TweenService:Create(UIStroke_Discord, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Thickness = 4 }):Play()
end)

DiscordButton.MouseButton1Up:Connect(function()
    TweenService:Create(DiscordBtn, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Size = UDim2.new(0, 205, 0, 45) }):Play()
    TweenService:Create(UIStroke_Discord, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Thickness = 2.5 }):Play()
end)

DiscordButton.MouseEnter:Connect(function()
    TweenService:Create(UIStroke_Discord, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Color = Color3.fromRGB(138, 151, 255) }):Play()
end)

DiscordButton.MouseLeave:Connect(function()
    TweenService:Create(UIStroke_Discord, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Color = Color3.fromRGB(108, 121, 255) }):Play()
end)

TutorialButton.MouseButton1Down:Connect(function()
    TweenService:Create(TutorialBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Size = UDim2.new(0, 195, 0, 40) }):Play()
    TweenService:Create(UIStroke_Tutorial, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Thickness = 4 }):Play()
end)

TutorialButton.MouseButton1Up:Connect(function()
    TweenService:Create(TutorialBtn, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Size = UDim2.new(0, 205, 0, 45) }):Play()
    TweenService:Create(UIStroke_Tutorial, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Thickness = 2.5 }):Play()
end)

TutorialButton.MouseEnter:Connect(function()
    TweenService:Create(UIStroke_Tutorial, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Color = Color3.fromRGB(255, 100, 255) }):Play()
end)

TutorialButton.MouseLeave:Connect(function()
    TweenService:Create(UIStroke_Tutorial, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Color = Color3.fromRGB(200, 70, 200) }):Play()
end)

GetKeyButton.MouseButton1Click:Connect(function()
    Notify("Vxeze Hub", "Generating key...", 3)
    local result = game:HttpGet(LINK4M_URL .. ___S("/create?admin_secret=vxeze_admin_2024&type=key&hwid=") .. HttpService:UrlEncode(getHWID()))
    local data = HttpService:JSONDecode(result)
    if data.success then
        KeyInput.Text = data.key
        setclipboard(data.key)
        local shortlink = LINK4M_URL .. ___S("/") .. data.short_id
        setclipboard(shortlink)
        Notify("Vxeze Hub", "Key: " .. data.key .. " | Shortlink copied", 5)
    else
        setclipboard(API_BASE_URL)
        Notify("Vxeze Hub", "Visit vxezehub.click to get a key", 4)
    end
end)

createSLCloseEffect = function()
    MainFrame.ClipsDescendants = true

    stop3DParticles()

    local whiteFlash = Instance.new("Frame")
    whiteFlash.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    whiteFlash.BackgroundTransparency = 1
    whiteFlash.Size = UDim2.new(1, 0, 1, 0)
    whiteFlash.ZIndex = 200
    whiteFlash.BorderSizePixel = 0
    whiteFlash.Parent = MainFrame

    local whiteCorner = Instance.new("UICorner")
    whiteCorner.CornerRadius = UDim.new(0, 16)
    whiteCorner.Parent = whiteFlash

    TweenService:Create(whiteFlash, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {
        BackgroundTransparency = 0.6
    }):Play()
    task.wait(0.05)
    TweenService:Create(whiteFlash, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1
    }):Play()

    Background.ImageTransparency = 1
    Character.ImageTransparency = 1
    CharacterIcon.ImageTransparency = 1
    CharacterIcon.BackgroundTransparency = 1
    TitleLabel.TextTransparency = 1
    SubTitleLabel.TextTransparency = 1
    KeyInput.TextTransparency = 1
    KeyInput.BackgroundTransparency = 1
    GetKeyBtn.ImageTransparency = 1
    GetKeyBtn.BackgroundTransparency = 1
    GetKeyButton.TextTransparency = 1
    CheckKeyBtn.ImageTransparency = 1
    CheckKeyBtn.BackgroundTransparency = 1
    CheckKeyButton.TextTransparency = 1
    DiscordBtn.ImageTransparency = 1
    DiscordBtn.BackgroundTransparency = 1
    DiscordButton.TextTransparency = 1
    TutorialBtn.ImageTransparency = 1
    TutorialBtn.BackgroundTransparency = 1
    TutorialButton.TextTransparency = 1
    UIStroke_Title.Transparency = 1
    UIStroke_Input.Transparency = 1
    UIStroke_GetKey.Transparency = 1
    UIStroke_GetKeyText.Transparency = 1
    UIStroke_CheckKey.Transparency = 1
    UIStroke_CheckKeyText.Transparency = 1
    UIStroke_Discord.Transparency = 1
    UIStroke_DiscordText.Transparency = 1
    UIStroke_Tutorial.Transparency = 1
    UIStroke_TutorialText.Transparency = 1

    task.wait(0.08)

    local closeScanline = Instance.new("Frame")
    closeScanline.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    closeScanline.BackgroundTransparency = 0.4
    closeScanline.Size = UDim2.new(1, 0, 0, 2)
    closeScanline.Position = UDim2.new(0, 0, 0, 0)
    closeScanline.ZIndex = 201
    closeScanline.BorderSizePixel = 0
    closeScanline.Parent = MainFrame

    TweenService:Create(closeScanline, TweenInfo.new(0.12, Enum.EasingStyle.Linear), {
        Position = UDim2.new(0, 0, 1, 0),
        BackgroundTransparency = 0.9
    }):Play()
    task.wait(0.12)
    closeScanline:Destroy()

    UICorner.CornerRadius = UDim.new(0, 4)

    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 500, 0, 4),
        BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    }):Play()
    TweenService:Create(UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Transparency = 0,
        Thickness = 3,
        Color = Color3.fromRGB(0, 255, 255)
    }):Play()

    task.wait(0.3)

    local barGlow2 = TweenService:Create(UIStroke, TweenInfo.new(0.07, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            Thickness = 6,
            Transparency = 0
        })
    barGlow2:Play()
    task.wait(0.07)

    UICorner.CornerRadius = UDim.new(1, 0)

    TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 4, 0, 4),
        BackgroundColor3 = Color3.fromRGB(0, 200, 255),
        BackgroundTransparency = 0
    }):Play()
    TweenService:Create(UIStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Transparency = 1
    }):Play()

    task.wait(0.18)

    TweenService:Create(MainFrame, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.1
    }):Play()
    task.wait(0.08)
    TweenService:Create(MainFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1
    }):Play()

    task.wait(0.2)
end

local KeyVerified = false

autoCheckSavedKey = function()
    local savedKey = loadKeyFromFile()
    if savedKey then
        KeyInput.Text = savedKey
        Notify("Vxeze Hub", "Loaded saved key, checking...", 2)

        local isValid, message, timeInfo = validateKeyWithServer(savedKey)

        if isValid then
            Notify("Vxeze Hub", "Saved key is valid!", 2)

            local greenFlash = Instance.new("Frame")
            greenFlash.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
            greenFlash.BackgroundTransparency = 1
            greenFlash.Size = UDim2.new(1, 0, 1, 0)
            greenFlash.ZIndex = 100
            greenFlash.BorderSizePixel = 0
            greenFlash.Parent = MainFrame

            local greenCorner = Instance.new("UICorner")
            greenCorner.CornerRadius = UDim.new(0, 16)
            greenCorner.Parent = greenFlash

            for i = 1, 2 do
                TweenService:Create(greenFlash, TweenInfo.new(0.08, Enum.EasingStyle.Linear),
                    { BackgroundTransparency = 0.6 }):Play()
                task.wait(0.08)
                TweenService:Create(greenFlash, TweenInfo.new(0.08, Enum.EasingStyle.Linear),
                    { BackgroundTransparency = 1 }):Play()
                task.wait(0.08)
            end

            greenFlash:Destroy()
            task.wait(0.2)

            createSLCloseEffect()
            KeyGui:Destroy()
            KeyVerified = true
            return true
        else
            Notify("Vxeze Hub", "Saved key is invalid, deleting...", 3)
            deleteKeyFile()
            KeyInput.Text = ""
            return false
        end
    end
    return false
end

task.spawn(function()
    task.wait(1)
    autoCheckSavedKey()
end)

CheckKeyButton.MouseButton1Click:Connect(function()
    local enteredKey = KeyInput.Text

    if enteredKey == "" then
        Notify("Vxeze Hub", "Please enter a key!", 3)
        return
    end

    local isValid, message, timeInfo = validateKeyWithServer(enteredKey)

    if isValid then
        Notify("Vxeze Hub", "Key verified successfully!", 2)

        deleteKeyFile()
        saveKeyToFile(enteredKey)

        local greenFlash = Instance.new("Frame")
        greenFlash.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        greenFlash.BackgroundTransparency = 1
        greenFlash.Size = UDim2.new(1, 0, 1, 0)
        greenFlash.ZIndex = 100
        greenFlash.BorderSizePixel = 0
        greenFlash.Parent = MainFrame

        local greenCorner = Instance.new("UICorner")
        greenCorner.CornerRadius = UDim.new(0, 16)
        greenCorner.Parent = greenFlash

        for i = 1, 2 do
            TweenService:Create(greenFlash, TweenInfo.new(0.08, Enum.EasingStyle.Linear),
                { BackgroundTransparency = 0.6 }):Play()
            task.wait(0.08)
            TweenService:Create(greenFlash, TweenInfo.new(0.08, Enum.EasingStyle.Linear),
                { BackgroundTransparency = 1 }):Play()
            task.wait(0.08)
        end

        greenFlash:Destroy()
        task.wait(0.2)

        createSLCloseEffect()
        KeyGui:Destroy()
        KeyVerified = true
    else
        deleteKeyFile()

        TweenService:Create(UIStroke_Input, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Color = Color3.fromRGB(255, 50, 50)
        }):Play()
        TweenService:Create(KeyInput, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(80, 20, 20)
        }):Play()

        local originalPos = MainFrame.Position
        for i = 1, 6 do
            local offset = (i % 2 == 0) and 10 or -10
            TweenService:Create(MainFrame, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset + offset, originalPos.Y.Scale,
                    originalPos.Y.Offset)
            }):Play()
            task.wait(0.05)
        end

        TweenService:Create(MainFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = originalPos
        }):Play()

        task.wait(0.2)

        Notify("Vxeze Hub", "Invalid Key: " .. tostring(message), 3)

        task.wait(0.3)

        TweenService:Create(UIStroke_Input, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Color = Color3.fromRGB(0, 255, 255)
        }):Play()
        TweenService:Create(KeyInput, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        }):Play()
    end
end)

DiscordButton.MouseButton1Click:Connect(function()
    Notify("Vxeze Hub", "Discord link copied to clipboard!", 3)
    setclipboard("https://discord.gg/KUKaympf")
end)

TutorialButton.MouseButton1Click:Connect(function()
    Notify("Vxeze Hub", "Tutorial link copied to clipboard!", 3)
    setclipboard("https://youtu.be/b5kzFdezIl4")
end)

repeat task.wait() until KeyVerified == true
