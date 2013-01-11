--[[	

opponents.lua
January 10th, 2013

]]

local imageManager = require 'imageManager'
local soundManager = require 'soundManager'

module (...)

availableOpponents = 
{
	{ 
		name = 'Steve VonHooey',
		image = imageManager.Load('sv', 'images/opponents/sv.jpg'),
		pickSound = soundManager.Load('opponentssvpick', 'sounds/opponents/sv/pick.wav')
	}
}

countdownSayings = {}
countdownSayings['Steve VonHooey'] =
{
	'You in big, big trouble mista!',
	'Ohhh you will be so sorry after this!'

}