local imageManager = require 'imageManager'
local fontManager = require 'fontManager'
local soundManager = require 'soundManager'

local opponents = require 'opponents'

local tttboard = require 'tictactoeboard'
local tttgame = require 'tictactoegame'
local tttcomponent = require 'tictactoecomponent'

local sceneManager = require 'gameSceneManager'

local gameScene = require 'gameScene'

local money = 0
local speedComponentCount = 15
local selectedOpponent = nil

local defaultFont = love.graphics.newFont(14)

local function centerPrint(text, y)
	local w = love.graphics.getFont():getWidth(text)
	local x = (love.graphics.getWidth() / 2) - (w / 2)
	
	love.graphics.print(text, x, y)
end

local function createTitleScreen()
	local gs = gameScene:new()
	local titleFont = fontManager.Load('Cooper Black', 'COOPBL.ttf', 64)
	local smallFont = fontManager.Load('Cooper Black', 'COOPBL.ttf', 32)
	
	local fanfare = soundManager.Load('titlefanfare', 'sounds/opening.mp3', 'static')
	
	local showEnter = false
	
	gs:addComponent{
		draw = function()	
			love.graphics.setFont(titleFont)
			love.graphics.setColor(80,100,230,255)
			centerPrint('Tic Tac Toe', 170)
			centerPrint('Bonanza', 240)
			
			if showEnter then
				love.graphics.setFont(smallFont)
				love.graphics.setColor(230,100,80,255)
				centerPrint('Press Enter To Begin', 350)
			end
		end,
		update = function(dt)
			if fanfare:isStopped() then
				showEnter = true
			end
			if showEnter then
				if love.keyboard.isDown('return') then				
					sceneManager.switch('pickOpponent')
				end
			end
		end
	}
	
	function gs:begin()
		showEnter = false
		fanfare:rewind()
		fanfare:play()
	end
	
	sceneManager.removeScene('title')
	sceneManager.addScene('title', gs)
end

local function createOpponentScene()	
	local gs = gameScene:new()
	
	local bigFont = fontManager.Load('Cooper Black', 'COOPBL.ttf', 60)
	local regularFont = fontManager.Load('Cooper Black', 'COOPBL.ttf', 24)
	
	gs:addComponent {
		draw = function() 				
			love.graphics.setFont(bigFont)
			love.graphics.setColor(0,255,255,255)
			centerPrint('Pick Your Opponent', 50)
		end
	}				
	
	local sx = 100
	local sy = 200
	local counter = 1
	for k, op in ipairs(opponents.availableOpponents) do
		local dx, dy = sx, sy
		local lbdown = false
		local highlight = false
		
		gs:addComponent {
			draw = function() 				
				love.graphics.setFont(regularFont)
				love.graphics.setColor(255,255,255,255)
				love.graphics.draw(op.image, dx, dy)
				love.graphics.print(op.name, dx, dy + op.image:getHeight())	
				if highlight then			
					love.graphics.setColor(255,0,255,255)				
					love.graphics.setLineWidth(4)
					love.graphics.rectangle('line', dx, dy, 
						op.image:getWidth(), op.image:getHeight() )
				end
			end, 
			update = function()
				highlight = false
				
				local mx, my = love.mouse:getPosition()
				if mx >= dx and my >= dy and
					mx <= dx + op.image:getWidth() and
					my <= dy + op.image:getHeight() then					
						highlight = true
				end
				
				if love.mouse.isDown('l') then 
					lbdown = true 
				else
					if lbdown and highlight then						
						selectedOpponent = op
						sceneManager.switch('opponentSelected')
					end
					
					lbdown = false
				end
			end
		}				
		sx = sx + 300
	end
		
	sceneManager.removeScene('pickOpponent')
	sceneManager.addScene('pickOpponent', gs)
end	

local function createOppnonentSelectedScene()
	local gs = gameScene:new()
	
	local bigFont = fontManager.Load('Cooper Black', 'COOPBL.ttf', 60)
	local regularFont = fontManager.Load('Cooper Black', 'COOPBL.ttf', 24)	
	
	gs:addComponent {
		draw = function()		
			local op = selectedOpponent		
			local cx = love.graphics.getWidth() / 2 - op.image:getWidth() / 2
			local cy = love.graphics.getHeight() / 2 - op.image:getHeight() / 2
			
			love.graphics.setFont(bigFont)	
			love.graphics.setColor(0,255,255,255)
			centerPrint('You Have Selected', 50)	
			
			love.graphics.setFont(regularFont)
			love.graphics.setColor(255,255,255,255)
			love.graphics.draw(op.image, cx, cy)
			centerPrint(op.name, cy + op.image:getHeight())	
		end, 
		update = function()
			local op = selectedOpponent	
			if op.pickSound:isStopped() then
				sceneManager.switch('speedCountdown', 0.5)
			end
		end
	}
	
	function gs:begin()
		local op = selectedOpponent
		op.pickSound:rewind()
		op.pickSound:play()				
	end

	sceneManager.removeScene('opponentSelected')
	sceneManager.addScene('opponentSelected', gs)

end

local function createCountDownScene()
	local gs = gameScene:new()
	
	local currentCounter = 5
	local regularFont = fontManager.Load('Cooper Black', 'COOPBL.ttf', 32)
	local bigFont = fontManager.Load('Cooper Black', 'COOPBL.ttf', 48)
	local countFont = fontManager.Load('Cooper Black', 'COOPBL.ttf', 128)
	
	local taunt
	
	gs:addComponent{
		draw = function(self)	
			love.graphics.setFont(bigFont)
			love.graphics.setColor(255,0,255,255)
			centerPrint('Prepare for speed round!', 40)

			love.graphics.setFont(regularFont)
			love.graphics.setColor(255,255,255,255)
			centerPrint(taunt.text, 350)
		
			love.graphics.setFont(countFont)
			love.graphics.setColor(0,255,0,255)
			centerPrint(tostring(math.ceil(currentCounter)), 200)
		end,
		update = function(self, dt)
			currentCounter = currentCounter - dt
			if currentCounter <= 0 then
				currentCounter = 0
				sceneManager.switch('speed')
			end		
		end
	}
	
	function gs:begin()
		currentCounter = 5
		local op = selectedOpponent
		local tauntNumber = math.random(1, #op.countDownTaunts)
		taunt = op.countDownTaunts[tauntNumber]
		taunt.sound:rewind()
		taunt.sound:play()
	end
	
	sceneManager.removeScene('speedCountdown')
	sceneManager.addScene('speedCountdown', gs)
end

local function createNewTicTacToeComponent()
	local winSound = soundManager.Load('win', 'sounds/win.wav', 'static')
	local drawSound = soundManager.Load('draw', 'sounds/draw.wav', 'static')
	local loseSound = soundManager.Load('lose', 'sounds/lose.mp3', 'static')
		
	local hn = math.random(0,1)
	local t = tttcomponent:new(tttgame:new(tttboard:new()),
		'You', hn, 5)
	t.gameOver = function(game)
		if game.winner == hn then
			winSound:rewind()
			winSound:play()			
			money = money + 100
		elseif game.isDraw then
			drawSound:rewind()
			drawSound:play()
			money = money + 50
		else
			loseSound:rewind()
			loseSound:play()	
		end		
	end
	
	return t            
end

local function createSpeedRound()	
	local gs = gameScene:new()

	local sx, sy = 50, 50
	for i = 1, speedComponentCount do
		local sc = createNewTicTacToeComponent()
		sc:setDrawArea(sx, sy, 100, 100)
		gs:addComponent(sc)
		sx = sx + 150
		if sx > 650 then
			sx = 50
			sy = sy + 150
		end
	end

	gs:addComponent{
		update = function()
			local allDone = true			
			for _, v in pairs(gs.components) do
				if v.game then
					if not v.game.isGameOver then
						allDone = false
						break
					end
				end					
			end		
			if allDone then
				sceneManager.switch('speedRecap', 2)
			end		
		end
	}
	
	function gs:begin()
		for _, v in pairs(gs.components) do
			if v.game then v.game:reset() end
		end
	end
	
	sceneManager.removeScene('speed')
	sceneManager.addScene('speed', gs)
end

local function createSpeedRecapScene()
	local gs = gameScene:new()
	
	local countFont = fontManager.Load('Cooper Black', 'COOPBL.ttf', 32)
	
	gs:addComponent{
		draw = function()
			love.graphics.setFont(countFont)
			love.graphics.setColor(255,255,255,255)
			centerPrint('Thous hast earned', 200)
			centerPrint('$' .. money, 240)
		end
	}	
	
	sceneManager.removeScene('speedRecap')
	sceneManager.addScene('speedRecap', gs)
end
	
function love.load()
	math.randomseed( os.time() )
	createTitleScreen()
	createOpponentScene()
	createOppnonentSelectedScene()
	createCountDownScene()
	createSpeedRound()
	createSpeedRecapScene()
	sceneManager.switch('title')
end
			
function love.draw()
	love.graphics.setFont(defaultFont)
	
	sceneManager.draw()
end

function love.update(dt)
	sceneManager.update(dt)
end