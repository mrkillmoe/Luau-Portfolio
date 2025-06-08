local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AKEvent = ReplicatedStorage.Events:WaitForChild("AKEvent")
local HeadShotDMG = 25
local ShotDMG = 18


local function HandleHitscan(player, hitInstance, hitPosition, rayDirection, Magazine)
	print("Received hitscan from:", player.Name)

	if hitInstance then
		print("Hit object:", hitInstance.Name)
		-- Create a short beam effect
		local BeamPart = Instance.new("Part")
		BeamPart.Size = Vector3.new(0.2, 0.2, 1) -- Adjust the length of the beam here
		BeamPart.CFrame = CFrame.new(hitPosition, hitPosition + rayDirection) -- Point towards the direction of the hit
		BeamPart.Anchored = true
		BeamPart.CanCollide = false
		BeamPart.BrickColor = BrickColor.new("Bright yellow") -- Color of the beam
		BeamPart.Material = Enum.Material.Neon
		BeamPart.Parent = workspace

		game.Debris:AddItem(BeamPart, 0.03) -- Destroy the beam after 0.1 seconds


		-- Check if the hit instance has a Humanoid to apply damage
		local Humanoid = hitInstance.Parent:FindFirstChildOfClass("Humanoid")
		if Humanoid and hitInstance.Parent ~= player.Character then
			print("Applying damage to:", Humanoid.Parent.Name)
			if Humanoid.Parent.Name == " Head " then
				Humanoid:TakeDamage(HeadShotDMG)
				print(HeadShotDMG)
			else
				Humanoid:TakeDamage(ShotDMG) -- Adjust damage as needed
			end
		end
	end
end

AKEvent.OnServerEvent:Connect(HandleHitscan)
