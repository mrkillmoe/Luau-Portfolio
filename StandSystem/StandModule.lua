local StandHandler = {}

local tween = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local RemoteEventsFolder = RS:WaitForChild("RemoteEvents")
local SummonEvent = RemoteEventsFolder:WaitForChild("Summon")

local CoolDown = 3

StandHandler.PlayersStands = {}
StandHandler.LastUsed = {}

function StandHandler.AddPlayer(player)
	StandHandler.PlayersStands[player.userId] = nil
	StandHandler.LastUsed[player.userId] = 0
	print(StandHandler.PlayersStands)
end 

function StandHandler:RemovePlayer()
	Players.PlayerRemoving:Connect(function(player)
		table.remove(StandHandler.PlayersStands, table.find(StandHandler.PlayersStands, player.UserId))
		table.remove(self.LastUsed, table.find(self.LastUsed, player.UserId))
	end)
end

function StandHandler:StandSummon(player)
	local char = player.Character
	local Stand = self.PlayersStands[player.UserId]
	if not Stand then return end
	
	local now = tick()
	local LastUsed = self.LastUsed[player.UserId] or 0
	
	if now - LastUsed < CoolDown then
		return 
	end		
		self.LastUsed[player.UserId] = now
	
	local StandIsSummoned = Stand.Parent == char
	local Tinfo = TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	local Playerrootpart = player.Character:FindFirstChild("HumanoidRootPart")
	local standrp = Stand:FindFirstChild("HumanoidRootPart")
	local SummonSound = standrp:FindFirstChild("SummonSound")
		if StandIsSummoned then
			
			--UNSUMMON
		local weld = Stand:FindFirstChild("Weld", true)
		SummonSound:Play()
		local weldtween = tween:Create(weld, Tinfo, {C1 = CFrame.new(0, 0, 0)})
		weldtween:Play()

		for i, v in pairs(Stand:GetDescendants()) do
			if v:IsA("Part") or v:IsA("Decal") or v:IsA("MeshPart") then 
				tween:Create(v, Tinfo, {Transparency = 1}):Play()
			end
		end

		weldtween.Completed:Connect(function()
			SummonSound.Ended:Wait()
			weld:Destroy()
			Stand.Parent = game.ServerStorage
		end)
		
		else
			
		--SUMMON
	standrp.CFrame = Playerrootpart.CFrame
		SummonSound:Play()
		for i, v in pairs(Stand:GetDescendants()) do
			if v:IsA("Part") or v:IsA("Decal") or v:IsA("MeshPart") then 
			v.Transparency = 1
				if v.Name ~= "HumanoidRootPart" then
				tween:Create(v, Tinfo, {Transparency = 0}):Play()
				end
			end	
		
		end
	local weld = Instance.new("Weld")
	weld.Name = "Weld"
	weld.Part0 = Playerrootpart
	weld.Part1 = standrp

	weld.Parent = standrp
	Stand.Parent = player.Character
	tween:Create(weld, Tinfo, {C1 = CFrame.new(2, -1, -3)}):Play()
	SummonSound.Ended:Wait()
	end
end

	return StandHandler
