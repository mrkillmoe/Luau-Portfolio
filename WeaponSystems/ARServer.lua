local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AKEvent = ReplicatedStorage.Events:WaitForChild("AKEvent")
local HeadShotDMG = 25
local ShotDMG = 18


local function HandleHitscan(player, hitInstance, hitPosition, rayDirection, Magazine)

	if hitInstance then
		local BeamPart = Instance.new("Part")
		BeamPart.Size = Vector3.new(0.2, 0.2, 1)
		BeamPart.CFrame = CFrame.new(hitPosition, hitPosition + rayDirection) 
		BeamPart.Anchored = true
		BeamPart.CanCollide = false
		BeamPart.BrickColor = BrickColor.new("Bright yellow")
		BeamPart.Material = Enum.Material.Neon
		BeamPart.Parent = workspace

		game.Debris:AddItem(BeamPart, 0.03) 

		local Humanoid = hitInstance.Parent:FindFirstChildOfClass("Humanoid")
		if Humanoid and hitInstance.Parent ~= player.Character then
			print("Applying damage to:", Humanoid.Parent.Name)
			if Humanoid.Parent.Name == " Head " then
				Humanoid:TakeDamage(HeadShotDMG)
				print(HeadShotDMG)
			else
				Humanoid:TakeDamage(ShotDMG) 
			end
		end
	end
end

AKEvent.OnServerEvent:Connect(HandleHitscan)
