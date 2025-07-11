local Fluent=loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local funclib=loadstring(game:HttpGet("https://raw.githubusercontent.com/yixiyotatsuki/stuff/main/funclib.lua"))()
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local RunService=game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local RS=RunService.RenderStepped
local Player=Players.LocalPlayer
local Character=Player.Character
local HumanoidRootPart=Character:WaitForChild("HumanoidRootPart")
Player.CharacterAdded:Connect(function(character)
    Character=character
    HumanoidRootPart=Character:WaitForChild("HumanoidRootPart")
end)

function fling(player,hrpname)
    local char=player.Character
    local hum,hrp=char:WaitForChild("Humanoid"),char:FindFirstChild(hrpname or "HumanoidRootPart")
    local time=funclib:Stopwatch()
    local bodypos,bv=Instance.new("BodyPosition")
    bodypos.P=150000
    bodypos.MaxForce=Vector3.one*1/0
    bodypos.D=1000
    bodypos.Parent=HumanoidRootPart
    for i,v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide=false
        end
    end
    local lastCFrame=HumanoidRootPart:GetPivot()
    local t=1
    repeat
        workspace.CurrentCamera.CameraSubject=hum
        Character:WaitForChild("Humanoid").PlatformStand=true
        local moveprediction=hrp.Velocity/(1.5+funclib:GetPing())
        bodypos.Position=hrp.Position+moveprediction
        t=-t
        HumanoidRootPart.AssemblyAngularVelocity=Vector3.new(0,t*25000,0)
        task.wait()
    until time()>=5 or hrp.Velocity.Magnitude>=1000 and hum.FloorMaterial==Enum.Material.Air
    bodypos:Destroy()
    local time=funclib:Stopwatch()
    repeat
        HumanoidRootPart:PivotTo(lastCFrame)
        Character:WaitForChild("Humanoid").PlatformStand=false
        HumanoidRootPart.AssemblyAngularVelocity=Vector3.zero
        HumanoidRootPart.Velocity=Vector3.zero
        workspace.CurrentCamera.CameraSubject=Character:WaitForChild("Humanoid")
        task.wait()
    until time()>=.1
end

local Window=Fluent:CreateWindow({
    Title="fling",
    SubTitle="by @.zamnsuki on discord",
    TabWidth=160,
    Size=UDim2.fromOffset(480,250),
    Acrylic=false,
    Theme="Darker",
    MinimizeKey=Enum.KeyCode.RightControl
})
local main=Window:AddTab({Title="main"})
main:AddInput("",{
    Title="fling!!!",
    Default="",
    Placeholder="insert username",
    Finished=true,
    Callback=function(v)
        local plr=funclib:GetPlayer(v)
        if not plr then
            return Fluent:Notify({Title="fling",Content="the plr doesnt exist"})
        end
        fling(plr)
    end
})
