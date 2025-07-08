-- https://raw.githubusercontent.com/yixiyotatsuki/stuff/refs/heads/main/lib.lua
local module={}

function module:GetNetworkPing():number -- returns user ping by seconds (great for remote stuff, autorespawn etc)
    local item=game:GetService("Stats"):WaitForChild("Network"):WaitForChild("ServerStatsItem")
    local value=item:WaitForChild("Data Ping"):GetValue()

    return value/1000
end

function module:GetPlayer(name:string,ignoreLocalPlayer):Player -- get player from shortened name (ignore caps, display and user are checked)
    local target=nil
    for _,v:Player in ipairs(game:GetService("Players"):GetPlayers()) do
        local display,user=v.DisplayName:lower(),v.Name:lower()
        if v==game:GetService("Players").LocalPlayer and ignoreLocalPlayer then continue end

        if (user:sub(1,#name)==name) or (display:sub(1,#name)==name) then
            target=v
        end
    end
    return target
end

function module:Stopwatch() -- upvalue, creates a stopwatch (useful for waiting a few seconds in a repeat until loop)
    local timer=0
    game:GetService("RunService").Heartbeat:Connect(function(delta)
        timer+=delta
    end)
    return function()
        return timer
    end
end

function module:loadAnimation(id):AnimationTrack -- returns an animationtrack using the id
    local anim=Instance.new("Animation")
    anim.AnimationId=tostring(id)
    local char=game:GetService("Players").LocalPlayer.Character
    local animator:Animator=char:WaitForChild("Humanoid"):WaitForChild("Animator")
    local data=animator:LoadAnimation(anim)
    return data
end

function module:fireRemote(remote,args)
    task.spawn(function()
        remote:FireServer(unpack(args))
    end)
end

function module:GetTool(name)
    return game:GetService("Players").LocalPlayer:WaitForChild("Backpack"):FindFirstChild(name) or game:GetService("Players").LocalPlayer.Character:FindFirstChild(name)
end

return module
