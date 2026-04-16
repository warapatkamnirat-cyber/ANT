-- 🌊 PRIME FARM FULL SYSTEM

local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- ⚙️ ตัวแปร
local ฟาร์ม = false
local เลือกอาวุธ = "ดาบ"
local มอนที่เลือก = nil
local โหมด = "ออโต้" -- "ออโต้" หรือ "เลือกเอง"

-- 📊 ตารางเลเวล (แก้ชื่อมอนตามเกม)
local ตารางเลเวล = {
    {Min = 1, Max = 10, Mob = "Bandit"},
    {Min = 11, Max = 25, Mob = "Pirate"},
    {Min = 26, Max = 50, Mob = "Brute"},
}

-- 📜 ตั้งค่าเควส
local NPC_Quest_Name = "QuestNPC"
local QuestRemote = "AcceptQuest"

-- 🧱 UI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "PrimeFarmUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 300)
Frame.Position = UDim2.new(0.5, -125, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(20,20,30)
Instance.new("UICorner", Frame)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,40)
Title.Text = "⚓ PRIME FARM"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

-- 🚀 ฟาร์ม
local FarmBtn = Instance.new("TextButton", Frame)
FarmBtn.Size = UDim2.new(0.8,0,0,35)
FarmBtn.Position = UDim2.new(0.1,0,0.18,0)
FarmBtn.Text = "🚀 เริ่มฟาร์ม"
FarmBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
FarmBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", FarmBtn)

-- ⚔️ อาวุธ
local WeaponBtn = Instance.new("TextButton", Frame)
WeaponBtn.Size = UDim2.new(0.8,0,0,35)
WeaponBtn.Position = UDim2.new(0.1,0,0.33,0)
WeaponBtn.Text = "⚔️ ดาบ"
WeaponBtn.BackgroundColor3 = Color3.fromRGB(80,80,120)
WeaponBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", WeaponBtn)

-- 🧠 โหมด
local ModeBtn = Instance.new("TextButton", Frame)
ModeBtn.Size = UDim2.new(0.8,0,0,30)
ModeBtn.Position = UDim2.new(0.1,0,0.48,0)
ModeBtn.Text = "🧠 ออโต้เลเวล"
ModeBtn.BackgroundColor3 = Color3.fromRGB(120,80,160)
ModeBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", ModeBtn)

-- 📜 มอน
local Scroll = Instance.new("ScrollingFrame", Frame)
Scroll.Size = UDim2.new(0.8,0,0,100)
Scroll.Position = UDim2.new(0.1,0,0.62,0)
Scroll.BackgroundColor3 = Color3.fromRGB(30,30,45)
Instance.new("UICorner", Scroll)

local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0,5)

-- ❌ ปิด
local Close = Instance.new("TextButton", Frame)
Close.Size = UDim2.new(0,30,0,30)
Close.Position = UDim2.new(1,-35,0,5)
Close.Text = "X"
Close.BackgroundColor3 = Color3.fromRGB(255,70,70)
Close.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Close)

Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- 🔘 ปุ่ม
FarmBtn.MouseButton1Click:Connect(function()
    ฟาร์ม = not ฟาร์ม
    FarmBtn.Text = ฟาร์ม and "⛔ หยุดฟาร์ม" or "🚀 เริ่มฟาร์ม"
end)

WeaponBtn.MouseButton1Click:Connect(function()
    if เลือกอาวุธ == "ดาบ" then
        เลือกอาวุธ = "มือ"
        WeaponBtn.Text = "👊 มือ"
    else
        เลือกอาวุธ = "ดาบ"
        WeaponBtn.Text = "⚔️ ดาบ"
    end
end)

ModeBtn.MouseButton1Click:Connect(function()
    if โหมด == "ออโต้" then
        โหมด = "เลือกเอง"
        ModeBtn.Text = "🎯 เลือกเอง"
    else
        โหมด = "ออโต้"
        ModeBtn.Text = "🧠 ออโต้เลเวล"
    end
end)

-- 📜 โหลดมอน
function โหลดมอน()
    for _,v in pairs(Scroll:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end

    local list = {}
    for _,mob in pairs(game.Workspace.Enemies:GetChildren()) do
        if mob:FindFirstChild("Humanoid") and not list[mob.Name] then
            list[mob.Name] = true

            local btn = Instance.new("TextButton", Scroll)
            btn.Size = UDim2.new(1,0,0,30)
            btn.Text = mob.Name
            btn.BackgroundColor3 = Color3.fromRGB(60,60,90)
            btn.TextColor3 = Color3.new(1,1,1)
            Instance.new("UICorner", btn)

            btn.MouseButton1Click:Connect(function()
                มอนที่เลือก = mob.Name
            end)
        end
    end

    Scroll.CanvasSize = UDim2.new(0,0,0,UIList.AbsoluteContentSize.Y)
end

โหลดมอน()

-- 🧠 ระบบเลเวล
function หาเลเวล()
    local stats = player:FindFirstChild("leaderstats")
    if stats and stats:FindFirstChild("Level") then
        return stats.Level.Value
    end
    return 1
end

function เลือกมอนตามเลเวล()
    local level = หาเลเวล()
    for _,v in pairs(ตารางเลเวล) do
        if level >= v.Min and level <= v.Max then
            return v.Mob
        end
    end
end

-- 🔍 หาเป้าหมาย
function หาเป้าหมาย()
    local targetName

    if โหมด == "ออโต้" then
        targetName = เลือกมอนตามเลเวล()
    else
        targetName = มอนที่เลือก
    end

    for _,mob in pairs(game.Workspace.Enemies:GetChildren()) do
        if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
            if not targetName or mob.Name == targetName then
                return mob
            end
        end
    end
end

-- ⚔️ ถืออาวุธ
function ถืออาวุธ()
    local char = player.Character
    local backpack = player.Backpack

    if เลือกอาวุธ == "มือ" then
        for _,v in pairs(char:GetChildren()) do
            if v:IsA("Tool") then v.Parent = backpack end
        end
    else
        for _,v in pairs(backpack:GetChildren()) do
            if v:IsA("Tool") then
                v.Parent = char
                break
            end
        end
    end
end

-- 🗡️ ตี
function ตี()
    for _,v in pairs(player.Character:GetChildren()) do
        if v:IsA("Tool") then
            v:Activate()
            return
        end
    end
end

-- 📜 เช็คเควส
function มีเควส()
    return player:FindFirstChild("Quest") ~= nil
end

-- 📜 รับเควส
function รับเควส()
    local npc = game.Workspace:FindFirstChild(NPC_Quest_Name)
    if npc and npc:FindFirstChild("HumanoidRootPart") then
        
        player.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame
        wait(1)

        local remote = game.ReplicatedStorage:FindFirstChild(QuestRemote)
        if remote then
            remote:FireServer()
        end
    end
end

-- 🔁 ลูปหลัก
spawn(function()
    while true do
        wait(0.2)

        if ฟาร์ม then
            pcall(function()

                -- 📜 เควส
                if not มีเควส() then
                    รับเควส()
                end

                ถืออาวุธ()

                local mob = หาเป้าหมาย()
                if mob then
                    local root = player.Character.HumanoidRootPart
                    local dist = (root.Position - mob.HumanoidRootPart.Position).Magnitude

                    TweenService:Create(
                        root,
                        TweenInfo.new(dist/50, Enum.EasingStyle.Linear),
                        {CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0,0,3)}
                    ):Play()

                    ตี()
                end
            end)
        end
    end
end)
