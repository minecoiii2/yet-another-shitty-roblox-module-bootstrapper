-- Yet Another Sh*tty Roblox Module Bootstrapper
-- https://github.com/minecoiii2/yet-another-shitty-roblox-module-bootstrapper

local DEBUG = false

function printDebug(header: Instance, ...: string)
	if not DEBUG then return end
	print(`[{header.Name}]: `, ...)
end

-- module class
local module = {}

function module:Boot(directory: Instance, order: {}?)
	local array = {}
	
	for i, name in ipairs(order or {}) do
		local script = directory:FindFirstChild(name)
		assert(script, 'Not found')
		table.insert(array, script)
	end
	
	for i, instance in directory:GetChildren() do
		if not instance:IsA('ModuleScript') then continue end
		if table.find(array, instance) then continue end
		table.insert(array, instance)
	end
	
	--
	local modules = {}
	
	printDebug(directory, '[LOADING]')
	
	for i, script in ipairs(array) do
		printDebug(script, '[LOADING]', 'Require')
		table.insert(modules, {
			required = require(script), 
			instance = script
		})
		printDebug(script, '[COMPLETE]', 'Require')
	end
	
	for i, v in ipairs(modules) do
		local required, instance = v.required, v.instance
		local init = required.Init
		if init then
			printDebug(instance, '[LOADING]', 'Init')
			init(required)
			printDebug(instance, '[COMPLETE]', 'Init')
		end
	end
	
	for i, v in ipairs(modules) do
		local required, instance = v.required, v.instance
		local start = required.Start
		if start then
			printDebug(instance, '[LOADING]', 'Start')
			start(required)
			printDebug(instance, '[COMPLETE]', 'Start')
		end
	end
	
	printDebug(directory, '[COMPLETE]')
end

return module	