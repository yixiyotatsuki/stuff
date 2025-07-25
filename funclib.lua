-- https://raw.githubusercontent.com/yixiyotatsuki/stuff/refs/heads/main/funclib.lua
local module={}

function module:GetPing():number -- returns user ping by seconds (great for remote stuff, autorespawn etc)
    local item=game:GetService("Stats"):WaitForChild("Network"):WaitForChild("ServerStatsItem") -- to whoever protests that player:GetNetworkPing() is better fuck you
    local value=item:WaitForChild("Data Ping"):GetValue()

    return value/1000
end

--[[ i removed this because i think its useless
function module:GetPhysicsDelta():number
    return 1/workspace:GetRealPhysicsFPS()
end
]]
function module:GetRenderDelta():number -- this probably isnt accurate
    return game:GetService("Stats").HeartbeatTime
end

function module:GetPlayer(name:string,ignoreLocalPlayer):Player -- get player from shortened name (ignore caps, display and user are checked)
    for _,v:Player in ipairs(game:GetService("Players"):GetPlayers()) do
        local display,user=v.DisplayName:lower(),v.Name:lower()
        if v==game:GetService("Players").LocalPlayer and ignoreLocalPlayer then continue end

        if (user:sub(1,#name)==name) or (display:sub(1,#name)==name) then
            return v
        end
    end
    return nil
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

function module:fireRemote(remote,args) -- fires a remote
    task.spawn(function()
        remote:FireServer(unpack(args))
    end)
end

function module:GetTool(name) -- searches for the tool in the players inventory or the players character (holding item)
    local object=game:GetService("Players").LocalPlayer:WaitForChild("Backpack"):FindFirstChild(name)
    if object==nil and game:GetService("Players").LocalPlayer.Character~=nil then object=game:GetService("Players").LocalPlayer.Character:FindFirstChild(name) end
    return object
end

return module
