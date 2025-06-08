local Players = game:GetService("Players")

local RS = game:GetService("ReplicatedStorage")
local RoomTemplate = RS:WaitForChild("Room")

LastRoom = game.Workspace:FindFirstChild("Room")
local MaxRooms = math.huge
local TotalRooms = 0

local AllRooms = {}

function LastRoomExit()
	local PreviousExit = LastRoom:FindFirstChild("ExitDoor")
	return PreviousExit.PrimaryPart.CFrame
end

function BoundingBoxCheck(NextRoom)
	local cf, size = NextRoom:GetBoundingBox()
	local FoundParts = {}
	
	local parts = workspace:GetPartBoundsInBox(cf, size)
	for i, part in pairs(parts) do
		if part.Name ~= "Baseplate" and not part:IsDescendantOf(NextRoom) and not part:IsDescendantOf(LastRoom) then
			table.insert(FoundParts, part)
		end
	end
	print(FoundParts)
	if #FoundParts == 0 then
		print("true")
		return true
	else 
		print("false")
		return false
	end
end

function spawnNextRoom()
local NextRoom = RoomTemplate:Clone()
NextRoom.Name = "Room" .. TotalRooms

local EntryDoor = NextRoom:FindFirstChild("EntryDoor")
local ExitDoor = NextRoom:FindFirstChild("ExitDoor")

local PreviousExitCF = LastRoomExit()
local Rotation = CFrame.Angles(0, math.rad(180), 0)
		
NextRoom:PivotTo(PreviousExitCF * CFrame.Angles(0, math.rad(180), 0))
		
local ExitWalls = {}

	for _, wall in ipairs(NextRoom:GetChildren()) do
		if wall:IsA("Part") then
			table.insert(ExitWalls, wall)
		end
	end

	local ChosenWall = ExitWalls[math.random(1, #ExitWalls)]


	local NewPrimary = NextRoom:FindFirstChild("ExitDoor").PrimaryPart
	NextRoom:FindFirstChild("ExitDoor"):SetPrimaryPartCFrame(ChosenWall.CFrame)
	
	print(ChosenWall)

	ChosenWall:Destroy()
	local BoundingBox = BoundingBoxCheck(NextRoom)
	if BoundingBox then

	LastRoom:FindFirstChild("ExitDoor"):Destroy()
	LastRoom = NextRoom
	table.insert(AllRooms, NextRoom)
	
		NextRoom.Parent = workspace
	else
		NextRoom:Destroy()
		task.wait()
		spawnNextRoom()
	end
end

while TotalRooms < MaxRooms do
	TotalRooms = TotalRooms +1
	spawnNextRoom()
	task.wait(1)
end
