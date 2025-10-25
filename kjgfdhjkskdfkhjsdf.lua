local Luxtl = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Luxware-UI-Library/main/Source.lua"))()

local Luxt = Luxtl.CreateWindow("gamescript.rage")

local mainTab = Luxt:Tab("Ragebot")
local aa = Luxt:Tab("Anti Hit")
local vis = Luxt:Tab("Visuals")
local vers = Luxt:Tab("Script Version")

local ff = mainTab:Section("Noes")
local ff3 = mainTab:Section("Aimbot")
local ff2 = mainTab:Section("Weapons")
local scale = mainTab:Section("Scale")
local move = mainTab:Section("Movement")
local chams = vis:Section("Chams")
local world = vis:Section("World")
local impacts_sect = vis:Section("Impacts")
local trace = vis:Section("Tracers")
local model_changer = vis:Section("Model Changer")
local player = vis:Section("Player")
local aa1 = aa:Section("Fakelag")
local aa2 = aa:Section("Main")
local info = vers:Section("Script Information")
local plr = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = plr:GetMouse()
local toggle = true
local prevplrpos = math.huge
local object_to_off = nil
getgenv().double = false
getgenv().predict = true
local predict_power = 0.01
local prevpos_need = nil
local Virtual = game:GetService("VirtualInputManager")
local aiming_toggled = true
ff3:Toggle("Auto Fire", function(isToggled)
    
    getgenv().firing = isToggled
    task.spawn(function()
        while game:GetService("RunService").PreSimulation:Wait() do

            for _, i in pairs(game.Players:GetPlayers()) do
                if getgenv().firing and game:GetService("UserInputService").MouseBehavior ~= Enum.MouseBehavior.Default then
                    if i.Character and i.Character:FindFirstChild("HeadHB") and i.Name ~= plr.Name then
                        
                        if i.Character and i.Character:FindFirstChild("HeadHB") and camera:WorldToScreenPoint(i.Character.HeadHB.Position) and i.Status.Team.Value ~= plr.Status.Team.Value and aiming_toggled then
                            if getgenv().predict then
                                prevpos_need = mouse.Hit.Position
                                camera.CFrame = CFrame.lookAt(camera.CFrame.Position, i.Character.HeadHB.Position + i.Character.HeadHB.Velocity * predict_power)
                            else
                                prevpos_need = mouse.Hit.Position
                                camera.CFrame = CFrame.lookAt(camera.CFrame.Position, i.Character.HeadHB.Position)
                            end
                            if mouse.Target == i.Character.HeadHB then
                                aiming_toggled = false
                                game:GetService("RunService").Heartbeat:Wait()
                                Virtual:SendMouseButtonEvent(10, 10, 0, true, game.Workspace, 0)
                                game:GetService("RunService").PreRender:Wait()
                                camera.CFrame = CFrame.lookAt(camera.CFrame.Position, prevpos_need)
                                task.wait(0.03)
                                Virtual:SendMouseButtonEvent(10, 10, 0, false, game.Workspace, 0)
                                aiming_toggled = true
                            else
                                camera.CFrame = CFrame.lookAt(camera.CFrame.Position, prevpos_need)
                            end
                        end
                    end
                else
                    break
                end
            end
        end
    end)

end)
ff3:Toggle("Rage Aim", function(isToggled)
    
    getgenv().aim = isToggled
    mouse.Button1Up:Connect(function()
        task.wait(0.3)
    	toggle = false
    end)
    mouse.Button1Down:Connect(function()
    	toggle = true
    	task.spawn(function()
        	while game:GetService("RunService").Stepped:Wait() and toggle and getgenv().aim do
        	    for _, is in pairs(game.Players:GetPlayers()) do
                    if is and is.Name ~= plr.Name and is.Character ~= nil and is.Character:FindFirstChild("HeadHB") and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        if is.Status.Team.Value ~= plr.Status.Team.Value then
                            local magnited = (is.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                            if magnited < prevplrpos then
                                prevplrpos = magnited
                                if is and is.Character and is.Character:FindFirstChild("HumanoidRootPart") then
                                    if getgenv().predict then
                                        camera.CFrame = CFrame.lookAt(camera.CFrame.Position, is.Character.HeadHB.Position + is.Character.HeadHB.Velocity * predict_power)
                                        game:GetService("RunService").RenderStepped:Wait()
                                        break
                                    else
                                        camera.CFrame = CFrame.lookAt(camera.CFrame.Position, is.Character.HeadHB.Position)
                                        game:GetService("RunService").RenderStepped:Wait()
                                    end
                                end
                            elseif magnited > prevplrpos then
                                prevplrpos = magnited
                            end
                        end
                    end
                end
        	end
        end)
    end)
end)
ff3:Toggle("Camera at Opponent", function(isToggled)
    
    getgenv().atp = isToggled
    
    task.spawn(function()
        local camera_status = game:GetService("RunService").RenderStepped:Connect(function ()
            if getgenv().atp then
                for _, i in pairs(game.Players:GetPlayers()) do
                    
                    if i.Name ~= plr.Name and i.Character and plr.Character and plr.Character:FindFirstChild("LowerTorso") and i.Character:FindFirstChild("HeadHB") and plr.Status.Team.Value ~= i.Status.Team.Value and i.Status.Team.Value ~= "Spectator" then
                        
                        camera.CameraType = Enum.CameraType.Scriptable
                        if getgenv().predict then
                            camera.CFrame = CFrame.lookAt(i.Character.HumanoidRootPart.Position + i.Character.HumanoidRootPart.Velocity * predict_power, i.Character.HeadHB.Position)
                        else
                            camera.CFrame = CFrame.lookAt(i.Character.HumanoidRootPart.Position, i.Character.HeadHB.Position)
                        end
                        object_to_off = i

                    end

                end
            end
        end)
        if not getgenv().atp then
            camera_status:Disconnect()
            camera.CameraType = Enum.CameraType.Custom
        end
    end)

end)
ff3:Toggle("Prediction", function(isToggled)
    
    getgenv().predict = isToggled

end)
ff3:Slider("Prediction Power", 1, 35, function(currentValue)
    predict_power = currentValue / 100
end)

ff:Button("No Spread", function()
    for _, i in pairs(game:GetService("ReplicatedStorage").Weapons:GetDescendants()) do
        
        if i.Name == "Spread" or i.Name == "Crouch" and i.Name == "Fire" or i.Name == "InitialJump" or i.Name == "Jump" or i.Name == "Ladder" or i.Name == "Land" or i.Name == "Move" or i.Name == "Recoil" or i.Name == "RecoveryTime" or i.Name == "Stand" then
            i.Value = 0
        end
        
    end
end)
ff:Button("No Fire Rate", function()
    for _, i in pairs(game:GetService("ReplicatedStorage").Weapons:GetDescendants()) do
        
        if i.Name == "FireRate" then
            i.Value = 0
        end
        
    end
end)
ff2:Button("Infinite Ammo", function()
    for _, i in pairs(game:GetService("ReplicatedStorage").Weapons:GetDescendants()) do
        
        if i.Name == "Ammo" or i.Name == "StoredAmmo" then
            i.Value = 10000000
        end
        
    end
end)
ff2:Button("Wall bang", function()
    for _, i in pairs(game:GetService("ReplicatedStorage").Weapons:GetDescendants()) do
        
        if i.Name == "Penetration" or i.Name == "ArmorPenetration" then
            i.Value = 10000000
        end
        
    end
end)
ff2:Button("Instant Reload", function()
    for _, i in pairs(game:GetService("ReplicatedStorage").Weapons:GetDescendants()) do
        
        if i.Name == "ReloadTime" then
            i.Value = 0.01
        end
        
    end
end)
local size = 1
scale:Slider("Head Scale", 1, 20, function(currentValue)
    for _, i in pairs(game.Players:GetPlayers()) do
        if i.Name ~= plr.Name and i.Character ~= nil and i.Character:FindFirstChild("HeadHB") then
            print(currentValue)
            size = currentValue
            i.Character.HeadHB.Size = Vector3.new(currentValue, currentValue, currentValue)
            i.Character.HeadHB.OriginalSize.Value = Vector3.new(currentValue, currentValue, currentValue)
            i.Character.Hat2.Handle.Size = Vector3.new(currentValue, currentValue, currentValue)
        end
    end
end)
local clr1, clr2, clr3 = 255, 255, 255
local clr12, clr22, clr32 = 255, 255, 255
local transpa_chams = 0.6
chams:Slider("Color Red", 1, 255, function(currentValue)
    clr = currentValue
end)
chams:Slider("Color Green", 1, 255, function(currentValue)
    clr2 = currentValue
end)
chams:Slider("Color Blue", 1, 255, function(currentValue)
    clr3 = currentValue
end)
chams:Slider("Transparency", 1, 100, function(currentValue)
    transpa_chams = currentValue / 100
end)
chams:Toggle("Chams", function(isToggled)
    print(isToggled)
    getgenv().esp = isToggled
    for _, i in pairs(game.Players:GetPlayers()) do
        if i.Name ~= plr.Name and i.Character ~= nil and i.Character:FindFirstChild("UpperTorso") and getgenv().esp and i.Status.Team.Value ~= plr.Status.Team.Value then
            print(1)
            local Instanc = Instance.new("Highlight", i.Character)
            Instanc.Name = "BOXESP"
            Instanc.FillColor = Color3.fromRGB(clr, clr2, clr3)
            Instanc.FillTransparency = transpa_chams
            print(2)
        elseif not getgenv().esp and i.Character and i.Character:FindFirstChild("BOXESP") then
            i.Character.BOXESP:Destroy()
        end
    end
    local descendants_hooking = game.DescendantAdded:Connect(function(i)
        if getgenv().esp and i:IsA("Model") and game.Players:FindFirstChild(i.Name) and game.Players:FindFirstChild(i.Name) and game.Players:FindFirstChild(i.Name).Status.Team.Value ~= plr.Status.Team.Value then
            print(1)
            local Instanc = Instance.new("Highlight", i)
            Instanc.Name = "BOXESP"
            Instanc.FillColor = Color3.fromRGB(clr, clr2, clr3)
            Instanc.FillTransparency = transpa_chams
            print(2)
        end
    end)
    if not getgenv().esp then
        descendants_hooking:Disconnect()
    end

end)
chams:Button("Apply Changes", function()
    for _, i in pairs(game.Workspace:GetDescendants()) do
        if i.Name == "BOXESP" and i:IsA("Highlight") then
            i.FillColor = Color3.fromRGB(clr, clr2, clr3)
            i.FillTransparency = transpa_chams
        end
    end
end)
local dist = 45
player:Slider("Max Distance", 16, 100, function(currentValue)
    dist = currentValue
end)
player:Toggle("Third Person", function(isToggled)
    getgenv().third = isToggled
    local third_status = game:GetService("RunService").RenderStepped:Connect(function()
        if getgenv().third then
            plr.CameraMaxZoomDistance = dist
        else
            plr.CameraMaxZoomDistance = 0
        end
    end)
    if not getgenv().third then
        third_status:Disconnect()
    end
    
end)
local view = 70
player:Slider("Field of View (FOV)", 40, 180, function(currentValue)
    view = currentValue
end)
player:Toggle("FOV Enabled", function(isToggled)
    getgenv().fov = isToggled
    task.spawn(function()
        local status = game:GetService("RunService").RenderStepped:Connect(function()
            if getgenv().fov then
                camera.FieldOfView = view
            end
        end)

        if not getgenv().fov then
            
            status:Disconnect()
        end
    end)
end)
local transpa_arms = 0.6
model_changer:Slider("Color Red", 1, 255, function(currentValue)
    clr12 = currentValue
end)
model_changer:Slider("Color Green", 1, 255, function(currentValue)
    clr22 = currentValue
end)
model_changer:Slider("Color Blue", 1, 255, function(currentValue)
    clr32 = currentValue
end)
model_changer:Slider("Transparency", 1, 100, function(currentValue)
    transpa_arms = currentValue / 100
end)
model_changer:Button("Apply Arms's Colors", function()
    
    task.spawn(function()
        for _, i in pairs(game:GetService("ReplicatedStorage").Viewmodels:GetDescendants()) do
    
            if i:IsA("Part") then
                i.Color = Color3.fromRGB(clr12, clr22, clr32)
                i.FillTransparency = transpa_arms
            end
            
        end
    
    end)
end)
model_changer:Toggle("Arms ESP", function(isToggled)
    getgenv().armSP = isToggled
    task.spawn(function()
        while task.wait() and getgenv().armSP do
            if workspace.Camera:FindFirstChild("Arms") and not workspace.Camera.Arms:FindFirstChild("Arms_ESP") then
                local armESP = Instance.new("Highlight", workspace.Camera:FindFirstChild("Arms"))
                armESP.Name = "Arms_ESP"
                armESP.FillColor = Color3.fromRGB(clr12, clr22, clr32)
                armESP.FillTransparency = transpa_arms
            end
        end
    end)
end)
scale:Button("Apply", function()
    for _, i in pairs(game.Players:GetPlayers()) do
        if i.Name ~= plr.Name and i.Character ~= nil and i.Character:FindFirstChild("HeadHB") and i.Character:FindFirstChild("Hat2") then
            print("Applied")
            i.Character.HeadHB.Size = Vector3.new(size, size, size)
            i.Character.HeadHB.OriginalSize.Value = Vector3.new(size, size, size)
            i.Character.Hat2.Handle.Size = Vector3.new(size, size, size)
        end
    end
    game.DescendantAdded:Connect(function(i)
        if i.Name == "HeadHB" then
            task.wait()
            i.Size = Vector3.new(size, size, size)
        end
    end)
end)
local oldbright = game.Lighting.Brightness
local newbright = game.Lighting.Brightness
world:Slider("Modulation", 0, 50, function(currentValue)
    newbright = currentValue
end)

world:Toggle("Modulation", function(isToggled)
    getgenv().modul = isToggled
    task.spawn(function()
        while task.wait() and getgenv().modul do
            if game.Lighting and getgenv().modul then
                game.Lighting.Brightness = newbright
            end
        end
        if game.Lighting and not getgenv().modul then
            game.Lighting.Brightness = oldbright
        end
    end)
end)
local fog_modulation = game:GetService("Lighting").FogEnd
world:Slider("Fog Modulation", 0, 90, function(currentValue)
    if currentValue > 80 then
        fog_modulation = 1000
    else
        fog_modulation = currentValue
    end
end)
world:Toggle("Fog", function(isToggled)
    getgenv().fogmod = isToggled
    task.spawn(function()
        while getgenv().fogmod and task.wait(0.001) do
            game:GetService("Lighting").FogEnd = fog_modulation
        end
    end)
end)
local lifetime, length = 1, 1000
trace:Slider("Bullet Tracers Lifetime", 0, 10, function(currentValue)
    lifetime = currentValue
end)
trace:Slider("Max Length", 0, 1000, function(currentValue)
    length = currentValue
end)
trace:Button("Bullet Tracers Apply", function()
    game:GetService("ReplicatedStorage").VisualizeModule.Trail.Lifetime = lifetime
    game:GetService("ReplicatedStorage").VisualizeModule.Trail.MaxLength = length
end)
local size = 0.25
local imp_clr1, imp_clr2, imp_clr3 = Color3.fromRGB(), Color3.fromRGB(), Color3.fromRGB()

impacts_sect:Slider("Color Red", 0, 255, function(currentValue)
    imp_clr1 = currentValue
end)
impacts_sect:Slider("Color Green", 0, 255, function(currentValue)
    imp_clr2 = currentValue
end)
impacts_sect:Slider("Color Blue", 0, 255, function(currentValue)
    imp_clr3 = currentValue
end)
impacts_sect:Slider("Size", 0, 50, function(currentValue)
    size = currentValue / 100
end)
impacts_sect:Toggle("Impacts", function(isToggled)
    getgenv().impact = isToggled
    local main_func = game.Workspace.Camera.Debris.DescendantAdded:Connect(function(obj)
        if obj.Name == "Wood" or obj.Name == "Metal" or obj.Name == "Concrete" or obj.Name == "Dirt" then
            if getgenv().impact then
                local impact_self = Instance.new("Part", obj)
                impact_self.Size = Vector3.new(size, size, size)
                impact_self.Name = "ClientImpact"
                impact_self.Anchored = true
                impact_self.Position = obj.Position
                impact_self.Color = Color3.fromRGB(imp_clr1, imp_clr2, imp_clr3)
                impact_self.Material = "SmoothPlastic"

                task.wait()

                local visualizer = Instance.new("Highlight", impact_self)

                visualizer.Name = "ImpactVisualize"

                visualizer.FillColor = Color3.fromRGB(imp_clr1, imp_clr2, imp_clr3)
            end
        end
    
    end)
    game:GetService("RunService").RenderStepped:Connect(function ()
        if main_func.Connected and getgenv().impact then
            return nil
        elseif not main_func.Connected and getgenv().impact then
            main_func = game.Workspace.Camera.Debris.DescendantAdded:Connect(function(obj)
                if obj.Name == "Wood" or obj.Name == "Metal" or obj.Name == "Concrete" or obj.Name == "Dirt" then
                    if getgenv().impact then
                        local impact_self = Instance.new("Part", obj)
                        impact_self.Size = Vector3.new(size, size, size)
                        impact_self.Name = "ClientImpact"
                        impact_self.Anchored = true
                        impact_self.Position = obj.Position
                        impact_self.Color = Color3.fromRGB(imp_clr1, imp_clr2, imp_clr3)
                        impact_self.Material = "SmoothPlastic"

                        task.wait()

                        local visualizer = Instance.new("Highlight", impact_self)

                        visualizer.Name = "ImpactVisualize"

                        visualizer.FillColor = Color3.fromRGB(imp_clr1, imp_clr2, imp_clr3)
                    end
                end
            end)
        end
    end)
end)


local inp = game:GetService("UserInputService")
move:Toggle("Bunny Hop", function(isToggled)
    print(isToggled)
    getgenv().bhop = isToggled
    local bhopping_status = game:GetService("RunService").RenderStepped:Connect(function()
        if getgenv().bhop and inp:IsKeyDown(Enum.KeyCode.Space) and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid:GetState() == Enum.HumanoidStateType.Running then
            
            plr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            
        end
    end)
    if not getgenv().bhop then
        bhopping_status:Disconnect()
    end
end)
local sped = 1
move:Toggle("Auto Strafer", function(isToggled)
    print(isToggled)
    getgenv().strafer = isToggled
    local strafer_self = game:GetService("RunService").RenderStepped:Connect(function()
    
        if getgenv().strafer and plr.Character and inp:IsKeyDown(Enum.KeyCode.Space) and getgenv().strafer and inp:IsKeyDown(Enum.KeyCode.W) and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + plr.Character.HumanoidRootPart.CFrame.LookVector * 0.001 * sped
            task.wait(0.8)
        elseif getgenv().strafer and plr.Character and inp:IsKeyDown(Enum.KeyCode.Space) and getgenv().strafer and inp:IsKeyDown(Enum.KeyCode.D) and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + plr.Character.HumanoidRootPart.CFrame.RightVector * 0.001 * sped  
            task.wait(0.8)
        elseif getgenv().strafer and plr.Character and inp:IsKeyDown(Enum.KeyCode.Space) and getgenv().strafer and inp:IsKeyDown(Enum.KeyCode.A) and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + -plr.Character.HumanoidRootPart.CFrame.RightVector * 0.001 * sped
            task.wait(0.8)
        elseif getgenv().strafer and plr.Character and inp:IsKeyDown(Enum.KeyCode.Space) and getgenv().strafer and inp:IsKeyDown(Enum.KeyCode.S) and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + -plr.Character.HumanoidRootPart.CFrame.LookVector * 0.001 * sped
            task.wait(0.8)
        end
        
        if getgenv().strafer and plr.Character and inp:IsKeyDown("Space") and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.Velocity = Vector3.new(0, plr.Character.HumanoidRootPart.Velocity.Y, 0)
        end
    
    end)
    if not getgenv().strafer then
        strafer_self:Disconnect()
    end
end)
move:Slider("Strafe Speed", 1, 650, function(currentValue)
    sped = currentValue
end)
aa2:Toggle("Void Sync", function(isToggled)
    getgenv().voidsync = isToggled
    task.spawn(function()
        while task.wait() and getgenv().voidsync do

            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                
                plr.Character.HumanoidRootPart.CFrame = CFrame.new(math.random(124303030, 194303030), math.random(124303030, 194303030), math.random(124303030, 194303030))
                print("Teleported")
            end

        end
    end)
end)


aa1:Toggle("Fakelag Desync", function(isToggled)
    getgenv().flag = isToggled
	game:GetService("RunService").PostSimulation:Connect(function()
        if getgenv().flag and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.Anchored = true
            game:GetService("RunService").Heartbeat:Wait()
            plr.Character.HumanoidRootPart.Anchored = false
            game:GetService("RunService").RenderStepped:Wait()
        end
    end)
end)
local toggle1 = true
local delay = 0.05
aa2:Toggle("Head Jitter", function(isToggled)
    getgenv().jitter = isToggled
    task.spawn(function()
        while task.wait() and getgenv().jitter do
            for i = 1, 2 do
                toggle1 = false
                if i == 1 and getgenv().jitter then
                    local args = {
                        -0.24901966750621796,
                        true
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("ControlTurn"):FireServer(unpack(args))
        
                else
                    local args = {
                        -0.916449910402298,
                        false
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("ControlTurn"):FireServer(unpack(args))
                end
                task.wait(delay / 100)
                toggle1 = true
            end
        end
    end)     
    
    local talbe = getrawmetatable(game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("ControlTurn"))
    
    local old = talbe.__namecall
    setreadonly(talbe, false)
    
    if getgenv().jitter then
        talbe.__namecall = function(self, ...)
            
            if getnamecallmethod() == "FireServer" and not checkcaller() and toggle1 and getgenv().jitter then
                return nil
            end
            return old(self, ...)
        end
    elseif not getgenv().jitter then
        talbe.__namecall = old
    end

end)
aa2:Slider("Delay", 1, 20, function(currentValue)
    delay = currentValue
end)
info:Label("Version: 3.15")
info:Label("Developed by steel_the_developer (discord)")
info:Label("Discord Forum : https://discord.gg/E5Tt4yYYMr")
info:Button("Copy", function()
    setclipboard("https://discord.gg/E5Tt4yYYMr")
end)
info:Label("gamescript: rage version")
