--[[
prefix is "-"
-fling (user or display, can be shortened) = format
]]

local funclib=loadstring(game:HttpGet("https://raw.githubusercontent.com/yixiyotatsuki/stuff/main/funclib.lua"))()
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local RunService=game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local RS=RunService.RenderStepped
local Player=Players.LocalPlayer
local Character=Player.Character
local HumanoidRootPart=Character:WaitForChild("HumanoidRootPart")

function fling(player,hrpname)
    local char=player.Character

    local hum,hrp=char:WaitForChild("Humanoid"),char:FindFirstChild(hrpname or "HumanoidRootPart")
    local time=funclib:Stopwatch()
    local bodypos=Instance.new("BodyPosition")
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
        local moveprediction=hrp.Velocity/(1.5+funclib:GetPing())
        bodypos.Position=hrp.Position+moveprediction
        t=-t
        HumanoidRootPart.AssemblyAngularVelocity=Vector3.new(0,t*10000,0)
        task.wait()
    until time()>=5 or hrp.Velocity.Magnitude>=500
    bodypos:Destroy()
    local time=funclib:Stopwatch()
    repeat
        HumanoidRootPart:PivotTo(lastCFrame)
        HumanoidRootPart.AssemblyAngularVelocity=Vector3.zero
        HumanoidRootPart.Velocity=Vector3.zero
        task.wait()
    until time>=.1
end

Player.Chatted:Connect(function(msg)
    local args=msg:sub(2,#msg):split()
    if msg:sub(1)=="-" then
        if args[1]=="fling" then
            local plr=funclib:GetPlayer(args[2])
            if plr~=nil then
                fling(plr)
            end
        end
    end
end)
game:GetService("StarterGui"):SetCore("SendNotification",{
    Title="watermark",
    Text="made by @.zamnsuki on discord",
    Duration=9e9  
})
