
   --// UMAR HUB | Rivals
--// Clean public build (no HWID)

if not getgenv().UmarHub_Loader then
    return
end

repeat task.wait() until
    game:IsLoaded()
    and game.Players.LocalPlayer
    and game.Players.LocalPlayer.Character
    and game.Players.LocalPlayer:FindFirstChild("PlayerScripts")
    and workspace:FindFirstChild("ViewModels")

--// UMAR HUB | Rivals
--// Rebranded from 8bit
--// Test build (no loader yet)

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Fluent = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/perfectBlue0X/the-rivals/main/8bitfluent.lua"

))()


local SaveManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"
))()

local InterfaceManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"
))()


-- vnew
local Workspace = game:GetService("Workspace")
local Window = Fluent:CreateWindow({
    Title = "UMAR HUB [Rivals] " .. Fluent.Version,
    SubTitle = "test build",
    TabWidth = 160,
    Size = UDim2.fromOffset(600, 470),
    Acrylic = false,
    Theme = "Default",


    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Wlc = Window:AddTab({ Title = "Boarding", Icon = "rbxassetid://10723407389" }),
    Main = Window:AddTab({ Title = "Visuals", Icon = "hexagon" }),
    AimTab = Window:AddTab({ Title = "Aim Features", Icon = "mouse" }),
    Silent = Window:AddTab({ Title = "Silent [Beta]", Icon = "rbxassetid://76660100218760" }),
    Skinz = Window:AddTab({ Title = "Skin Changer", Icon = "swords" }),
    Essential = Window:AddTab({ Title = "Essential", Icon = "rbxassetid://10709819149" }),
    ModTab = Window:AddTab({ Title = "Mods", Icon = "rbxassetid://10723405360" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "list-music" }),
    Settings = Window:AddTab({ Title = "Config", Icon = "settings-2" })
}

local Options = Fluent.Options

do





--------Animator------------------------------------------------------------------------------------------------
local TweenService = game:GetService("TweenService")
local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

local xPosOffset = -210
local startY = 0
local textLabelsData = {
    textLabel1 = "Player Esp [Drawing]",
    textLabel2 = "Aimbot [Cam]",
    textLabel3 = "Aimbot [Input]",
    b_effect = "Bullet Effects",
    textLabel5 = "Hit Marker",
    atmosphere = "Atmosphere",
    ghosttxt = "Ghost Hands",
    silentaim = "Silent Aim"
}

local textLabels = {}
local yInterval = 30

local function createTextLabel(name, text, yOffset)
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(0, 200, 0, 25)
    textLabel.Position = UDim2.new(1, xPosOffset, 0, yOffset)
    textLabel.Text = text
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.BackgroundTransparency = 1
    textLabel.FontFace = Font.new('rbxassetid://16658237174')
    textLabel.TextSize = 18
    textLabel.TextXAlignment = Enum.TextXAlignment.Right
    textLabel.Parent = screenGui
    textLabel.TextStrokeTransparency = 1
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabels[name] = textLabel
    return textLabel
end

local currentY = startY
for name, text in pairs(textLabelsData) do
    createTextLabel(name, text, currentY)
    currentY = currentY + yInterval
end

local function alignTextLabels()
    local currentY = startY
    local tweens = {}
    for _, label in pairs(textLabels) do
        if label.Visible then
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local goal = {Position = UDim2.new(1, xPosOffset, 0, currentY)}
            local tween = TweenService:Create(label, tweenInfo, goal)
            table.insert(tweens, tween)
            currentY = currentY + yInterval
        end
    end
    for _, tween in ipairs(tweens) do
        tween:Play()
    end
end

local Slider = Tabs.Misc:AddSlider("GapSlider", {
    Title = "Gap Select",
    Description = "Adjust the gap size",
    Default = yInterval,
    Min = 5,
    Max = 100,
    Rounding = 1,
})

Slider:OnChanged(function(Value)
    yInterval = Value
    alignTextLabels()
end)

local function fadeText(label, fadeIn)
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local goal = fadeIn and {TextTransparency = 0} or {TextTransparency = 1}
    local tween = TweenService:Create(label, tweenInfo, goal)
    tween:Play()
end

local currentAnimationType = "None"
local isAnimating = false

local function animateTextLoop()
    while currentAnimationType == "Fade" do
        for _, label in pairs(textLabels) do
            local fadeOutTween = TweenService:Create(label, TweenInfo.new(0.2), {TextTransparency = 0.5})
            local fadeInTween = TweenService:Create(label, TweenInfo.new(0.2), {TextTransparency = 0})
            fadeOutTween:Play()
            fadeOutTween.Completed:Wait()
            fadeInTween:Play()
            fadeInTween.Completed:Wait()
        end
        wait(0.2)
    end
end

local function colorFlashAnimation()
    while currentAnimationType == "Color Flash" do
        for _, label in pairs(textLabels) do
            local flashTween = TweenService:Create(label, TweenInfo.new(0.1), {TextColor3 = Color3.fromRGB(173, 216, 230)})
            local revertTween = TweenService:Create(label, TweenInfo.new(0.1), {TextColor3 = Color3.fromRGB(255, 255, 255)})
            flashTween:Play()
            flashTween.Completed:Wait()
            revertTween:Play()
            revertTween.Completed:Wait()
        end
        wait(0.2)
    end
end

local animationDropdown = Tabs.Misc:AddDropdown("AnimationTypeDropdown", {
    Title = "Text Animation",
    Values = {"None", "Fade", "Color Flash"},
    Multi = false,
    Default = 1,
})

animationDropdown:OnChanged(function(selectedAnimation)
    if selectedAnimation == "Fade" and not isAnimating then
        currentAnimationType = selectedAnimation
        isAnimating = true
        spawn(animateTextLoop)
    elseif selectedAnimation == "Color Flash" and not isAnimating then
        currentAnimationType = selectedAnimation
        isAnimating = true
        spawn(colorFlashAnimation)
    elseif selectedAnimation == "None" then
        currentAnimationType = "None"
        isAnimating = false
    end
end)

local Dropdown = Tabs.Misc:AddDropdown("StatTextAlignDropdown", {
    Title = "Text Alignment",
    Values = {"Left", "Center", "Right"},
    Multi = false,
    Default = 3,
})

Dropdown:OnChanged(function(Value)
    local alignment = Enum.TextXAlignment.Right
    if Value == "Left" then
        alignment = Enum.TextXAlignment.Left
    elseif Value == "Center" then
        alignment = Enum.TextXAlignment.Center
    end
    for _, label in pairs(textLabels) do
        label.TextXAlignment = alignment
    end
    alignTextLabels()
end)

local Input = Tabs.Misc:AddInput("StatTextPosInput", {
    Title = "Input",
    Default = tostring(-210),
    Placeholder = "Enter x position",
    Numeric = true,
})

Input:OnChanged(function()
    local inputVal = tonumber(Input.Value)
    if inputVal then
        xPosOffset = inputVal
        alignTextLabels()
    end
end)

local ToggleOutline = Tabs.Misc:AddToggle("StatTextToggleOutline", {Title = "Toggle the Text Outline", Default = false})

ToggleOutline:OnChanged(function()
    local outlineEnabled = Options.StatTextToggleOutline.Value
    for _, label in pairs(textLabels) do
        label.TextStrokeTransparency = outlineEnabled and 0 or 1
    end
end)

local Slider = Tabs.Misc:AddSlider("StatTextSlider", {
    Title = "Text Size",
    Description = "Adjust the text size",
    Default = 18,
    Min = 5,
    Max = 100,
    Rounding = 1,
})

Slider:OnChanged(function(Value)
    for _, label in pairs(textLabels) do
        label.TextSize = Value
    end
end)

local Colorpicker = Tabs.Misc:AddColorpicker("StatTxtColorpicker", {
    Title = "Text Color",
    Default = Color3.fromRGB(255, 255, 255)
})

Colorpicker:OnChanged(function()
    local selectedColor = Options.StatTxtColorpicker and Options.StatTxtColorpicker.Value or Colorpicker.Value
    for _, label in pairs(textLabels) do
        label.TextColor3 = selectedColor
    end
end)

alignTextLabels()

----------------------------------------------------------------------------------------------------------------
--welcome--
local Player = game:GetService("Players").LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera
local Mouse = Player:GetMouse()

    Fluent:Notify({
        Title = "Loading Module...",
        Content = "Module Loaded [7/18]",
        Duration = 3
    })



    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    
    -- Function to get current device info
    local function getDeviceType()
        return UserInputService.TouchEnabled and "Mobile" or "PC"
    end
    
    -- Function to create initial content for the paragraph
    local function getExecutionDetails()
        local player = Players.LocalPlayer
        local displayName = player.DisplayName
        local username = player.Name
        local executor = identifyexecutor()  -- Get the executor name
        local deviceType = getDeviceType()
        local deviceTime = os.date("%Y-%m-%d %I:%M:%S %p")  -- 12-hour format with AM/PM
    
        return "Executed by: " .. displayName .. " (" .. username .. ")\n" ..
            "Device: " .. deviceType .. "\n" ..
            "Executor: " .. executor .. "\n" ..
            "Device Time: " .. deviceTime
    end
    
    -- Set up the paragraph with one-time content
    Tabs.Wlc:AddParagraph({
        Title = "Execution Details",
        Content = getExecutionDetails()  -- Set content once
    })

    Tabs.Wlc:AddParagraph({
        Title = "Are you winning son ?",
        Content = ""
    })


---Visuals-------------------------------------------------------------------------------------------------------
local esp_settings = { ---- table for esp settings 
textsize = 12,
colour = Color3.fromRGB(255, 255, 255),
strokeColour = Color3.fromRGB(0, 0, 0),
maxDistance = 300
}

local guiTemplate = Instance.new("BillboardGui")
local espTemplate = Instance.new("TextLabel", guiTemplate)

guiTemplate.Name = "Umar Hub"
guiTemplate.ResetOnSpawn = false
guiTemplate.AlwaysOnTop = true
guiTemplate.Enabled = false
guiTemplate.LightInfluence = 0
guiTemplate.Size = UDim2.new(2, 0, 2, 0)
guiTemplate.StudsOffset = Vector3.new(0, 2, 0)

espTemplate.BackgroundTransparency = 1
espTemplate.Text = ""
espTemplate.Size = UDim2.new(1, 0, 1, 0)
espTemplate.BorderSizePixel = 0
espTemplate.Font = Enum.Font.Gotham
espTemplate.TextSize = esp_settings.textsize
espTemplate.TextColor3 = esp_settings.colour
espTemplate.TextStrokeTransparency = 0
espTemplate.TextStrokeColor3 = esp_settings.strokeColour

local weaponNames = {
"Hacker Rifle", "Pixel Flamethrower", "Blaster", "Chancla", "Gingerbread Handgun", "Knife", "Goalpost", "Stick", "Spray", 
"Uzi", "Slime Gun", "Trick or Treat", "Firework Gun", "Flare Gun", "Apex Rifle", "Battle Axe", 
"Burst Rifle", "Scepter", "Whoopee Cushion", "Desert Eagle", "Revolver", "Jingle Grenade", "Smoke Grenade", "Emoji Cloud", 
"Trowel", "Plastic Shovel", "Molotov", "Coffee", "Exogun", "Wondergun", "Nordic Axe",
"Briefcase", "Disco Ball", "Flashbang", "Festive Fists", "Shotgun", "AK-47", "Assault Rifle", 
"Sniper", "Grenade Launcher", "Shorty", "Minigun", "Paintball Gun", "Bubble Ray", "Swashbuckler", "Lasergun 3000", 
"Flamethrower", "Bucket of Candy", "Nuke Launcher", "Don't Press", "Elixir", "Katana", 
"Crossbow", "Reindeer Slingshot", "Fists", "Advanced Satchel", "RPKEY", "Singularity", "Energy Rifle", 
"Apex Pistols", "Dynamite Gun", "Boneshot", "Camera", "Pixel Minigun", "Water Balloon", "Anchor", "Energy Pistols", 
"Aces", "Ray Gun", "Pixel Crossbow", "Lamethrower", "Spring", "Temporal Ray", "Uranium Launcher", "Skullbang",
"Balance", "Peppermint Sheriff", "Cookies", "AUG", "Aqua Burst", "Lightning Bolt", 
"Torch", "Spaceship Launcher", "Hacker Pistols", "Freeze Ray", "Keyper", "Pixel Flashbang", 
"AKEY-47", "Pixel Katana", "Pixel Handgun", "Hand Gun", "Hyper Gunblade", "Machete", "Devil's Trident", "Boneclaw Rifle", 
"Pumpkin Launcher", "Spectral Burst", "Spider Ray", "RPG", "Hexxed Candle", "Lovely Spray", 
"Slingshot", "Brain Gun", "Skull Launcher", "Pumpkin Handgun", "Boba Gun", "Electro Rifle", "Elf's Gunblade", 
"Eyeball", "Boneclaw Revolver", "Bat Scythe", "Pumpkin Carver", "Broomstick", "Soul Grenade", "Jack O'Thrower", 
"War Horn", "Trumpet", "The Shred", "Subspace Tripmine", "Sheriff", "Scythe of Death", "Scythe", "Satchel", "Sandwich", 
"Saber", "Riot Shield", "Medkit", "Laptop", "Keythe", "Karambit", "Garden Shovel", "Exogourd", "Door", 
"Compound Bow", "Chainsaw", "Buzzsaw", "Blobsaw", "Pumpkin Claws", "Boxing Gloves", "Handsaws", "Brass Knuckles", 
"Wrapped Minigun", "Crystal Daggers", "Frostbite Crossbow", "Gingerbread AUG", "Cryo Scythe", 
"Shining Star", "Snowglobe", "Snowball Gun", "Snow Shovel", "Gunblade", "2025 Katana", 
"Wrapped Freeze Ray", "2025 Energy Pistols", "Snowblower", "Sled", "2025 Energy Rifle", "Handgun", 
"Festive Buzzsaw", "Milk & Cookies", "Grenade", "Dev-in-the-Box", "Mammoth Horn", "Pine Spray", "Firework Launcher",
"Raven Bow", "Bat Bow", "Bow", "Suspicious Gift", "Wrapped Flare Gun", 
"Candy Cane", "Frostbite Bow", "Daggers", "Snowball Launcher", "Pixel Burst", "Pine Burst", "Hot Coals"
}

local espComponents = { Name = true, Weapon = true, Distance = true } -- Defaults

local TEspMultiDropdown = Tabs.Main:AddDropdown("TEspMultiDropdown", { 
Title = "Dropdown",
Description = "You can select multiple values.",
Values = {"Name", "Weapon", "Distance"},
Multi = true,
Default = {"Name", "Weapon"},
})

TEspMultiDropdown:OnChanged(function(Value)
espComponents = { Name = false, Weapon = false, Distance = false } -- Reset
for component, state in pairs(Value) do
    if state then
        espComponents[component] = true
    end
end
end)

local Slider = Tabs.Main:AddSlider("EspTxtSizeSlider", { 
Title = "Font Size",
Description = "Adjust the font size of ESP text.",
Default = 12, 
Min = 0,
Max = 50, 
Rounding = 1,
Callback = function(Value)
    esp_settings.textsize = Value
end
})

Slider:OnChanged(function(Value)
esp_settings.textsize = Value
end)

local Colorpicker = Tabs.Main:AddColorpicker("EspTxtColorpicker", { 
Title = "Text Color",
Default = esp_settings.colour
})

Colorpicker:OnChanged(function()
esp_settings.colour = Colorpicker.Value
end)

local function extractWeaponName(modelName)
for _, weapon in ipairs(weaponNames) do
    if string.find(modelName, weapon) then
        return weapon
    end
end
return "Hand"
end

local function getDistance(player)
local localPlayer = game:GetService("Players").LocalPlayer
if player.Character and player.Character:FindFirstChild("Head") then
    local distance = (localPlayer.Character.Head.Position - player.Character.Head.Position).magnitude
    return math.floor(distance)
end
return math.huge
end

local function updateESP(v)
if v == game:GetService("Players").LocalPlayer then return end

local distance = getDistance(v)
if distance > esp_settings.maxDistance then
    if v.Character and v.Character:FindFirstChild("Head") then
        local existingGui = v.Character.Head:FindFirstChild("8bit")
        if existingGui then
            existingGui:Destroy()
        end
    end
    return
end

local modelNamePattern = v.Name
local espText = "Hand"

for _, model in pairs(game:GetService("Workspace").ViewModels:GetChildren()) do
    if string.find(model.Name, modelNamePattern) then
        espText = extractWeaponName(model.Name)
        break
    end
end

local components = {}
if espComponents.Name then table.insert(components, v.Name) end
if espComponents.Weapon then table.insert(components, espText) end
if espComponents.Distance then table.insert(components, distance .. " studs") end

local displayText = table.concat(components, " ● ")

if v.Character and v.Character:FindFirstChild("Head") then
    local playerGui = v.Character.Head:FindFirstChild("8bit")
    if playerGui then
        playerGui.TextLabel.Text = displayText
        playerGui.TextLabel.TextSize = esp_settings.textsize -- Update font size
        playerGui.TextLabel.TextColor3 = esp_settings.colour -- Update text color
    else
        local playerGuiClone = guiTemplate:Clone()
        playerGuiClone.TextLabel.Text = displayText
        playerGuiClone.TextLabel.TextSize = esp_settings.textsize -- Set font size
        playerGuiClone.TextLabel.TextColor3 = esp_settings.colour -- Set text color
        playerGuiClone.Parent = v.Character.Head
    end
end
end

game:GetService("RunService").RenderStepped:Connect(function()
for _, v in pairs(game:GetService("Players"):GetPlayers()) do
    if v.Character and v.Character:FindFirstChild("Head") then
        updateESP(v)
    end
end
end)

game:GetService("Players").PlayerAdded:Connect(function(player)
player.CharacterAdded:Connect(function(character)
    updateESP(player)
end)
end)

game:GetService("Players").PlayerRemoving:Connect(function(player)
if player.Character and player.Character:FindFirstChild("Head") then
    local espGui = player.Character.Head:FindFirstChild("8bit")
    if espGui then
        espGui:Destroy()
    end
end
end)






local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Define Settings object with default values
local Settings = {
    ESP_Enabled = true,
    ESP_TeamCheck = false,
    Chams = false,  -- Initially set to false
    Chams_Color = Color3.fromRGB(3, 44, 252),  -- Fixed color for Chams
    Chams_Transparency = 0.6,
}

-- Add Toggle for Chams
local Toggle = Tabs.Main:AddToggle("MyToggle", {Title = "ChamsToggle", Default = false })
Toggle:OnChanged(function()
    Settings.Chams = Toggle.Value
    print("Chams Toggle changed:", Settings.Chams)
end)

-- Function to manage Chams
local function UpdateChams(player)
    local character = player.Character
    if not character then return end

    for _, part in ipairs(character:GetChildren()) do
        if part:IsA("BasePart") and part.Transparency ~= 1 then
            local existingChams = part:FindFirstChild("Chams")

            if Settings.Chams then
                -- Create Chams if it doesn't exist
                if not existingChams then
                    local chamsBox = Instance.new("BoxHandleAdornment")
                    chamsBox.Name = "Chams"
                    chamsBox.AlwaysOnTop = true
                    chamsBox.ZIndex = 4
                    chamsBox.Adornee = part
                    chamsBox.Color3 = Settings.Chams_Color
                    chamsBox.Transparency = Settings.Chams_Transparency
                    chamsBox.Size = part.Size + Vector3.new(0.02, 0.02, 0.02)
                    chamsBox.Parent = part
                end
            else
                -- Remove Chams if they exist
                if existingChams then
                    existingChams:Destroy()
                end
            end
        end
    end
end

-- Optimize Heartbeat processing
RunService.Heartbeat:Connect(function()
    if not Settings.ESP_Enabled then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            continue
        end

        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid and humanoid.Health > 0 then
            if not (Settings.ESP_TeamCheck and player.Team == LocalPlayer.Team) then
                UpdateChams(player)
            else
                DestroyChams(player.Character)
            end
        else
            DestroyChams(player.Character)
        end
    end
end)

-- Destroy all Chams in a character
local function DestroyChams(character)
    for _, part in ipairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            local existingChams = part:FindFirstChild("Chams")
            if existingChams then
                existingChams:Destroy()
            end
        end
    end
end











-- settings
local settings = {
defaultcolor = Color3.fromRGB(255, 0, 0),
teamcheck = false,
teamcolor = true,
maxDistance = 300  -- Maximum distance for rendering ESP
};

-- services
local runService = game:GetService("RunService");
local players = game:GetService("Players");

-- variables
local localPlayer = players.LocalPlayer;
local camera = Workspace.CurrentCamera;

-- functions
local newVector2, newColor3, newDrawing = Vector2.new, Color3.new, Drawing.new;
local tan, rad = math.tan, math.rad;
local round = function(...) local a = {}; for i, v in next, table.pack(...) do a[i] = math.round(v); end return unpack(a); end;
local wtvp = function(...) local a, b = camera.WorldToViewportPoint(camera, ...) return newVector2(a.X, a.Y), b, a.Z end;

local espCache = {};
local boxVisible = true -- Toggle for box visibility
local healthBarVisible = true -- Toggle for health bar visibility

-- Toggles for box and health bar visibility
local BoxToggle = Tabs.Main:AddToggle("BoxToggle", {Title = "Toggle Box", Default = false})
local HealthBarToggle = Tabs.Main:AddToggle("HealthBarToggle", {Title = "Toggle Health Bar", Default = false})

BoxToggle:OnChanged(function()
 boxVisible = BoxToggle.Value -- Update box visibility
end)

HealthBarToggle:OnChanged(function()
 healthBarVisible = HealthBarToggle.Value -- Update health bar visibility
end)

-- Function to create ESP for a player
local function createEsp(player)
local drawings = {};

-- Box
drawings.box = newDrawing("Square");
drawings.box.Thickness = 1;
drawings.box.Filled = false;
drawings.box.Color = settings.defaultcolor;
drawings.box.Visible = false;
drawings.box.ZIndex = 2;

-- Health Bar (Thinner version)
drawings.healthBar = newDrawing("Square");
drawings.healthBar.Filled = true;
drawings.healthBar.Color = Color3.fromRGB(0, 255, 0); -- Default: Green
drawings.healthBar.Visible = false;
drawings.healthBar.ZIndex = 3;
drawings.healthBar.Size = newVector2(2, 0) -- Health bar is now thinner
drawings.healthBarBackground = newDrawing("Square");
drawings.healthBarBackground.Filled = true;
drawings.healthBarBackground.Color = Color3.fromRGB(50, 50, 50); -- Background: Dark gray
drawings.healthBarBackground.Visible = false;
drawings.healthBarBackground.ZIndex = 2;
drawings.healthBarBackground.Size = newVector2(2, 0) -- Background also thinner

espCache[player] = drawings;
end

-- Function to remove ESP for a player
local function removeEsp(player)
if rawget(espCache, player) then
    for _, drawing in next, espCache[player] do
        drawing:Remove();
    end
    espCache[player] = nil;
end
end

-- Function to update ESP for a player
local function updateEsp(player, esp)
local character = player and player.Character;
local humanoid = character and character:FindFirstChildOfClass("Humanoid");
if character and humanoid then
    local cframe = character:GetModelCFrame();
    local position, visible, depth = wtvp(cframe.Position);
    
    -- Check if the player is within the max distance (300 studs)
    local distance = (localPlayer.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude;
    if distance > settings.maxDistance then
        esp.box.Visible = false;
        esp.healthBar.Visible = false;
        esp.healthBarBackground.Visible = false;
        return;
    end
    
    -- Update visibility based on toggles
    esp.box.Visible = visible and boxVisible;
    esp.healthBar.Visible = visible and healthBarVisible;
    esp.healthBarBackground.Visible = visible and healthBarVisible;

    if cframe and visible then
        local scaleFactor = 1 / (depth * tan(rad(camera.FieldOfView / 2)) * 2) * 1000;
        local width, height = round(4 * scaleFactor, 5 * scaleFactor);
        local x, y = round(position.X, position.Y);

        esp.box.Size = newVector2(width, height);
        esp.box.Position = newVector2(round(x - width / 2, y - height / 2));
        esp.box.Color = settings.teamcolor and player.TeamColor.Color or settings.defaultcolor;

        -- Update health bar
        local healthPercent = humanoid.Health / humanoid.MaxHealth;
        esp.healthBarBackground.Size = newVector2(2, height); -- Adjusted width for thinner health bar
        esp.healthBarBackground.Position = newVector2(x - width / 2 - 6, y - height / 2);

        esp.healthBar.Size = newVector2(2, height * healthPercent); -- Thinner health bar
        esp.healthBar.Position = newVector2(x - width / 2 - 6, y - height / 2 + height * (1 - healthPercent));
        esp.healthBar.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0); -- Gradient: Green to Red
    end
else
    esp.box.Visible = false;
    esp.healthBar.Visible = false;
    esp.healthBarBackground.Visible = false;
end
end

-- main
for _, player in next, players:GetPlayers() do
if player ~= localPlayer then
    createEsp(player);
end
end

players.PlayerAdded:Connect(function(player)
createEsp(player);
end);

players.PlayerRemoving:Connect(function(player)
removeEsp(player);
end)

runService:BindToRenderStep("esp", Enum.RenderPriority.Camera.Value, function()
for player, drawings in next, espCache do
    if settings.teamcheck and player.Team == localPlayer.Team then
        continue;
    end

    if drawings and player ~= localPlayer then
        updateEsp(player, drawings);
    end
end
end)

----------------------------------------------------------------------------------------------------------

-----AimTab-----------------------------------------------------------------------------------------------------------------------

local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Local Player
local LocalPlayer = Players.LocalPlayer

-- AimbotCam Config
AimbotCam = {
    Enabled = false,  -- Initially set to false (disabled)
    HitChance = 100,
    NotWorkIfFlashed = true
}

-- Get the closest player to the mouse (no FOV restriction)
function GetClosestPlayerToMouse()
    local mouseLocation = UserInputService:GetMouseLocation()
    local closestPlayer = nil
    local closestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local screenPosition, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(screenPosition.X, screenPosition.Y) - mouseLocation).Magnitude
                if distance < closestDistance then
                    closestPlayer = player
                    closestDistance = distance
                end
            end
        end
    end

    return closestPlayer
end

-- Get Aimbot Target Part
function GetAimbotPart(player)
    return player.Character and player.Character:FindFirstChild("Head") -- Adjust if targeting other parts
end

-- LookAt function
function LookAt(target)
    Workspace.CurrentCamera.CFrame = CFrame.lookAt(
        Workspace.CurrentCamera.CFrame.Position,
        target.Position
    )
end

-- Hold tracking flag
local isTracking = false
local targetPlayer = nil

-- Track closest player while holding MouseButton2
function TrackTarget()
    local closestPlayer = GetClosestPlayerToMouse()
    if closestPlayer then
        targetPlayer = closestPlayer
    end

    while isTracking and AimbotCam.Enabled and targetPlayer do
        local percentage = math.random(0, 100)
        if percentage <= AimbotCam.HitChance then
            if AimbotCam.NotWorkIfFlashed and Lighting:FindFirstChild("Flashbang") then
                return
            end
            local target = GetAimbotPart(targetPlayer)
            if target then
                LookAt(target)
            end
        end
        RunService.RenderStepped:Wait()
    end
end

-- Mouse Input Handling
UserInputService.InputBegan:Connect(function(io, gameProcessedEvent)
    if not gameProcessedEvent and io.UserInputType == Enum.UserInputType.MouseButton2 then
        isTracking = true
        task.spawn(TrackTarget)
    end
end)

UserInputService.InputEnded:Connect(function(io, gameProcessedEvent)
    if io.UserInputType == Enum.UserInputType.MouseButton2 then
        isTracking = false
        targetPlayer = nil -- Reset target when mouse is released
    end
end)

-- Toggle logic to enable/disable the Aimbot
local Toggle = Tabs.AimTab:AddToggle("CamToggle", {Title = "Cam Aimbot", Default = false}) 

Toggle:OnChanged(function()
    if textLabels and textLabels.textLabel2 then 
        textLabels.textLabel2.Visible = Options.CamToggle.Value
        fadeText(textLabels.textLabel2, Options.CamToggle.Value)
        alignTextLabels()
    end
    AimbotCam.Enabled = Toggle.Value
end)
---Mouse-----------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------------------
----------Silent----------------------------------------------------------------------------------------------------------------

local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Local Player
local LocalPlayer = Players.LocalPlayer

-- Silent Aim Config
SilentAim = {
    Enabled = false, -- Controlled by toggle
    HitChance = 100,
    NotWorkIfFlashed = true,
    MaxDistance = 250, -- Maximum target distance
    TargetPart = "Head" -- Default target part (can be changed via dropdown)
}

SilentAimFov = {
    Visible = true, -- Controlled by toggle
    Radius = 150,   -- Default FOV radius
    Color = Color3.fromRGB(96, 205, 255), -- Default FOV color
    Circle = nil -- Will hold the Drawing object
}

-- Draw FOV Circle
function DrawFov()
    if SilentAimFov.Circle then
        SilentAimFov.Circle:Remove()
    end

    local circle = Drawing.new("Circle")
    circle.Color = SilentAimFov.Color -- Initial color
    circle.Thickness = 0.2
    circle.NumSides = 100
    circle.Radius = SilentAimFov.Radius
    circle.Filled = false
    circle.Transparency = 1
    circle.Visible = SilentAimFov.Visible
    SilentAimFov.Circle = circle
end

-- Update FOV Circle Position
function UpdateFov()
    if SilentAimFov.Circle then
        SilentAimFov.Circle.Visible = SilentAimFov.Visible
        SilentAimFov.Circle.Position = UserInputService:GetMouseLocation()
    end
end

-- Get the closest player or target part within the FOV circle and max distance
function GetClosestTargetToMouse()
    local mouseLocation = UserInputService:GetMouseLocation()
    local closestTarget = nil
    local closestDistance = math.huge

    -- Check Players
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local targetPart = player.Character:FindFirstChild(SilentAim.TargetPart)
            if targetPart then
                local distanceFromPlayer = (targetPart.Position - Workspace.CurrentCamera.CFrame.Position).Magnitude

                if distanceFromPlayer <= SilentAim.MaxDistance then
                    local screenPosition, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local distanceToMouse = (Vector2.new(screenPosition.X, screenPosition.Y) - mouseLocation).Magnitude
                        if distanceToMouse < SilentAimFov.Radius and distanceToMouse < closestDistance then
                            closestTarget = targetPart
                            closestDistance = distanceToMouse
                        end
                    end
                end
            end
        end
    end

    -- Check other targets like 'Target' model
    for _, target in pairs(Workspace:GetChildren()) do
        if target:IsA("Model") and target:FindFirstChild("HumanoidRootPart") and target.Name == "Target" then
            local targetPart = target:FindFirstChild(SilentAim.TargetPart) or target:FindFirstChild("HumanoidRootPart")
            if targetPart then
                local distanceFromPlayer = (targetPart.Position - Workspace.CurrentCamera.CFrame.Position).Magnitude

                if distanceFromPlayer <= SilentAim.MaxDistance then
                    local screenPosition, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local distanceToMouse = (Vector2.new(screenPosition.X, screenPosition.Y) - mouseLocation).Magnitude
                        if distanceToMouse < SilentAimFov.Radius and distanceToMouse < closestDistance then
                            closestTarget = targetPart
                            closestDistance = distanceToMouse
                        end
                    end
                end
            end
        end
    end

    return closestTarget
end

-- LookAt function
function LookAt(target)
    Workspace.CurrentCamera.CFrame = CFrame.lookAt(
        Workspace.CurrentCamera.CFrame.Position,
        target.Position
    )
end

-- Silent Aim Input Handling
function SilentAimUIS(io, gameProcessedEvent)
    if not gameProcessedEvent and SilentAim.Enabled then
        if io.UserInputType == Enum.UserInputType.MouseButton1 then
            local percentage = math.random(0, 100)
            if percentage <= SilentAim.HitChance then
                local closestTarget = GetClosestTargetToMouse()
                if closestTarget ~= nil then
                    if SilentAim.NotWorkIfFlashed and Lighting:FindFirstChild("Flashbang") then
                        return
                    end
                    LookAt(closestTarget)
                end
            end
        end
    end
end

-- Render loop for FOV circle
RunService.RenderStepped:Connect(function()
    UpdateFov()
end)

-- Connect InputBegan
UserInputService.InputBegan:Connect(SilentAimUIS)

-- Initialize FOV Circle
DrawFov()

-- Toggles Integration
local SilentAimToggle = Tabs.Silent:AddToggle("SAimtgl", {Title = "Silent Aim", Default = false})
local FovToggle = Tabs.Silent:AddToggle("Fovtgl", {Title = "Show FOV", Default = false})

SilentAimToggle:OnChanged(function()
        if textLabels and textLabels.silentaim then
        textLabels.silentaim.Visible = Options.SAimtgl.Value
        fadeText(textLabels.silentaim, Options.SAimtgl.Value)
        alignTextLabels()
    end
    SilentAim.Enabled = SilentAimToggle.Value
end)

FovToggle:OnChanged(function()
    SilentAimFov.Visible = FovToggle.Value
end)

-- Slider for FOV Radius
local Slider = Tabs.Silent:AddSlider("SFovSlider", { 
    Title = "Silent Fov Radius", 
    Description = "Adjust the FOV Radius",
    Default = 150, -- Default radius
    Min = 50,      -- Minimum radius
    Max = 900,     -- Maximum radius
    Rounding = 0,  -- No rounding (integer values)
    Callback = function(Value)
        SilentAimFov.Radius = Value -- Update the radius value
        if SilentAimFov.Circle then
            SilentAimFov.Circle.Radius = Value -- Update the drawn circle's radius
        end
    end
})

-- Color Picker for FOV Circle
local Colorpicker = Tabs.Silent:AddColorpicker("SFovColorpicker", {
    Title = "Fov Color",
    Default = Color3.fromRGB(96, 205, 255) -- Default FOV color
})

Colorpicker:OnChanged(function(Value)
    SilentAimFov.Color = Value -- Update color value
    if SilentAimFov.Circle then
        SilentAimFov.Circle.Color = Value -- Update the circle color dynamically
    end
end)

-- Target Dropdown
local Dropdown = Tabs.Silent:AddDropdown("Dropdown", {
    Title = "Target Dropdown",
    Values = {"Head", "UpperTorso", "LowerTorso"},
    Multi = false,
    Default = 1, -- Default is Head
})

Dropdown:OnChanged(function(Value)
    SilentAim.TargetPart = Value
    DotPosition = Value
end)

-- Settings
local ESPColor = Color3.new(1, 0, 0) -- Red
local DotSize = 2 -- Default dot size
local MaxRingSize = 12 -- Maximum size of the animated ring
local RingThickness = 2 -- Thickness of the ring
local AnimationSteps = 6 -- Reduced steps for quicker transitions
local AnimationSpeed = 0.03 -- Time between animation steps (seconds)
local RefreshRate = 0.2 -- Update rate (seconds)
local MaxDistance = 300 -- Maximum distance for checking players

-- Customizable Position
local DotPosition = "Head" -- The part of the character to attach the dot (e.g., "Head", "Torso")

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Local Player
local LocalPlayer = Players.LocalPlayer

-- Table to store ESP dots
local ESPDots = {}
local Holding = false -- Tracks if Mouse1 is being held
local IsEnabled = false -- Tracks if the ESP toggle is active

-- Function to create a new dot
local function createDot()
    local dot = Drawing.new("Circle")
    dot.Color = ESPColor
    dot.Radius = DotSize
    dot.Thickness = 1
    dot.Filled = true
    dot.Visible = false
    return dot
end

-- Function to update ESP dots
local function updateESP()
    if not IsEnabled then return nil end  -- If ESP is disabled, exit the function

    local camera = workspace.CurrentCamera
    local centerScreen = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    local closestPlayer = nil
    local closestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(DotPosition) then
            local targetPart = player.Character[DotPosition]
            local targetPosition, onScreen = camera:WorldToViewportPoint(targetPart.Position)
            local distance = (targetPart.Position - camera.CFrame.Position).Magnitude

            if onScreen and distance <= MaxDistance then
                local screenPosition = Vector2.new(targetPosition.X, targetPosition.Y)
                local centerDistance = (screenPosition - centerScreen).Magnitude

                if centerDistance < closestDistance then
                    closestDistance = centerDistance
                    closestPlayer = player
                end
            end
        end
    end

    -- Update visibility for all dots
    for player, dot in pairs(ESPDots) do
        if player == closestPlayer then
            local targetPosition = workspace.CurrentCamera:WorldToViewportPoint(player.Character[DotPosition].Position)
            dot.Position = Vector2.new(targetPosition.X, targetPosition.Y)
            dot.Visible = true
        else
            dot.Visible = false
        end
    end

    return closestPlayer
end

-- Function to animate the transition into a ring
local function animateToRing(dot)
    dot.Filled = false
    for i = 1, AnimationSteps do
        if not Holding then break end -- Stop animation if click ends
        dot.Radius = DotSize + ((MaxRingSize - DotSize) / AnimationSteps) * i
        dot.Thickness = ((RingThickness - 1) / AnimationSteps) * i
        task.wait(AnimationSpeed)
    end
end

-- Function to animate the transition back to a dot
local function animateToDot(dot)
    dot.Filled = false -- Keeps it hollow until animation ends
    for i = AnimationSteps, 1, -1 do
        if Holding then break end -- Stop animation if holding starts
        dot.Radius = DotSize + ((MaxRingSize - DotSize) / AnimationSteps) * i
        dot.Thickness = ((RingThickness - 1) / AnimationSteps) * i
        task.wait(AnimationSpeed)
    end
    dot.Radius = DotSize
    dot.Thickness = 1
    dot.Filled = true -- Restores the filled dot
end

-- Function to clean up ESP dots when players leave
local function cleanUp(player)
    if ESPDots[player] then
        ESPDots[player]:Remove()
        ESPDots[player] = nil
    end
end

-- Create dots for players
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        ESPDots[player] = createDot()
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        ESPDots[player] = createDot()
    end
end)

Players.PlayerRemoving:Connect(cleanUp)

-- Mouse input handling
UserInputService.InputBegan:Connect(function(input, isProcessed)
    if not isProcessed and input.UserInputType == Enum.UserInputType.MouseButton1 then
        Holding = true
        local closestPlayer = updateESP()
        if closestPlayer and ESPDots[closestPlayer] then
            animateToRing(ESPDots[closestPlayer])
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, isProcessed)
    if not isProcessed and input.UserInputType == Enum.UserInputType.MouseButton1 then
        Holding = false
        local closestPlayer = updateESP()
        if closestPlayer and ESPDots[closestPlayer] then
            animateToDot(ESPDots[closestPlayer])
        end
    end
end)

-- Update ESP on render
RunService.RenderStepped:Connect(function()
    task.wait(RefreshRate)
    updateESP()
end)

-- Toggle handling
local Toggle = Tabs.Silent:AddToggle("TargetIndicator", {Title = "Target Indicator", Default = false })

Toggle:OnChanged(function()
    IsEnabled = Toggle.Value  -- Toggle ESP visibility
    if not IsEnabled then
        -- Hide all dots when ESP is disabled
        for _, dot in pairs(ESPDots) do
            dot.Visible = false
        end
    end
end)

---------------------------------------------------------------------------------------------------------------------------------
-------ModTab--------------------------------------------------------------------------------------------------------------------------
local player = game:GetService("Players").LocalPlayer
local username = player.Name
local firstPersonFolder = Workspace:FindFirstChild("ViewModels"):FindFirstChild("FirstPerson")
if not firstPersonFolder then
    warn("FirstPerson folder not found in ViewModels")
    return
end

-- Store the original size of LeftArm and RightArm
local originalSizes = {}

-- Function to modify the arms of the model
local function modifyArms(model, toggleState)
    local leftArm = model:FindFirstChild("LeftArm")
    local rightArm = model:FindFirstChild("RightArm")

    if leftArm then
        if toggleState then
            -- Remove the Mesh from LeftArm if it exists
            local leftArmMesh = leftArm:FindFirstChild("Mesh")
            if leftArmMesh then
                leftArmMesh:Destroy()
            end
            -- Save the original size if not saved and set to (0, 0, 0)
            if not originalSizes[leftArm] then
                originalSizes[leftArm] = leftArm.Size
            end
            leftArm.Size = Vector3.new(0, 0, 0)
        else
            -- Restore the original size
            if originalSizes[leftArm] then
                leftArm.Size = originalSizes[leftArm]
            end
        end
    end

    if rightArm then
        if toggleState then
            -- Remove the Mesh from RightArm if it exists
            local rightArmMesh = rightArm:FindFirstChild("Mesh")
            if rightArmMesh then
                rightArmMesh:Destroy()
            end
            -- Save the original size if not saved and set to (0, 0, 0)
            if not originalSizes[rightArm] then
                originalSizes[rightArm] = rightArm.Size
            end
            rightArm.Size = Vector3.new(0, 0, 0)
        else
            -- Restore the original size
            if originalSizes[rightArm] then
                rightArm.Size = originalSizes[rightArm]
            end
        end
    end
end

-- Function to find and modify the model when it changes
local function onModelChanged()
    if not Options or not Options.NoHands then
        warn("Options.NoHands is missing")
        return
    end

    local modelToModify = nil
    for _, model in pairs(firstPersonFolder:GetChildren()) do
        if model.Name:find(username) then
            modelToModify = model
            break
        end
    end

    if modelToModify then
        -- Apply the toggle state to modify the arms
        local toggleState = Options.NoHands.Value
        modifyArms(modelToModify, toggleState)
    else
        warn("No model found for player: " .. username)
    end
end

-- Initially check and modify the first model
onModelChanged()

-- Listen for changes in the FirstPerson folder and apply changes to the new model
firstPersonFolder.ChildAdded:Connect(onModelChanged)
firstPersonFolder.ChildRemoved:Connect(onModelChanged)

-- Toggle implementation
local Toggle = Tabs.ModTab:AddToggle("NoHands", {Title = "Ghost Hands", Default = false})

Toggle:OnChanged(function()
    -- Update text labels if present
    if textLabels and textLabels.ghosttxt then
        textLabels.ghosttxt.Visible = Toggle.Value
        fadeText(textLabels.ghosttxt, Toggle.Value)
        alignTextLabels()
    end

    -- Recheck the model and apply the toggle state to the arms
    onModelChanged()
end)

local RunService = game:GetService("RunService")
local firstPerson = Workspace.ViewModels.FirstPerson

-- Table to store parts for the effect
local affectedParts = {}

-- Function to apply static transparency to MeshParts
local function applyStaticTransparency()
    -- Clear the previous parts to avoid applying effects to the old model
    affectedParts = {}

    -- Loop through all descendants in the FirstPerson model
    for _, descendant in ipairs(firstPerson:GetDescendants()) do
        -- Check if the descendant is a Model and contains an ItemVisual with a Body part
        local itemVisual = descendant:FindFirstChild("ItemVisual")
        if descendant:IsA("Model") and itemVisual then
            local body = itemVisual:FindFirstChild("Body")
            -- Check if the Body part exists
            if body then
                -- Loop through all children in the Body model
                for _, part in ipairs(body:GetChildren()) do
                    -- Check if the child is a MeshPart
                    if part:IsA("MeshPart") then
                        -- Set the static transparency value
                        part.Transparency = 0.6
                        table.insert(affectedParts, part)  -- Store the part for reference
                    end
                end
            end
        end
    end
end

-- Function to remove static transparency from MeshParts
local function removeStaticTransparency()
    for _, part in ipairs(affectedParts) do
        part.Transparency = 0  -- Reset transparency back to 0
    end
end

-- Add a Toggle to enable/disable the effect
local Toggle = Tabs.ModTab:AddToggle("TransparencyToggle", {
    Title = "Material Weapon",  -- Title of the toggle
    Default = false,            -- Default state (false means the effect is off by default)
})

Toggle:OnChanged(function()
    if Toggle.Value then
        applyStaticTransparency()  -- Apply the static transparency if the toggle is on
    else
        removeStaticTransparency()  -- Remove the static transparency if the toggle is off
    end
end)

-- Function to monitor and reapply static transparency if the model changes
local function monitorModelChange()
    local lastModel = nil
    -- Monitor for any changes in the FirstPerson model
    RunService.Heartbeat:Connect(function()
        local currentModel = firstPerson:FindFirstChildOfClass("Model")
        if currentModel ~= lastModel then
            lastModel = currentModel
            -- Reapply static transparency if the toggle is on
            if Toggle.Value then
                applyStaticTransparency()  -- Reapply the static transparency to the new model
            end
        end
    end)
end

-- Start monitoring the model changes after Toggle is initialized
monitorModelChange()


local player = game:GetService("Players").LocalPlayer
local miscAssets = player.PlayerScripts.Assets:WaitForChild("Misc")
local muzzleFlashes = miscAssets:WaitForChild("MuzzleFlashes")

-- Clone the original "Muzzle Flashes" model
local defaultMuzzleFlash = muzzleFlashes:FindFirstChild("Default")
if defaultMuzzleFlash then
    local muzzleFlashOriginal = defaultMuzzleFlash:Clone()
    muzzleFlashOriginal.Name = "Muzzle Flash Original"
    muzzleFlashOriginal.Parent = muzzleFlashes
end

-- Dropdown for selecting Muzzle Flash
local MuzzleFlashDropdown = Tabs.ModTab:AddDropdown("MuzzleFlashDropdown", {
    Title = "Fire Effect [Bullet]",
    Values = {
        "None", "Aqua Burst", "Demon Shorty", 
        "Demon Uzi", "Dynamite Gun", "Electro Rifle", 
        "Exogun", "Singularity", "Wondergun"
    },
    Multi = false,
    Default = 1,
})


MuzzleFlashDropdown:OnChanged(function(Value)
    -- Remove any current Muzzle Flash model
    local currentMuzzleFlash = muzzleFlashes:FindFirstChild("Default") or muzzleFlashes:FindFirstChild("Muzzle Flash Original")
    if currentMuzzleFlash then
        currentMuzzleFlash:Destroy()
    end

    if Value ~= "None" then
        -- Clone selected Muzzle Flash model
        textLabels.b_effect.Visible = true
        fadeText(textLabels.b_effect, true)
        alignTextLabels() 
        local selectedMuzzleFlash = muzzleFlashes:FindFirstChild(Value)
        
        if selectedMuzzleFlash then
            local clonedMuzzleFlash = selectedMuzzleFlash:Clone()
            clonedMuzzleFlash.Parent = muzzleFlashes
            clonedMuzzleFlash.Name = "Default"
        end

    else
        -- Restore the original Muzzle Flash model
        local originalMuzzleFlash = muzzleFlashes:FindFirstChild("Muzzle Flash Original")
        textLabels.b_effect.Visible = false
        fadeText(textLabels.b_effect, false)
        alignTextLabels() 
        if originalMuzzleFlash then
            local clonedOriginal = originalMuzzleFlash:Clone()
            clonedOriginal.Parent = muzzleFlashes
            clonedOriginal.Name = "Default"
        end
    end
end)




local miscAssets = player.PlayerScripts.Assets:WaitForChild("Misc")

-- References to BurningEffects and FireHitboxes folders
local burningEffects = miscAssets:WaitForChild("BurningEffects")
local fireHitboxes = miscAssets:WaitForChild("FireHitboxes")

-- Backup original Default models
local burningEffectDefault = burningEffects:FindFirstChild("Default")
if burningEffectDefault then
    local burningEffectOriginal = burningEffectDefault:Clone()
    burningEffectOriginal.Name = "Burning Effect Original"
    burningEffectOriginal.Parent = burningEffects
end

local fireHitboxDefault = fireHitboxes:FindFirstChild("Default")
if fireHitboxDefault then
    local fireHitboxOriginal = fireHitboxDefault:Clone()
    fireHitboxOriginal.Name = "Fire Hitbox Original"
    fireHitboxOriginal.Parent = fireHitboxes
end

-- Dropdown for selecting Burning Effect and Fire Hitbox
local FireEffectDropdown = Tabs.ModTab:AddDropdown("FireEffectDropdown", {
    Title = "Moltov Fire ",
    Values = {
        "None", "Hexxed Candle [Purple]"
    },
    Multi = false,
    Default = 1,
})


FireEffectDropdown:OnChanged(function(Value)
    -- Remove current Default models
    local currentBurningEffect = burningEffects:FindFirstChild("Default") or burningEffects:FindFirstChild("Burning Effect Original")
    local currentFireHitbox = fireHitboxes:FindFirstChild("Default") or fireHitboxes:FindFirstChild("Fire Hitbox Original")

    if currentBurningEffect then
        currentBurningEffect:Destroy()
    end
    if currentFireHitbox then
        currentFireHitbox:Destroy()
    end

    if Value == "Hexxed Candle" then
        -- Set Hexxed Candle models as Default
        local hexxedBurningEffect = burningEffects:FindFirstChild("Hexxed Candle")
        local hexxedFireHitbox = fireHitboxes:FindFirstChild("Hexxed Candle")

        if hexxedBurningEffect then
            local clonedBurningEffect = hexxedBurningEffect:Clone()
            clonedBurningEffect.Name = "Default"
            clonedBurningEffect.Parent = burningEffects
        end
        if hexxedFireHitbox then
            local clonedFireHitbox = hexxedFireHitbox:Clone()
            clonedFireHitbox.Name = "Default"
            clonedFireHitbox.Parent = fireHitboxes
        end
    else
        -- Restore the original Default models
        local originalBurningEffect = burningEffects:FindFirstChild("Burning Effect Original")
        local originalFireHitbox = fireHitboxes:FindFirstChild("Fire Hitbox Original")

        if originalBurningEffect then
            local clonedOriginal = originalBurningEffect:Clone()
            clonedOriginal.Name = "Default"
            clonedOriginal.Parent = burningEffects
        end
        if originalFireHitbox then
            local clonedOriginal = originalFireHitbox:Clone()
            clonedOriginal.Name = "Default"
            clonedOriginal.Parent = fireHitboxes
        end
    end
end)



local player = game:GetService("Players").LocalPlayer
local miscAssets = player.PlayerScripts.Assets:WaitForChild("LightingProfiles")

-- Backup original Default Lighting Profile
local defaultLightingProfile = miscAssets:FindFirstChild("Default")
if defaultLightingProfile then
    local defaultProfileOriginal = defaultLightingProfile:Clone()
    defaultProfileOriginal.Name = "Lighting Profile Original"
    defaultProfileOriginal.Parent = miscAssets
end
-- Custom names for dropdown options
local lightingProfiles = {
    None = "None",
    Graveyard = "Scary NightLight",
    GraveyardMatchPoint = "Unfair",
    LobbyHalloween = "Ocen",
    Station = "Hellfire"
}

-- Dropdown for selecting Lighting Profile
local LightingProfileDropdown = Tabs.ModTab:AddDropdown("LightingProfileDropdown", {
    Title = "Atmosphere",
    Values = {
        lightingProfiles.None, lightingProfiles.Graveyard, lightingProfiles.GraveyardMatchPoint,
        lightingProfiles.LobbyHalloween, lightingProfiles.Station
    },
    Multi = false,
    Default = 1,
})

LightingProfileDropdown:SetValue(lightingProfiles.None)

LightingProfileDropdown:OnChanged(function(Value)
    -- Find the corresponding Lighting Profile key
    local selectedKey
    for key, name in pairs(lightingProfiles) do
        if name == Value then
            selectedKey = key
            break
        end
    end

    -- Remove current Lighting Profile
    local currentLightingProfile = miscAssets:FindFirstChild("Default") or miscAssets:FindFirstChild("Lighting Profile Original")
    if currentLightingProfile then
        currentLightingProfile:Destroy()
    end

    -- Update visibility of atmosphere label based on selection
    local showText = selectedKey and selectedKey ~= "None"
    textLabels.atmosphere.Visible = showText
    fadeText(textLabels.atmosphere, showText)
    alignTextLabels()

    -- Apply the selected Lighting Profile or restore original
    if showText then
        -- Clone selected Lighting Profile model
        local selectedLightingProfile = miscAssets:FindFirstChild(selectedKey)
        if selectedLightingProfile then
            local clonedLightingProfile = selectedLightingProfile:Clone()
            clonedLightingProfile.Parent = miscAssets
            clonedLightingProfile.Name = "Default"
        end
    else
        -- Restore the original Lighting Profile
        local originalLightingProfile = miscAssets:FindFirstChild("Lighting Profile Original")
        if originalLightingProfile then
            local clonedOriginal = originalLightingProfile:Clone()
            clonedOriginal.Parent = miscAssets
            clonedOriginal.Name = "Default"
        end
    end
end)


local FlshBangOffToggle = Tabs.Essential:AddToggle("FlshBangOffToggle", {Title = "Hide Flash", Description = "Hide flashbang in game.", Default = false })
local hasBeenToggledOn = false

FlshBangOffToggle:OnChanged(function()
    if Options.FlshBangOffToggle.Value then
        -- Toggle turned on: Remove the FlashbangEffect and mark as toggled on
        hasBeenToggledOn = true
        local player = game["Players - Client"].LocalPlayer
        local flashbangEffect = player.PlayerScripts.Assets.Misc:FindFirstChild("FlashbangEffect")
        if flashbangEffect then
            flashbangEffect:Destroy()
        end
    else
        -- Toggle turned off after being turned on: Show dialog
        if hasBeenToggledOn then
            Window:Dialog({
                Title = "Warning",
                Content = "To get the flashbang working again, rejoin the game. And also save the config if youre using autoload.",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            print("ok.")
                        end
                    }
                }
            })
        end
    end
end)



-- Import RunService for the moving and pulsing effects
local RunService = game:GetService("RunService")

Tabs.ModTab:AddButton({
    Title = "Apply Static Color",
    Description = "Applies a random color weapon.",
    Callback = function()
        -- Access the FirstPerson model
        local firstPerson = Workspace.ViewModels.FirstPerson

        -- Function to generate a random color
        local function getRandomColor()
            return Color3.new(math.random(), math.random(), math.random())
        end

        -- Loop through all descendants in the FirstPerson model
        for _, descendant in ipairs(firstPerson:GetDescendants()) do
            -- Check if the descendant is a Model and contains a Body part
            if descendant:IsA("Model") and descendant:FindFirstChild("ItemVisual") then
                local body = descendant.ItemVisual.Body
                -- Check if the Body part exists
                if body then
                    -- Loop through all children in the Body model
                    for _, part in ipairs(body:GetChildren()) do
                        -- Check if the child is a MeshPart
                        if part:IsA("MeshPart") then
                            -- Assign a random color to the MeshPart
                            part.Color = getRandomColor()
                        end
                    end
                end
            end
        end
    end
})


Tabs.ModTab:AddButton({
    Title = "Animated Material Weapon",
    Description = "Adds animated effects to weapon.",
    Callback = function()
        -- Access the FirstPerson model
        local firstPerson = Workspace.ViewModels.FirstPerson

        -- Table to store parts for continuous effects
        local animatedParts = {}

        -- Loop through all descendants in the FirstPerson model
        for _, descendant in ipairs(firstPerson:GetDescendants()) do
            -- Check if the descendant is a Model and contains a Body part
            if descendant:IsA("Model") and descendant:FindFirstChild("ItemVisual") then
                local body = descendant.ItemVisual.Body
                -- Check if the Body part exists
                if body then
                    -- Loop through all children in the Body model
                    for _, part in ipairs(body:GetChildren()) do
                        -- Check if the child is a MeshPart
                        if part:IsA("MeshPart") then
                            -- Set initial properties for semi-transparent look
                            part.Transparency = 0.4  -- Start transparency in the middle of the pulse range
                            table.insert(animatedParts, part)  -- Store for animation
                        end
                    end
                end
            end
        end

        -- Function for color cycling
        local function getColorCycle(t)
            return Color3.fromHSV((t % 1), 0.5, 1)
        end

        -- Run animation with heartbeat
        RunService.Heartbeat:Connect(function(deltaTime)
            local time = tick()
            for _, part in ipairs(animatedParts) do
                -- Color cycling effect
                part.Color = getColorCycle(time * 0.5)

                -- Pulsing transparency effect between 0.3 and 0.5
                part.Transparency = 0.4 + 0.1 * math.sin(time * 2)

                -- Slow rotation
                part.CFrame = part.CFrame * CFrame.Angles(0, math.rad(1), 0)
            end
        end)
    end
})

local ResolutionSlider = Tabs.ModTab:AddSlider("ResolutionSlider", {
    Title = "Resolution Slider",
    Description = "Adjust the resolution value",
    Default = 100,  -- Default to 100 which represents 1
    Min = 10,      -- Minimum value is 10 which represents 0.1
    Max = 140,     -- Maximum value is 100 which represents 1
    Rounding = 1,  -- Rounding is set to 1 to handle the integer representation
    Callback = function(Value)
        -- Convert the slider value to the corresponding resolution value
        local roundedValue = math.floor(Value / 1 + 0.5)  -- Round to the nearest integer
        getgenv().ResolutionValue = roundedValue / 100 
    end
})

local Camera = Workspace.CurrentCamera
if getgenv().CameraModifier == nil then
    game:GetService("RunService").RenderStepped:Connect(
        function()
            Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, getgenv().ResolutionValue, 0, 0, 0, 1)
        end
    )
end
getgenv().CameraModifier = true



local Toggle = Tabs.ModTab:AddToggle("HitMarker1", {Title = "Show Hitmarker", Description = "Show mark where bullet hits.", Default = false})

Toggle:OnChanged(function()
    local part = game:GetService("Players").LocalPlayer.PlayerScripts.Assets.Misc.ImpactMarkerBullet

    if part then
        if Toggle.Value then
            part.Color = Colorpicker.Value
            part.Transparency = 0  -- Make it fully visible
        else
            part.Transparency = 1
        end
        
    else 

    end

    if textLabels and textLabels.textLabel5 then
        textLabels.textLabel5.Visible = Toggle.Value
        fadeText(textLabels.textLabel5, Toggle.Value)
        alignTextLabels()
    end
end)


local Input = Tabs.ModTab:AddInput("HitMarkInput", {
    Title = "Hit Markar",
    Description = "Leave it empty to hide the marker.",
    Default = "rbxassetid://13862670077",
    Placeholder = "rbxassetid://89024621697883",
    Numeric = false, -- Allows non-numeric values
    Finished = false, -- Calls callback every time the value changes
    Callback = function(Value)
        -- Access Players - Client and update the texture directly in ImpactMarkerBullet.Decal
        game["Players - Client"].LocalPlayer.PlayerScripts.Assets.Misc.ImpactMarkerBullet.Decal.Texture = Value
    end
})

Input:OnChanged(function()
end)


local Colorpicker = Tabs.ModTab:AddColorpicker("HitMarkerColor", {
    Title = "Choose hitmarker",
    Default = Color3.fromRGB(255, 255, 255)
})



Colorpicker:OnChanged(function()
    local part = game:GetService("Players").LocalPlayer.PlayerScripts.Assets.Misc.ImpactMarkerBullet
    
    -- Check if the part exists before changing the color
    if part and Toggle.Value then
        -- Change the color of the part to the selected color if the toggle is on
        part.Color = Colorpicker.Value
    end
end)
Tabs.Essential:AddButton({
    Title = "NightTime",
    Description = "Theres no toggle Cause the time var is dynamic.",
    Callback = function()
        local Lighting = game:GetService("Lighting")

        -- Set the game to nighttime
        Lighting.ClockTime = 0  -- 0 represents midnight
        Lighting.Brightness = 2  -- Adjust brightness to suit your needs
        Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)  -- Darkens outdoor ambient light
        Lighting.Ambient = Color3.fromRGB(30, 30, 30)  -- Sets a dimmer ambient light for the scene
        Lighting.FogColor = Color3.fromRGB(0, 0, 0)  -- Optional: Adds fog effect for a more immersive look
        Lighting.FogStart = 0  -- Optional: Controls how soon the fog starts
        Lighting.FogEnd = 1000  -- Optional: Controls how far the fog stretches

        -- Optional: Set a moon texture for a more realistic effect
        Lighting.MoonTextureId = "rbxassetid://2925120737"  -- Replace with a moon texture asset ID
    end
})

-------------------------------------------------------------------------------------------------------------
--Nades------------------------------------------------------------------------------------------
-- Store the current ESP display mode
local espMode = "Both"  -- Default to "Both"
local maxDistance = 300  -- Maximum distance for ESP

-- Function to create ESP with optional image and text
local function createTextESP(grenade, playerPosition)
    local meshPart = grenade:FindFirstChildOfClass("MeshPart")
    if meshPart then
        -- Calculate the distance from the player to the grenade
        local distance = (meshPart.Position - playerPosition).Magnitude

        -- Only create ESP if within max distance
        if distance <= maxDistance then
            -- Create a BillboardGui for the ESP
            local billboardGui = Instance.new("BillboardGui")
            billboardGui.Adornee = meshPart
            billboardGui.Parent = game.CoreGui
            billboardGui.Size = UDim2.new(0, 100, 0, 100)
            billboardGui.StudsOffset = Vector3.new(0, 3, 0)
            billboardGui.AlwaysOnTop = true

            -- Conditionally add the image
            if espMode == "Image" or espMode == "Both" then
                local imageLabel = Instance.new("ImageLabel")
                imageLabel.Parent = billboardGui
                imageLabel.Size = UDim2.new(0, 20, 0, 20)
                imageLabel.Position = UDim2.new(0.5, -10, 0.5, -10)
                imageLabel.Image = "rbxassetid://82633824117411"
                imageLabel.BackgroundTransparency = 1
            end

            -- Conditionally add the text
            if espMode == "Text" or espMode == "Both" then
                local textLabel = Instance.new("TextLabel")
                textLabel.Parent = billboardGui
                textLabel.Size = UDim2.new(0, 100, 0, 20)
                textLabel.Position = UDim2.new(0.5, -50, 0.5, 15)
                textLabel.Text = "Grenade"
                textLabel.TextColor3 = Color3.fromHex("#041f24")
                textLabel.Font = Enum.Font.GothamBold
                textLabel.TextSize = 14
                textLabel.BackgroundTransparency = 1
                textLabel.TextStrokeTransparency = 0.8
            end
        end
    end
end

-- Function to handle grenades added to the workspace
local function onGrenadeAdded(grenade)

    local player = game.Players.LocalPlayer
    if grenade.Name == "Grenade" and player then
        createTextESP(grenade, player.Character.PrimaryPart.Position)
    end
end

-- Dropdown logic to control ESP mode
local Dropdown = Tabs.Essential:AddDropdown("Dropdown", {
    Title = "Greenade ESP",
    Values = {"Image", "Text", "Both", "None"},
    Multi = false,
    Default = 3,  -- Default to "Both"
})

Dropdown:OnChanged(function(Value)
    espMode = Value
    print("ESP mode changed to:", espMode)

    -- Refresh all existing ESPs based on the new mode
    for _, grenade in pairs(workspace:GetChildren()) do
        if grenade.Name == "Grenade" then
            onGrenadeAdded(grenade)
        end
    end
end)

-- Connect to the workspace's ChildAdded event
workspace.ChildAdded:Connect(function(child)
    if child.Name == "Grenade" then
        onGrenadeAdded(child)
    end
end)

-- Initialize existing grenades in the workspace
for _, grenade in pairs(workspace:GetChildren()) do
    if grenade.Name == "Grenade" then
        onGrenadeAdded(grenade)
    end
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Create a toggle for controlling the Spotlight
local SpotLightToggle = Tabs.Essential:AddToggle("SpotLightToggle", {Title = "Glow Light",Description = "Add lighting to you", Default = false})

-- Create a slider for controlling the Range of the glow light under Tabs.Essential
local RangeSlider = Tabs.Essential:AddSlider("RangeSlider", { 
    Title = "Glow Range",
    Description = "Adjust the range of the glow",
    Default = 35, 
    Min = 0,
    Max = 1000, 
    Rounding = 1,
    Callback = function(Value)
        if player.Character then
            -- Update the range of the glow light
            if player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChild("GlowLight") then
                player.Character.Head.GlowLight.Range = Value
            end
        end
    end
})

-- Create a slider for controlling the Brightness of the glow light under Tabs.Essential
local BrightnessSlider = Tabs.Essential:AddSlider("BrightnessSlider", {
    Title = "Glow Brightness",
    Description = "Adjust the brightness of the glow",
    Default = 2, 
    Min = 0,
    Max = 10,
    Rounding = 1,
    Callback = function(Value)
        if player.Character then
            -- Update the brightness of the glow light
            if player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChild("GlowLight") then
                player.Character.Head.GlowLight.Brightness = Value
            end
        end
    end
})

-- Create a color picker for controlling the color of the glow light under Tabs.Essential
local GlowColorpicker = Tabs.Essential:AddColorpicker("GlowColorpicker", { 
    Title = "Glow Color",
    Default = Color3.fromRGB(96, 205, 255) -- Default color
})

-- Variable to store the PointLight instance for later removal
local glowLight

local function makeHeadGlow(character, range, brightness, color)
    -- Ensure the Head exists
    local head = character:WaitForChild("Head", 5)

    if head then
        -- Check if light already exists to avoid duplication
        if not head:FindFirstChild("GlowLight") then
            glowLight = Instance.new("PointLight")
            glowLight.Name = "GlowLight"
            glowLight.Color = color -- Set the color from the color picker
            glowLight.Brightness = brightness -- Set brightness from the slider
            glowLight.Range = range -- Set the range from the slider
            glowLight.Parent = head
        end
    end
end

local function removeHeadGlow(character)
    local head = character:FindFirstChild("Head")
    if head and head:FindFirstChild("GlowLight") then
        head.GlowLight:Destroy()
    end
end

-- Function to handle character respawn
local function onCharacterAdded(character)
    if SpotLightToggle.Value then
        makeHeadGlow(character, RangeSlider.Value, BrightnessSlider.Value, GlowColorpicker.Value)
    else
        removeHeadGlow(character)
    end
end

-- Initially apply or remove glow based on toggle state
if player.Character then
    onCharacterAdded(player.Character)
end

-- Listen for toggle changes and apply/remove the glow effect
SpotLightToggle:OnChanged(function()
    if player.Character then
        if SpotLightToggle.Value then
            makeHeadGlow(player.Character, RangeSlider.Value, BrightnessSlider.Value, GlowColorpicker.Value)
        else
            removeHeadGlow(player.Character)
        end
    end
end)

-- Listen for color picker changes and update the glow color
GlowColorpicker:OnChanged(function()
    if player.Character then
        if player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChild("GlowLight") then
            player.Character.Head.GlowLight.Color = GlowColorpicker.Value
        end
    end
end)

-- Connect to the CharacterAdded event in case of respawn or teleport
player.CharacterAdded:Connect(onCharacterAdded)


-----weapon-------------------------------------------------------------------------------

local viewModels = player.PlayerScripts.Assets:WaitForChild("ViewModels")
local throwables = player.PlayerScripts.Assets:WaitForChild("Throwables")

-- Helper function to clone models
local function cloneModel(model, parent, name)
    if model then
        local clone = model:Clone()
        clone.Name = name
        clone.Parent = parent
    end
end

-- Function to replace model with selected dropdown value
local function replaceModel(modelName, value, parent, originalName)
    local current = parent:FindFirstChild(modelName)
    if current then current:Destroy() end
    local newModel = parent:FindFirstChild(value == "None" and originalName or value)
    if newModel then
        local clone = newModel:Clone()
        clone.Name = modelName
        clone.Parent = parent
    end
end

-- Function to setup dropdown for each weapon model
local function setupDropdown(name, title, values, parent, modelMap)
    local dropdown = Tabs.Skinz:AddDropdown(name .. "Dropdown", {
        Title = title,
        Values = values,
        Multi = false,
        Default = 1,
    })

    dropdown:OnChanged(function(Value)
        replaceModel(name, Value, parent, name .. " Original")
    end)
end

-- Clone original models for weapons
local weaponConfigs = {
    {"Assault Rifle", "Assault Rifle Original", {"None", "AUG", "AK-47", "Boneclaw Rifle"}},
    {"Revolver", "Revolver Original", {"None", "Boneclaw Revolver"}},
    {"Bow", "Bow Original", {"None", "Bat Bow", "Compound Bow", "Raven Bow"}},
    {"Shorty", "Shorty Original", {"None", "Lovely Shorty", "Not So Shorty", "Too Shorty", "Demon Shorty"}},
    {"Burst Rifle", "Burst Rifle Original", {"None", "Electro Rifle", "Aqua Burst", "Pixel Burst", "Spectral Burst"}},
    {"RPG", "RPG Original", {"None", "Nuke Launcher"}},
    {"Shotgun", "Shotgun Original", {"None", "Balloon Shotgun", "Hyper Shotgun"}},
    {"Sniper", "Sniper Original", {"None", "Pixel Sniper", "Hyper Sniper", "Keyper", "Eyething Sniper"}},
}

for _, config in ipairs(weaponConfigs) do
    local model = viewModels:FindFirstChild(config[1])
    if model then
        cloneModel(model, viewModels, config[2])
        setupDropdown(config[1], config[1], config[3], viewModels, config[1])
    end
end

-- Clone Grenade and Molotov models
cloneModel(viewModels:FindFirstChild("Grenade"), viewModels, "Grenade Original")
cloneModel(throwables:FindFirstChild("Grenade"), throwables, "Grenade Original")
cloneModel(viewModels:FindFirstChild("Molotov"), viewModels, "Molotov Original")
cloneModel(throwables:FindFirstChild("Molotov"), throwables, "Molotov Original")

-- Create dropdowns for Grenade and Molotov
setupDropdown("Grenade", "Grenade", {"None", "Whoopee Cushion", "Water Balloon", "Soul Grenade"}, viewModels)
setupDropdown("Molotov", "Molotov", {"None", "Coffee", "Hexxed Candle", "Torch"}, viewModels)

-- Clone and create dropdown for Scythe
cloneModel(viewModels:FindFirstChild("Scythe"), viewModels, "Scythe Original")
cloneModel(throwables:FindFirstChild("Scythe"), throwables, "Scythe Original")

local ScytheDropdown = Tabs.Skinz:AddDropdown("ScytheDropdown", {
    Title = "Scythe",
    Values = {"None", "Keythe", "Anchor"},
    Multi = false,
    Default = 1,
})

ScytheDropdown:OnChanged(function(Value)
    replaceModel("Scythe", Value, viewModels, "Scythe Original")
    replaceModel("Scythe", Value, throwables, "Scythe Original")
end)

-------------------------------------------------



local throwables = player.PlayerScripts.Assets:WaitForChild("Throwables")
local smokeClouds = player.PlayerScripts.Assets.Misc.SmokeClouds
local function cloneModel(sourceModel, targetParent, newName)
    if sourceModel then
        local clone = sourceModel:Clone()
        clone.Name = newName
        clone.Parent = targetParent
    end
end

-- Function to destroy models
local function destroyModel(parent, name)
    local model = parent:FindFirstChild(name)
    if model then
        model:Destroy()
    end
end

-- Clone original models
cloneModel(viewModels:FindFirstChild("Smoke Grenade"), viewModels, "Smoke Grenade Original")
cloneModel(throwables:FindFirstChild("Smoke Grenade"), throwables, "Smoke Grenade Original")
cloneModel(smokeClouds:FindFirstChild("Default"), smokeClouds, "Smoke Grenade Original")
cloneModel(viewModels:FindFirstChild("Flashbang"), viewModels, "Flashbang Original")
cloneModel(throwables:FindFirstChild("Flashbang"), throwables, "Flashbang Original")

-- Dropdown for Smoke Grenade
local SmokeGrenadeDropdown = Tabs.Skinz:AddDropdown("SmokeGrenadeDropdown", {
    Title = "Smoke Grenade ",
    Values = {"None", "Eyeball", "Balance"},
    Multi = false,
    Default = 1,
})

SmokeGrenadeDropdown:OnChanged(function(Value)
    -- Destroy existing models
    destroyModel(viewModels, "Smoke Grenade")
    destroyModel(viewModels, "Smoke Grenade Original")
    destroyModel(throwables, "Smoke Grenade")
    destroyModel(throwables, "Smoke Grenade Original")
    destroyModel(smokeClouds, "Default")
    destroyModel(smokeClouds, "Smoke Grenade Original")

    local modelName = (Value == "None") and "Smoke Grenade Original" or Value
    -- Clone new models based on dropdown value
    cloneModel(viewModels:FindFirstChild(modelName), viewModels, "Smoke Grenade")
    cloneModel(throwables:FindFirstChild(modelName), throwables, "Smoke Grenade")
    cloneModel(smokeClouds:FindFirstChild(modelName), smokeClouds, "Default")
end)

-- Dropdown for Flashbang
local FlashbangDropdown = Tabs.Skinz:AddDropdown("FlashbangDropdown", {
    Title = "Flashbang ",
    Values = {"None", "Skullbang", "Disco Ball", "Camera", "Pixel Flashbang"},
    Multi = false,
    Default = 1,
})

FlashbangDropdown:OnChanged(function(Value)
    -- Destroy current models
    destroyModel(viewModels, "Flashbang")
    destroyModel(viewModels, "Flashbang Original")
    destroyModel(throwables, "Flashbang")
    destroyModel(throwables, "Flashbang Original")

    -- Clone new model based on dropdown value
    local modelName = (Value == "None") and "Flashbang Original" or Value
    cloneModel(viewModels:FindFirstChild(modelName), viewModels, "Flashbang")
    cloneModel(throwables:FindFirstChild(modelName), throwables, "Flashbang")
end)


end


-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()

----unoptimized-------
local CoreGui = game:GetService("CoreGui")

-- Look through all descendants
for _, descendant in ipairs(CoreGui:GetDescendants()) do
    if descendant:IsA("TextLabel") and descendant.Text == "Silent Aim" then
        -- Create an ImageLabel in the parent of the TextLabel
        local imageLabel = Instance.new("ImageLabel")
        imageLabel.Parent = descendant.Parent
        imageLabel.Image = "rbxassetid://74805819520859"
        imageLabel.Size = UDim2.new(0, 60, 0, 6) -- Set the specified size
        imageLabel.Position = UDim2.new(0, 0, 1, 0) -- Position below the TextLabel
        imageLabel.BackgroundTransparency = 1

        break
    end
end

local function createModernSignboard(position, imageId, rotation)
    -- Create the main frame of the signboard
    local boardFrame = Instance.new("Part")
    boardFrame.Size = Vector3.new(20, 7, 0.5) -- Increased height to make the image taller
    boardFrame.CFrame = CFrame.new(position) * CFrame.Angles(0, math.rad(rotation), 0) -- Apply 140-degree rotation
    boardFrame.Anchored = true
    boardFrame.Material = Enum.Material.Metal
    boardFrame.Color = Color3.fromRGB(55, 55, 55) -- Dark metallic gray
    boardFrame.Name = "ModernSignboardFrame"
    boardFrame.Parent = workspace

    -- Create the glass panel for the signboard
    local glassPanel = Instance.new("Part")
    glassPanel.Size = Vector3.new(19.5, 6.5, 0.1) -- Adjusted to fit the taller frame
    glassPanel.CFrame = boardFrame.CFrame * CFrame.new(0, 0, -0.3) -- Position relative to the frame
    glassPanel.Anchored = true
    glassPanel.Material = Enum.Material.Glass
    glassPanel.Transparency = 0.3
    glassPanel.Color = Color3.fromRGB(200, 200, 200) -- Light gray for glass
    glassPanel.Name = "ModernSignboardGlass"
    glassPanel.Parent = workspace

    -- Add SurfaceGui for the image
    local surfaceGui = Instance.new("SurfaceGui", glassPanel)
    surfaceGui.Face = Enum.NormalId.Front
    surfaceGui.Adornee = glassPanel

    local imageLabel = Instance.new("ImageLabel", surfaceGui)
    imageLabel.Size = UDim2.new(1, 0, 1, 0) -- Use the full height and width of the glass panel
    imageLabel.BackgroundTransparency = 1
    imageLabel.Image = "rbxassetid://" .. imageId -- Set the image ID here
    imageLabel.Name = "ImageLabel"

    -- Create the stand for the signboard
    local stand = Instance.new("Part")
    stand.Size = Vector3.new(0.5, 12, 0.5) -- Increased height to match the taller board
    stand.CFrame = boardFrame.CFrame * CFrame.new(0, -11, 0) -- Position relative to the frame
    stand.Anchored = true
    stand.Material = Enum.Material.Metal
    stand.Color = Color3.fromRGB(45, 45, 45) -- Slightly darker metallic gray
    stand.Name = "ModernSignboardStand"
    stand.Parent = workspace

    -- Weld the frame and glass to the stand
    local weldFrame = Instance.new("WeldConstraint")
    weldFrame.Part0 = boardFrame
    weldFrame.Part1 = stand
    weldFrame.Parent = boardFrame

    local weldGlass = Instance.new("WeldConstraint")
    weldGlass.Part0 = glassPanel
    weldGlass.Part1 = boardFrame
    weldGlass.Parent = glassPanel
end

-- Example usage
local signPosition = Vector3.new(119.93, -678.12, 1172.90)
local imageId = "88651960602395" -- Replace with your image ID
local rotation = 140 -- Rotation in degrees (clockwise around the Y-axis)


local coreGui = game:GetService("CoreGui")
local imageId = "rbxassetid://114688178113371"

-- Function to locate the TextLabel with the specific text and add an image in its grandparent
local function addImageToGrandparent()
    local targetLabel = nil

    -- Search through CoreGui for the TextLabel
    for _, child in ipairs(coreGui:GetDescendants()) do
        if child:IsA("TextLabel") and child.Text == "Are you winning son ?" then
            targetLabel = child
            break
        end
    end

    -- If the label is found, add the image to its grandparent
    if targetLabel and targetLabel.Parent and targetLabel.Parent.Parent and targetLabel.Parent.Parent.Parent then
        local image = Instance.new("ImageLabel")
        image.Size = UDim2.new(0, 300, 0, 100) -- Set size
        image.Position = UDim2.new(0.5, -150, 0, 0) -- Centered in the grandparent
        image.AnchorPoint = Vector2.new(0.5, 0) -- Anchor to center horizontally
        image.Image = imageId
        image.BackgroundTransparency = 1
        image.Parent = targetLabel.Parent.Parent.Parent
    else
        warn("TextLabel with text 'Are you winning son ?' not found or its grandparent is inaccessible.")
    end
end



local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Look through all descendants
for _, descendant in ipairs(CoreGui:GetDescendants()) do
    if descendant:IsA("ImageLabel") and descendant.Image == "rbxassetid://76783885872706" then
        -- Resize the image
        descendant.Size = UDim2.new(0, 20, 0, 24)

        -- Create the shake animation (simulate cold shaking horizontally)
        local originalPosition = descendant.Position
        local shakeAmount = 2 -- Small shake amount due to small image size
        local shakeDuration = 1 -- Shake for 1 second
        local repeatDuration = 4 -- Repeat every 4 seconds

        -- Function to apply horizontal shake
        local function shake()
            local startTime = tick()
            while tick() - startTime < shakeDuration do
                local shakeOffset = math.sin(tick() * 50) * shakeAmount
                descendant.Position = originalPosition + UDim2.new(0, shakeOffset, 0, 0)
                wait(0.05) -- Control the shake frequency
            end
            descendant.Position = originalPosition -- Return to original position after shaking
        end

        -- Use an event to repeat the shake every 4 seconds
        local shakeEvent = Instance.new("BindableEvent")
        shakeEvent.Event:Connect(function()
            shake()
        end)

-- Trigger the shake every 4 seconds (safe)
task.spawn(function()
    while descendant and descendant.Parent do
        shake()
        task.wait(repeatDuration)
    end
end)

task.spawn(function()
    local CoreGui = game:GetService("CoreGui")

    task.wait(1) -- wait for UI to fully load

    for _, v in ipairs(CoreGui:GetDescendants()) do
        if v:IsA("ImageLabel") then
            if v.Image == "rbxassetid://114688178113371"
            or v.Image:lower():find("8bit")
            or v.Image:lower():find("rivals") then
                
            end
        end
    end
end)
task.spawn(function()
    local CoreGui = game:GetService("CoreGui")
    task.wait(1)

    for _, v in ipairs(CoreGui:GetDescendants()) do
        if v:IsA("ImageLabel")
        and v.Image
        and v.Image:lower():find("8bit") then

            -- hide original 8bit logo safely
            v.ImageTransparency = 1

            -- overlay UMAR HUB logo
            local overlay = Instance.new("ImageLabel")
            overlay.Name = "UmarHubLogo"
            overlay.Parent = v.Parent
            overlay.Size = v.Size
            overlay.Position = v.Position
            overlay.AnchorPoint = v.AnchorPoint
            overlay.Rotation = v.Rotation
            overlay.ZIndex = (v.ZIndex or 1) + 10
            overlay.BackgroundTransparency = 1
            overlay.Image = "rbxassetid://114688178113371"

            -- soft shake (safe)
            local originalPos = overlay.Position
            task.spawn(function()
                while overlay and overlay.Parent do
                    for i = 1, 20 do
                        overlay.Position = originalPos + UDim2.new(
                            0,
                            math.sin(tick() * 40) * 2,
                            0,
                            0
                        )
                        task.wait(0.05)
                    end
                    overlay.Position = originalPos
                    task.wait(4)
                end
            end)

            break
        end
    end
end)
