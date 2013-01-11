--[[

tictactoecomponent.lua
January 9th, 2013

]]
local love = love		

local setmetatable, math, type
	= setmetatable, math, type
	
local imageManager = require 'imageManager'
		
module(...)

--
--  Creates a new tic tac toe component
--
--  Inputs:
--		g - a tictactoegame
---		n - the name of the human player
--		hpn - the number of the human player
--			0 - x player
--			1 - o player
--		tpt - the number of seconds per turn allowed
--		before the turn is skipped
--
function _M:new(g, n, c, hpn, tpt)
	
	local o = { 
		game = g,
		humanPlayerNumber = hpn,
		playerNames = {},
		timePerTurn = tpt,
		currentTurnTime = 0,		
		gameover = nil,
		images = {}
	}	

	o.images.board = imageManager.Load('board', 'images/board.png')
	o.images[0] = imageManager.Load('x', 'images/x.png')
	o.images[1] = imageManager.Load('o', 'images/o.png')
	
	o.playerNames[o.humanPlayerNumber] = n
	o.playerNames[1 - o.humanPlayerNumber] = c
	
	o.positionScale = { 
		x = 0, 
		y = 0,
		sx = 1, 
		sy = 1,
		w = o.images.board:getWidth(),
		h = o.images.board:getHeight()
	}
		
	self.__index = self
	return setmetatable(o, self)	
end

--
--  Sets the position and size of the drawing area for the component
--
function _M:setDrawArea(x, y, w, h)
	self.positionScale.x = x
	self.positionScale.y = y
	self.positionScale.w = w
	self.positionScale.h = h	
	self.positionScale.sx = w / self.images.board:getWidth()
	self.positionScale.sy = h / self.images.board:getHeight()
end

--
--  Calls the gameover even if it has been defined
--
function _M:onGameOver()
	if self.gameOver and type(self.gameOver) == 'function' then
		self.gameOver(self.game)
	end
end

--
--  Returns true if a turn can currently be performed 
--	by the provided player number
--
function _M:canPerformTurn(pn)
	return true
end

--
--  Performs a turn
--
function _M:performTurn(x, y)
	if not self:canPerformTurn(self.game:whoseTurn()) then
		return false
	end
	
	local ts = self.game:performTurn(x, y)
	if ts then
		self.currentTurnTime = 0
		if self.game.isGameOver then
			self:onGameOver()
		end
	end

	return ts
end

--
--  Handles the mouse input
--
function _M:handleMouseInput()
	if love.mouse.isDown( 'l' ) then		
		local x, y = love.mouse.getPosition()
		if 	x >= self.positionScale.x and 
			x <= self.positionScale.x + self.positionScale.w and
			y >= self.positionScale.y and
			y <= self.positionScale.y + self.positionScale.h then
			self:performTurn(
				math.floor((x - self.positionScale.x) / (self.positionScale.w / 3))+1,
				math.floor((y - self.positionScale.y) / (self.positionScale.h / 3))+1)			
		end
	end
end        

--
--  Updates the component
--
function _M:update(dt)
	-- check to see if the game is still running
	if not self.game.isGameOver then	
	
		-- check if we need to skip a turn
		self.currentTurnTime = self.currentTurnTime + dt
		if self.currentTurnTime >= self.timePerTurn then
			self.currentTurnTime = 0
			self.game:skipTurn()
		end
	
		if self.game:whoseTurn() == self.humanPlayerNumber then
			self:handleMouseInput()
		else
			local turnSucceeded = false
			repeat 
				local x = math.random(1,self.game.board.width)
				local y = math.random(1,self.game.board.height)
				turnSucceeded = self:performTurn(x, y)
			until (turnSucceeded)
		end
	end
end

--
--  Draws the game board
--
function _M:drawGameBoard()
	love.graphics.setColor { 192, 192, 192, 255 }
	love.graphics.draw(self.images.board, self.positionScale.x, self.positionScale.y, 0, 
		self.positionScale.sx, self.positionScale.sy) 
		
	local s = self.game.board.squares
	local sx = self.positionScale.x
	local sy = self.positionScale.y
	for y = 1, #s do
		sx = self.positionScale.x
		for x = 1, #s[1] do
			local p = s[y][x]
			if p >= 0 then				
				-- choose the correct color for this piece
				local dc = { 0, 0, 0, 255 }				
				if p == self.humanPlayerNumber then
					if self.game.winner >= 0 then
						if self.game.winner == p then
							dc = { 0, 255, 0, 255 }
						else 
							dc = { 0, 0, 0, 255 }
						end
					else
						dc = { 0, 0, 255, 255 }
					end
				else
					if self.game.winner >= 0 then
						if self.game.winner == p then
							dc = { 255, 0, 0, 255 }
						else
							dc = { 0, 0, 0, 255 }
						end
					else
						dc = { 0, 0, 0, 255 }
					end
				end				
				if self.game.isDraw then
					dc = { 100, 100, 100, 255 }
                end
				
				-- set the color and draw the piece
				love.graphics.setColor(dc)
				love.graphics.draw(self.images[p], sx, sy, 0, 
					self.positionScale.sx, self.positionScale.sy)							
			end
			sx = sx + self.positionScale.w / 3
		end
		sy = sy + self.positionScale.h / 3
	end
	
	local outlineColor
	
	-- draw count down timer
	if not self.game.isGameOver then
		local height = self.positionScale.h - 
			(self.positionScale.h * (self.currentTurnTime / self.timePerTurn))
		local width = 10
		
		love.graphics.setLineWidth(1)
		love.graphics.setColor(100,100,255,255)
		love.graphics.rectangle('fill',
			self.positionScale.x - width * 2, 
			self.positionScale.y + self.positionScale.h - height, width, 
			height)
		
		if self.game.isGameOver then
			if self.game.isDraw then
				outlineColor = { 128, 128, 128, 128 }
			else
				if self.game.winner == self.humanPlayerNumber then
					outlineColor = { 0, 255, 0, 255} 
				else
					outlineColor = { 255, 0, 0, 255 }
				end
			end			
			
			love.graphics.setColor(outlineColor)
			love.graphics.setLineWidth( 4 )
			love.graphics.rectangle('line', 
				self.positionScale.x, self.positionScale.y, 
				self.positionScale.w, self.positionScale.h)					
		end
	end
	
	sx = self.positionScale.x
	sy = self.positionScale.y + self.positionScale.h
	if self.game.isGameOver then
		if self.game.isDraw then
			love.graphics.setColor(128,128,128,255)
			love.graphics.print('A Draw!', sx, sy)
		else
			if self.game.winner == self.humanPlayerNumber then
				love.graphics.setColor(0,255,0,255)
			else
				love.graphics.setColor(255,0,0,255)
			end
			love.graphics.print(self.playerNames[self.game.winner], sx, sy)
			love.graphics.print('Wins!', sx, sy + 20)
        end
	else
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.print(self.playerNames[self.game:whoseTurn()] .. '\'s Turn', sx, sy)
	end
end

--
--  Draws the tic tac toe component
--
function _M:draw()
	self:drawGameBoard()
end