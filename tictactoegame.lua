--[[

tictactoegame.lua
January 9th, 2013

]]
local setmetatable 
	= setmetatable
		
local tttboard = require 'tictactoeboard'

module(...)

--
--  Creates a new tic tac toe game
--  Inputs:
--		b - the tic tac toe board
--		pc - the number of players
--
function _M:new(b, pc)
	local pc = pc or 2
	
	local o = { 
		board = b, 
		playerCount = pc
	}	
	
	self.__index = self
	
	local t = setmetatable(o, self)	
	t:reset()
	
	return t
end

--
--  Resets the game
--
function _M:reset()
	self.board:reset()
	self.currentPlayer = 0
	self.isGameOver = false
	self.isDraw = false
	self.winner = tttboard.NoWinner
end

--
--  Returns the number of the player whose turn it is
--
function _M:whoseTurn()
	return self.currentPlayer
end

--
--  Advances the turn to the next player
--
function _M:advanceTurn()
	self.currentPlayer = self.currentPlayer + 1
	if self.currentPlayer >= self.playerCount then
		self.currentPlayer = 0
	end
end

--
--  Skips a player's turn
--
function _M:skipTurn()
	self:advanceTurn()
end
        
--
--  Attemps to place the current player's piece
--	on the board at the given location
--  Returns the number of the winning player
--		
function _M:performTurn(x, y)
	if self.isGameOver then return false end
	if not self.board:makeMove(x, y, self.currentPlayer) then
		return false
	end

	local winner = self.board:winner()
	if winner == tttboard.NoWinner then
		self:advanceTurn()
	else
		self.isGameOver = true
		if winner >= 0 then
			self.winner = winner
		else
			self.isDraw = true
		end
	end
	return true
end
