local PlayerHandler = {}

local RS = game:GetService("ReplicatedStorage")

local ProximityPromptEvent = RS:WaitForChild("RemoteEvents"):WaitForChild("ProximityPromptEvent")

local PromptTrigger = RS:WaitForChild("RemoteEvents"):WaitForChild("PromptTrigger")

PlayerHandler.TransitGui = RS:WaitForChild("TransitGui")

local Players = game:GetService("Players")
Players.CharacterAutoLoads = false

local Time = 15

PlayerHandler.AlivePlayers = {}

PlayerHandler.InTransitPlayers = {}

PlayerHandler.DeadPlayers = {}

function PlayerHandler:OnPlayerAdded(player)
	Players.CharacterAutoLoads = false
	
	table.insert(self.AlivePlayers, player.UserId)
	
	player:LoadCharacter()
	
	local Char = player.Character
		local Humanoid = Char:WaitForChild("Humanoid")
		Humanoid.BreakJointsOnDeath = false
		
		Humanoid.Died:Connect(function()
			self:OnPlayerDied(player)
	end)
end

function PlayerHandler:Timer(player, TimeLeft, Gui)
	
	Gui.TextLabel.Text = "Revive "..player.Name.." in "..TimeLeft
	
		if TimeLeft <= 5 then
			Gui.TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
	
	end		
end

function PlayerHandler:ForeRevive(DownedPlayer, HRPCF)
	table.remove(self.InTransitPlayers, table.find(self.InTransitPlayers, DownedPlayer.UserId))

	task.wait(0.1)
	DownedPlayer:LoadCharacter()
	
	local newChar = DownedPlayer.Character
	
	newChar:WaitForChild("HumanoidRootPart").CFrame = HRPCF * CFrame.Angles(0, 0, 0)

	table.insert(self.AlivePlayers, DownedPlayer.UserId)
end

PromptTrigger.OnServerEvent:Connect(function(playerWhoTriggered, DownedPlayer, HRPCF)
	
	local player = game.Players:GetPlayerByUserId(DownedPlayer)
	if player then
		table.find(PlayerHandler.InTransitPlayers, DownedPlayer)
		
		PlayerHandler:ForeRevive(player, HRPCF)
	end
	
end)

function PlayerHandler:InTransit(player)
	local TimeBreak = false
	local Hum = player.Character:WaitForChild("Humanoid")
	local HRP = player.Character:WaitForChild("HumanoidRootPart")
	local HRPCF = HRP.CFrame
	
	task.wait(2)
	HRP.Anchored = true
	
	local NewTranitGui = self.TransitGui:Clone()
	NewTranitGui.Parent = HRP
	NewTranitGui.Adornee = HRP
	NewTranitGui.Enabled = true

	for i, v in pairs(self.AlivePlayers) do
		if v ~= player then
			local Targetplayer = game.Players:GetPlayerByUserId(v)
			if Targetplayer then
			ProximityPromptEvent:FireClient(Targetplayer, player.UserId, HRP, HRPCF)
			
			end
		end
	end
	
	
	for i = Time, 1, -1 do
		if TimeBreak then break end
		print(i)
		PlayerHandler:Timer(player, i, NewTranitGui)
		task.wait(1)
	end
	
	
	
	if TimeBreak then
		Hum.Health = 100
		NewTranitGui:Destroy()

		table.remove(self.InTransitPlayers, table.find(self.InTransitPlayers, player.UserId))
		table.remove(self.DeadPlayers, table.find(self.DeadPlayers, player.UserId))
		table.insert(self.AlivePlayers, player.UserId)

		task.wait(0.1)
		player:LoadCharacter()
		
		local newChar = player.Character
		newChar:WaitForChild("HumanoidRootPart").CFrame = HRPCF * CFrame.Angles(0, 0, 0)
		
	else
		
		Hum.Health = 0
		NewTranitGui:Destroy()
		table.remove(self.InTransitPlayers, table.find(self.InTransitPlayers, player.UserId))
		table.insert(self.DeadPlayers, player.UserId)
		
		player.Character:Destroy()
		
	end
end

function PlayerHandler:OnPlayerRemoving(player)			
			local ID = player.UserId
			
			table.remove(self.AlivePlayers, table.find(self.AlivePlayers, ID))
			table.remove(self.DeadPlayers, table.find(self.DeadPlayers, ID))
			table.remove(self.InTransitPlayers, table.find(self.InTransitPlayers, ID))
end

function PlayerHandler:OnPlayerDied(player)
		if table.find(self.AlivePlayers, player.UserId) then
			
			table.remove(self.AlivePlayers, table.find(self.AlivePlayers, player.UserId))
			table.insert(self.InTransitPlayers, player.UserId)
			
			PlayerHandler:InTransit(player)
			print("Transit fired")
	end
end

return PlayerHandler
