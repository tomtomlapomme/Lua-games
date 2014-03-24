require("myLib")
require("math")

local windowsSize = { x = 600, y = 600 }
myLib.init( windowsSize.x, windowsSize.y )

local world = {
field = {},
size = { x = 8, y = 8 },
turn = 1,
lastDraw,
gameOver = false,
winner = 0,
nbTurn =0 }

local command = {
click = 0,
close = 0,
position = { x =0, y = 0 } }

tableHelper = {
{x = -1, y =-1},
{x = -1, y = 0},
{x = -1, y =1},
{x = 0, y =-1} }

name = { "nulle", "rouge", "vert" }
other = { 2, 1 }

-- Init world
function Init(world)
	for i=1,world.size.x do
		world.field[i] = {}
		for j=1,world.size.y do
			world.field[i][j] = 0
		end
	end
	world.lastDraw = os.clock()
end

function delay(t)
	local b = os.clock()
	while( os.clock()-b < t ) do
	end
end

function Draw(world)
	--clear the back buffer
	myLib.color(0, 0, 0.5)
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
					myLib.color(0.5,0,0)
				else
					myLib.color(0,0.5,0.5)
				end
				myLib.circle((i-0.5)*2/world.size.x-1,(j-0.5)*2/world.size.y-1,0.9/world.size.x)
			end
		end
	end
	if world.gameOver == true then
		local text = string.format("%s %s", name[world.winner+1], "gagne" )
		myLib.color(1,0,0)
		myLib.text( -0.3,-0.3, text )
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

function test(world, x, y, turn)
	for i=1,4 do
		local dx = tableHelper[i].x
		local dy = tableHelper[i].y
		local xPos = x-dx
		local yPos = y-dy
		while(xPos>0 and xPos <= world.size.x and yPos >0 and yPos <= world.size.y and world.field[xPos][yPos] == turn) do
			xPos = xPos - dx
			yPos = yPos - dy
		end
		dx = -dx
		dy = -dy
		xPos = xPos-dx
		yPos = yPos-dy
		local count = 0
		while(xPos>0 and xPos <= world.size.x and yPos >0 and yPos <= world.size.y and world.field[xPos][yPos] == turn) do
			xPos = xPos - dx
			yPos = yPos - dy
			count = count + 1
		end
		if(count == 4) then
			world.gameOver = true
			world.winner = turn
			break
		end
	end
end

function place(world, x)
	local y = world.size.y
	while(world.field[x][y] == 0 and y > 0) do
		world.field[x][y] = world.turn
		Draw(world)
		delay(0.05)
		world.field[x][y] = 0
		y = y - 1
	end
	world.field[x][y+1] = world.turn
	test(world, x, y+1, world.turn)
end

function Game(command,world)
	if( command.click == 1 ) then
		if(world.field[command.x][world.size.y] == 0) then
			place(world, command.x)
			world.turn = other[world.turn]
		end
	end
end

-- main
Init(world)
while command.close == 0 do
	Event(command,windowsSize,world)
	if world.gameOver == false then
		Game(command,world)
	end
	if (os.clock() - world.lastDraw) > 0.016 then
		Draw(world)
	end
end
myLib.close()
