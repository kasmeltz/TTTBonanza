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
		pickSound = soundManager.Load('opponentssvpick', 'sounds/opponents/sv/pick.wav'),
		countDownTaunts = {
			{
				text = 'You in big, big trouble mister!',
				sound = soundManager.Load('opponentssvcdtaunt1', 'sounds/opponents/sv/cdtaunt1.wav')
			},
			{
				text = 'Ohhh you will be very, very sorry after this round!',
				sound = soundManager.Load('opponentssvcdtaunt2', 'sounds/opponents/sv/cdtaunt2.wav')
			}
		}
	}
}