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
			},
			{
				text = 'There is absolutely no way that you will beat me this round!',
				sound = soundManager.Load('opponentssvcdtaunt3', 'sounds/opponents/sv/cdtaunt3.wav')
			},
			{
				text = 'Prepare to be destroyed!',
				sound = soundManager.Load('opponentssvcdtaunt4', 'sounds/opponents/sv/cdtaunt4.wav')
			},
			{
				text = 'Now it\'s time to get serious!',
				sound = soundManager.Load('opponentssvcdtaunt5', 'sounds/opponents/sv/cdtaunt5.wav')
			}			
		},
		dollarTaunts = {
			['0'] = {
				text = 'You earned $0 this round. That\'s so funny!',
				sound = soundManager.Load('opponentssvdollar0', 'sounds/opponents/sv/dollar0.wav')
			},
			['50'] = {
				text = 'You only got $50. Hahaha you are absolutely horrible at this game.',
				sound = soundManager.Load('opponentssvdollar50', 'sounds/opponents/sv/dollar50.wav')
			},
			['100'] = {
				text = 'Wow a whole $100. You are so good at this game... not!',
				sound = soundManager.Load('opponentssvdollar100', 'sounds/opponents/sv/dollar100.wav')
			}
		}		
	}
}