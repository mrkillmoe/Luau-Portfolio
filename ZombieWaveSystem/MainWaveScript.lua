local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

local WaveUIEvent = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("WaveUIEvent")
local IntermissionEndedEvent = ReplicatedStorage:WaitForChild("Bindables"):WaitForChild("IntermissionEndedEvent")

local ZombieTemplate = ReplicatedStorage:WaitForChild("Mobs"):WaitForChild("Zombie")
local SpawnFolder = game.Workspace:WaitForChild("SpawnFolder")

local Spawn_Rate = 2
local Max_Zombie = 10
local CurrentWave = 0
local IsSpawning = false
local GameStarted = false

local XP_Manager = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("XPManager"))

local zombies = {}

IntermissionEndedEvent.Event:Connect(function()
	GameStarted = true
end)

local function GetRandomCFrame(part)
	if not part or not part:IsA("BasePart") then return end
	
	local Size = part.Size
	local CF = part.CFrame

	local OffsetX = (math.random() - 0.5) * Size.X
	local OffSetY = 3
	local OffsetZ = (math.random() - 0.5) * Size.Z
	
	local Offset = Vector3.new(OffsetX, OffSetY, OffsetZ)
	
	local RandomWorldPosition = (CF * CFrame.new(Offset)).Position
	
	return CFrame.new(RandomWorldPosition)
end

local function GetRandomSpawn()
	local CurrentTaggedMap = CollectionService:GetTagged("CurrentMap")
	local CurrentMap = CurrentTaggedMap[1]
	local SpawnPoints = CurrentMap:FindFirstChild("MobSpawnFolder"):GetChildren()
	if SpawnPoints then
	local RandomArea = SpawnPoints[math.random(1, #SpawnPoints)]
	return GetRandomCFrame(RandomArea)
	end
end

local function ZombieSpawn()
	local SpawnPoint = GetRandomSpawn()
	local NewZombie = ZombieTemplate:Clone()

	NewZombie:PivotTo(SpawnPoint)
	NewZombie.Parent = game.Workspace:FindFirstChild("AliveMobs")

	table.insert(zombies, NewZombie)

	NewZombie.Humanoid.Died:Connect(function()
		local tag = NewZombie.Humanoid:FindFirstChild("Creator")
		if tag and tag.Value and tag.Value:IsA("Player") then
			XP_Manager.AwardXP(tag.Value, 10)
		end

		table.remove(zombies, table.find(zombies, NewZombie))
		NewZombie:Destroy()
	end)
end

local function StartWave()
	IsSpawning = true
	CurrentWave += 1

	if CurrentWave % 5 == 0 then
	end

	local ZombiesToSpawn = 5 + CurrentWave * 2
	for i = 1, ZombiesToSpawn do
		ZombieSpawn()
		task.wait(.01)
	end

	IsSpawning = false
end

while true do
	if not IsSpawning and #zombies == 0 and GameStarted then
		StartWave()
		WaveUIEvent:FireAllClients(CurrentWave)
		print("Wave Started")
	end
	task.wait(1)
end
