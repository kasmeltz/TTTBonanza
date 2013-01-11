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
			},
			['150'] = {
				text = '$150? That\'s not even enough to buy a nice meal at the Keg.',
				sound = soundManager.Load('opponentssvdollar150', 'sounds/opponents/sv/dollar150.wav')
			},
			['200'] = {
				text = '$200? I\'m really shaking in my boots now.',
				sound = soundManager.Load('opponentssvdollar200', 'sounds/opponents/sv/dollar200.wav')
			},
			['250'] = {
				text = 'I can program a 3D starfield in QuickBasic. And all you can do is $250?',
				sound = soundManager.Load('opponentssvdollar250', 'sounds/opponents/sv/dollar250.wav')
			},
			['300'] = {
				text = '$300. Woop dee doo! You must be very, very proud of yourself.',
				sound = soundManager.Load('opponentssvdollar300', 'sounds/opponents/sv/dollar300.wav')
			},
			['350'] = {
				text = 'Wow $350. My two year old son just got the same score!',
				sound = soundManager.Load('opponentssvdollar350', 'sounds/opponents/sv/dollar350.wav')
			},
			['400'] = {
				text = 'Congratulations! You have achieved $400. Now you no longer horrible, just really really bad!',
				sound = soundManager.Load('opponentssvdollar400', 'sounds/opponents/sv/dollar400.wav')
			}							
		}		
	}
}