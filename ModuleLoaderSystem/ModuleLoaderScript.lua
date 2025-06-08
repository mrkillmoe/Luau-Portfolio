local SlapModuleLoader = {}

for i, module in pairs(script:GetChildren()) do
	if module:IsA("ModuleScript") then
		local succes, result = pcall(require, module)
		if succes then
			SlapModuleLoader[module.Name] = result
		else
			warn(module.Name.." Could not be loaded.", result)
		end
	end
end

print(SlapModuleLoader)

return SlapModuleLoader
