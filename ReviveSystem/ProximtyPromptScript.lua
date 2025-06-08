local RS = game:GetService("ReplicatedStorage")

local ProximityPromptEvent = RS:WaitForChild("RemoteEvents"):WaitForChild("ProximityPromptEvent")

local PromptTrigger = RS:WaitForChild("RemoteEvents"):WaitForChild("PromptTrigger")

local Prompt = RS:WaitForChild("ProximityPrompt")

local player = game.Players.LocalPlayer

ProximityPromptEvent.OnClientEvent:Connect(function(downedplayer, Adornee, HRPCF)
	if not Adornee then
		warn("Adornee is nil on client")
		return
	end
	local NewPrompt = Prompt:Clone()
	NewPrompt.Parent = Adornee
	NewPrompt.Enabled = true
	
	NewPrompt.Triggered:Connect(function()
		PromptTrigger:FireServer(downedplayer, HRPCF)
	end)
end)
