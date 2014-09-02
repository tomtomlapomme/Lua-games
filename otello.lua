require("myLib")
require("math")


local windowsSize = { x = 600, y = 600 }
myLib.init( windowsSize.x, windowsSize.y )


local world = {
field = {},
size = { x = 10, y = 10 },
turn = 1,
lastDraw,
gameOver = false,
winner = 0,
black,
white,
nbTurn =0 }

local command = {
click = 0,
close = 0,
position = { x =0, y = 0 } }

tableHelper = {
{x = -1, y =-1},
{x = -1, y = 0},
{x = -1, y =1},
{x = 0, y =-1},
{x = 0, y =1},
{x = 1, y =-1},
{x = 1, y =0},
{x = 1, y =1} }

name = { "nulle", "black", "white" }

other = { 2, 1 }

-- Init world
function Init(world)
	for i=1,world.size.x do
		world.field[i] = {}
		for j=1,world.size.y do
			world.field[i][j] = 0
		end
	end
	world.field[5][5] = 1
	world.field[6][6] = 1
	world.field[5][6] = 2
	world.field[6][5] = 2
	world.lastDraw = os.clock()
end

function delay(t)
	local b = os.clock()
	while( os.clock()-b < t ) do
	end
end

function Draw(world)
	--clear the back buffer
	myLib.color(0.1, 0.5, 0)
	myLib.clear()

	-- draw grid
	myLib.color(0, 0, 0)
	for i=1,world.size.x do
		myLib.square(-1,(i-0.01)*2/world.size.x-1,2,0.1/world.size.x)
	end

	for i=1,world.size.x do
		myLib.square((i-0.01)*2/world.size.x-1,-1,0.1/world.size.y,2)
	end

	-- draw game
	for i=1,world.size.x do
		for j=1,world.size.y do
			local color = world.field[i][j]
			if color ~= 0 then
				if color == 1 then
					myLib.color(0,0,0)
				else
					myLib.color(1,1,1)
				end
				myLib.circle((i-0.5)*2/world.size.x-1,(j-0.5)*2/world.size.y-1,0.9/world.size.x)
			end
		end
	end
	if world.gameOver == true then
		local text = string.format("%s %s", name[world.winner+1], "is the winner" )
		local text2 = string.format("black: %i    white: %i", world.black, world.white)
		myLib.color(1,0,0)
		myLib.text( -0.3,-0.3, text )
		myLib.text( -0.3,-0.1, text2 )
	end

	--swap buffer
	myLib.swap()
	world.lastDraw = os.clock()
end

function Event(command,windowsSize,world)
	local isEvent
	local key
	local x = 0
	local y = 0
	command.click = 0
	while isEvent~=0 do
		isEvent, key, x, y = myLib.key()
		if( isEvent == 5 ) then
			command.click = 1
			command.x = math.ceil(x/windowsSize.x*world.size.x)
			command.y = world.size.y+1-math.ceil(y/windowsSize.y*world.size.y)
		end
		if( isEvent == 2 ) then
			command.close = 1
			break
		end
	end
end

function isInside(world,x,y)
	if x > 0 and x <= world.size.x and y > 0 and y <=world.size.y then
		return true
	end
	return false
end

function TryAndChange(world,x,y,change)
	-- look in all directions
	local ret = false
	local numberToken = 0
	for i=1,8 do
		local dx = x + tableHelper[i].x
		local dy = y + tableHelper[i].y
		--if we find a different color token lets look further
		if isInside(world,dx,dy) and world.field[dx][dy] == other[world.turn] then
			numberToken = 1
			dx = dx + tableHelper[i].x
			dy = dy + tableHelper[i].y
			--keep looking
			while isInside(world,dx,dy) and world.field[dx][dy] == other[world.turn]  do
				dx = dx + tableHelper[i].x
				dy = dy + tableHelper[i].y
				numberToken = numberToken + 1
			end
			if isInside(world,dx,dy) and world.field[dx][dy] == world.turn then
				ret = true
				if change == true then
					-- change all the tocken's color
					local xChange = x
					local yChange = y
					for j=1,numberToken do
						xChange = xChange + tableHelper[i].x
						yChange = yChange + tableHelper[i].y
						world.field[xChange][yChange] = world.turn
					end
				end
			end
		end
	end
	if ret == true and change == true then
		world.field[x][y] = world.turn
	end
	return ret, numberToken
end

function PossibleMove(world)
	local ret = false
	for i=1,world.size.x do
		for j=1,world.size.y do
			if world.field[i][j] == 0 then
				if TryAndChange(world,i,j,false) == true then
					ret = true
					break
				end
			end
		end
		if ret == true then
			break
		end
	end
	return ret
end

function computeWinner(world)
	local white = 0
	local black = 0
	for i=1,world.size.x do
		for j=1,world.size.y do
			if world.field[i][j] == 1 then
				black = black + 1
			elseif world.field[i][j] == 2 then
				white = white + 1
			end
		end
	end
	world.white = white
	world.black = black
	if white > black then
		world.winner = 2
	elseif black > white then
		world.winner = 1
	end
end

function Game(command,world)
	if( command.click == 1 ) then
		if isInside(world,command.x,command.y) then
			if world.field[command.x][command.y] == 0 and
			TryAndChange( world, command.x, command.y, true ) == true then
				world.turn = (world.turn % 2) + 1
				world.nbTurn = world.nbTurn + 1
				world.played = os.clock()
				if PossibleMove(world) == false then
					world.turn = (world.turn % 2) + 1
					if PossibleMove(world) == false then
						world.gameOver = true
						computeWinner(world)
					end
				end
			end
		end
	end
end

function coef(x, y, world)
	if (x == 1 or x == world.size.x) and (y == 1 or y == world.size.y) then
		return 10
	end
	if (x <= 2 or x >= world.size.x - 1) and (y <= 2 or y >= world.size.y - 1) then
		return -2
	end
	if x == 2 or y == 2 or x == world.size.x - 1 or y == world.size.y - 1 then
		return -1
	end
	if x == 1 or x == world.size.x or y == 1 or y == world.size.y then
		return 5
	end
	return 2
end

-- evaluate the chances to win the game
function getScore(world)
	local score = 0
	for i=1,world.size.x do
		for j=1,world.size.y do
			if world.field[i][j] == 1 then
				score = score + 1*coef(i, j, world)
			end
			if world.field[i][j] == 2 then
				score = score - 1*coef(i, j, world)
			end
		end
	end
	return score
end

function CopyWorld(world, worldCopy)
	worldCopy.field = {}
	worldCopy.size = { x = world.size.x, y = world.size.y }
	worldCopy.turn = world.turn
	for i=1,world.size.x do
		worldCopy.field[i] = {}
		for j=1,world.size.y do
			worldCopy.field[i][j] = world.field[i][j]
		end
	end
end

function FindBest(world, depth, color)
	local x = 0
	local y = 0
	if depth  == 0 then
		return color * getScore(world), x, y
	end
	local tempworld = {}
	CopyWorld(world, tempworld)
	local bestValue = -100000
	for i=1,world.size.x do
		for j=1,world.size.y do
			if world.field[i][j] == 0 then
				if TryAndChange( tempworld, i, j, true ) == true then
					local val = FindBest(tempworld, depth - 1, -color)
					CopyWorld(world, tempworld)
					bestValue = math.max(bestValue, val)
					if bestValue == val then
						x = i
						y = j
					end
				end
			end
		end
	end
	return bestValue, x, y
end

function MiniMax(world)
	local m
	local x = 0
	local y = 0
	local tempworld = {}
	CopyWorld(world, tempworld)
	m, x, y = FindBest(tempworld, 3, 1)
	return x, y
end

-- IA
function IA( command, world )
	x, y  = MiniMax(world)
	command.x = x
	command.y = y
	command.click = 1
end

-- main
Init(world)
while command.close == 0 do
	if world.turn == 1 or world.gameOver == true then
		Event(command,windowsSize,world)
	elseif os.clock() - world.played > 0.5 then
		IA( command, world )
	end
	if world.gameOver == false then
		Game(command,world)
	end
	if (os.clock() - world.lastDraw) > 0.016 then
		Draw(world)
	end
end

myLib.close()
