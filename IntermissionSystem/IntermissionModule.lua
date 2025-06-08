local IntermissionModule = {}
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CountDownEvent = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("CountDownEvent")
local IntermissionEndedEvent = ReplicatedStorage:WaitForChild("Bindables"):WaitForChild("IntermissionEndedEvent")

local MapFolder = ReplicatedStorage:WaitForChild("MapFolder")

local CountdownTime = 5
local MinimumPlayers = 1
local isCountingdown = false
local NewMap = nil

local PlayersInGame = {}

function IntermissionModule.AddPlayer(player)
	table.insert(PlayersInGame, player)
	print(PlayersInGame)
	IntermissionModule.TryStartCountdown()
end

function IntermissionModule.RemovePlayer(player)
	local Index = table.find(PlayersInGame, player)
	if Index then
		table.remove(PlayersInGame, Index)
	end
end

function IntermissionModule.TryStartCountdown()
	if not isCountingdown and #PlayersInGame >= MinimumPlayers then
		coroutine.wrap(IntermissionModule.StartCooldown)()
	end 
end

function IntermissionModule.StartCooldown()
	isCountingdown = true
	print(isCountingdown)

	for i = CountdownTime, 1, -1 do
		CountDownEvent:FireAllClients(i)
		task.wait(1)		
	end
	IntermissionModule.TeleportPlayers()
end

function IntermissionModule.TeleportPlayers()
	NewMap = IntermissionModule.MapDetector()

	for _, v in ipairs(PlayersInGame) do
		if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
			local HumanoidRootPart = v.Character:FindFirstChild("HumanoidRootPart")
			local Spawns = NewMap:FindFirstChild("PlayerSpawns"):GetChildren()
			local ChosenSpawn = Spawns[math.random(1, #Spawns)]
			HumanoidRootPart:PivotTo(ChosenSpawn.CFrame + Vector3.new(0, 5, 0))
		end
	end

	isCountingdown = false
	IntermissionEndedEvent:Fire()
end

function IntermissionModule.MapDetector()
	if NewMap then
		CollectionService:RemoveTag(NewMap, "CurrentMap")
		NewMap:Destroy()
	end
	
	local Maps = MapFolder:GetChildren()
	local ChosenMap = Maps[math.random(1, #Maps)]
	local NewMap = ChosenMap:Clone()
	NewMap.Name = ChosenMap.Name
	NewMap.Parent = game.Workspace
	NewMap:WaitForChild("Floor").Anchored = true
	CollectionService:AddTag(NewMap, "CurrentMap")
	
	return NewMap
end

return IntermissionModule
