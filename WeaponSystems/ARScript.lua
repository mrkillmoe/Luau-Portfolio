--I made this just after i learned luau. Its quite messy but i thought it was important to show ive had plenty of work with raycasts.

local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AKEvent = ReplicatedStorage.Events:FindFirstChild("AKEvent")
local ShootEvent = ReplicatedStorage.Events:WaitForChild("ShootEvent")

--H&K USP COMPACT
local Tool = script.Parent
local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local Debounce = false

local AKAmmo = ReplicatedStorage.PistolAmmo
local AKMaxMag = 30
local Magazine = 30
local ReloadDuration = 2
local isShooting = false

local FireRate = 0.1

local NewAKAmmo

Tool.Equipped:Connect(function()
	Mouse.Icon = "http://www.roblox.com/asset/?id=13660551940"
	NewAKAmmo = AKAmmo:Clone()
	NewAKAmmo.Parent = Player.PlayerGui
	NewAKAmmo.Enabled = true
	NewAKAmmo.BulletCount.Text = (Magazine .. "/30")
end)

Tool.Unequipped:Connect(function()
	if NewAKAmmo then
		NewAKAmmo.Enabled = false
	end
end)

local function Shoot()
	while isShooting do
		if Debounce or Magazine <= 0 then
			return
		end
		Debounce = true
		print(Debounce)
		-- Decrease Magazine and update UI
		Magazine = Magazine - 1
		NewAKAmmo.BulletCount.Text = (Magazine .. "/30")		

		local WeaponType = "AK"
		print(ShootEvent)
		ShootEvent:FireServer(WeaponType)

		-- Perform the raycast for hitscan
		local RayOrigin = Tool.Handle.Position
		local RayDirection = (Mouse.Hit.Position - RayOrigin).unit * 100

		local RaycastParams = RaycastParams.new()
		RaycastParams.FilterDescendantsInstances = {Player.Character}
		RaycastParams.FilterType = Enum.RaycastFilterType.Exclude

		local RaycastResult = workspace:Raycast(RayOrigin, RayDirection, RaycastParams)
		if RaycastResult then
			AKEvent:FireServer(RaycastResult.Instance, RaycastResult.Position, RayDirection, Magazine)
		end
		if Magazine == 0 then
			isShooting = false
			wait(ReloadDuration)
			Magazine = AKMaxMag
			NewAKAmmo.BulletCount.Text = (Magazine .. "/30")
			
		end
		Debounce = false
	end
end

Mouse.Button1Down:Connect(function()
	isShooting = true
	print(isShooting)
	Shoot()
end)

Mouse.Button1Up:Connect(function()
	print(isShooting)
	isShooting = false
end)
