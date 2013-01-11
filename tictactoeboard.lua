--[[

tictactoeboard.lua
January 9th, 2013

]]
local setmetatable
	= setmetatable
	
module(...)

FullBoard = -1
NoWinner = -99

--
--  Creates a new tic tac toe board
--
function _M:new(w, h)
	local w = w or 3
	local h = h or 3
	
	local o = { width = w, height = h }	
	self.__index = self
	local t = setmetatable(o, self)	
	t:reset()
	
	return t
end

--
--  Resets the squares on the board to empty
--
function _M:reset()	
	local s = {}	
	for y = 1, self.height do
		s[y] = {}
		for x = 1, self.width do
			s[y][x] = NoWinner
		end
	end
	
	self.squares = s
end

--
--  Attempts to make a move by the designated player at the designated position
--
--  Returns true if the move was successful, false otherwise
function _M:makeMove(x, y, p)
	if x < 1 or x > self.width then return false end
	if y < 1 or y > self.height then return false end
	if self.squares[y][x] ~= NoWinner then return false end

	self.squares[y][x] = p

	return true;
end       

--
--  Returns the number of winning player
--  NoWinner if there is no winner 
--  FullBoard if the board is full
--
function _M:winner()
	-- checks a sequence of positions for a winner
	local function checkSequence(vals)
		local p = self.squares[vals[2]][vals[1]]
		if p >= 0 then
			for i = 3, #vals, 2 do
				if self.squares[vals[i+1]][vals[i]] ~= p then
					p = NoWinner
					break
				end
			end
		end
		
		return p
	end
	
	-- check rows
	for y = 1, self.height do
		local p = checkSequence{ 1, y, 2, y, 3, y } 
		if p >= 0 then return p end
	end
	
	-- check columns
	for x = 1, self.width do
		local p = checkSequence{ x, 1, x, 2, x, 3 } 
		if p >= 0 then return p end
	end
	
	-- check diagonals
	local p = checkSequence{ 1, 1, 2, 2, 3, 3 } 
	if p >= 0 then return p end
	
	local p = checkSequence{ 3, 1, 2, 2, 1, 3 } 
	if p >= 0 then return p end

	-- check for empty square
	for y = 1, self.height do
		for x = 1, self.width do
			if self.squares[y][x] == NoWinner then
				return NoWinner
			end			
		end
	end

	return FullBoard
end