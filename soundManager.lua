--[[

soundManager.lua
January 10th, 2013

]]
local love = love

module (...)

local sounds = {}

function Load(name, path, st)
	if sounds[name] then 
		return sounds[name]
	end
	
	sounds[name] = love.audio.newSource( path, st )
	return sounds[name] 
end