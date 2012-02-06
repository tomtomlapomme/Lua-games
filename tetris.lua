require("myLib")
require("math")

local windowsSize = { x = 300, y = 600 }

myLib.init( windowsSize.x, windowsSize.y )

bColor = {
{r = 1, g = 0, b = 0},
{r = 0, g = 1, b = 0},
{r = 0, g = 0, b = 1},
{r= 0.5, g= 0.5, b = 0},
{r=0, g= 0.5, b= 0.5 },
{r=0.7, g=0.2, b=0.5 },
{r=0.8,g=0.9,b=0.2} }

long = {
index = 1,
positions = {
{ {x = 0, y = -1},
  {x = 0, y = 0},
  {x = 0, y = 1},
  {x = 0, y = 2} },
{ {x = -1, y = 0},
  {x = 0, y = 0},
  {x = 1, y = 0},
  {x = 2, y = 0} },
{ {x = 0, y = -2},
  {x = 0, y = -1},
  {x = 0, y = 0},
  {x = 0, y = 1} },
{ {x = -2, y = 0},
  {x = -1, y = 0},
  {x = 0, y = 0},
  {x = 1, y = 0} } }
}

cube = {
index = 2,
positions = {
{ {x = 0, y = 0},
  {x = 0, y = 1},
  {x = 1, y = 1},
  {x = 1, y = 0} },
{ {x = 0, y = 0},
  {x = 0, y = 1},
  {x = 1, y = 1},
  {x = 1, y = 0} },
{ {x = 0, y = 0},
  {x = 0, y = 1},
  {x = 1, y = 1},
  {x = 1, y = 0} },
{ {x = 0, y = 0},
  {x = 0, y = 1},
  {x = 1, y = 1},
  {x = 1, y = 0} } }
}

Tshape = {
index = 3,
positions = {
{ {x = 0, y = 0},
  {x = 1, y = 0},
  {x = -1, y = 0},
  {x = 0, y = 1} },
{ {x = 0, y = 0},
  {x = 0, y = 1},
  {x = 1, y = 0},
  {x = 0, y = -1} },
{ {x = 0, y = 0},
  {x = -1, y = 0},
  {x = 0, y = -1},
  {x = 1, y = 0} },
{ {x = 0, y = 0},
  {x = -1, y = 0},
  {x = 0, y = -1},
  {x = 0, y = 1} } }
}

rightT = {
index = 4,
positions = {
{ {x = -1, y = -1},
  {x = -1, y = 0},
  {x = 0, y = 0},
  {x = 0, y = 1} },
{ {x = -1, y = 1},
  {x = 0, y = 1},
  {x = 0, y = 0},
  {x = 1, y = 0} },
{ {x = 0, y = -1},
  {x = 0, y = 0},
  {x = 1, y = 0},
  {x = 1, y = 1} },
{ {x = -1, y = 1},
  {x = 0, y = 1},
  {x = 0, y = 0},
  {x = 1, y = 0} } }
}

leftT = {
index = 5,
positions = {
{ {x = 0, y = -1},
  {x = 0, y = 0},
  {x = -1, y = 0},
  {x = -1, y = 1} },
{ {x = -1, y = -1},
  {x = 0, y = -1},
  {x = 0, y = 0},
  {x = 1, y = 0} },
{ {x = 0, y = -1},
  {x = 0, y = 0},
  {x = -1, y = 0},
  {x = -1, y = 1} },
{ {x = -1, y = -1},
  {x = 0, y = -1},
  {x = 0, y = 0},
  {x = 1, y = 0} } }
}

leftL = {
index = 6,
positions = {
{ {x = 1, y = 1},
  {x = 1, y = 0},
  {x = 1, y = -1},
  {x = 0, y = -1} },
{ {x = 1, y = -1},
  {x = 0, y = -1},
  {x = -1, y = -1},
  {x = -1, y = 0} },
{ {x = 0, y = 1},
  {x = -1, y = 1},
  {x = -1, y = 0},
  {x = -1, y = -1} },
{ {x = 1, y = 0},
  {x = 1, y = 1},
  {x = 0, y = 1},
  {x = -1, y = 1} } }
}

rightL = {
index = 7,
positions = {
{ {x = -1, y = 1},
  {x = -1, y = 0},
  {x = -1, y = -1},
  {x = 0, y = -1} },
{ {x = -1, y = -1},
  {x = 0, y = -1},
  {x = 1, y = -1},
  {x = 1, y = 0} },
{ {x = 0, y = 1},
  {x = 1, y = 1},
  {x = 1, y = 0},
  {x = 1, y = -1} },
{ {x = -1, y = 0},
  {x = -1, y = 1},
  {x = 0, y = 1},
  {x = 1, y = 1} } }
}

math.randomseed( os.time() )

function pickNewPiece()
	local r = math.random(7)
	if r == 1 then
		return long
	elseif r == 2 then
		return cube
	elseif r == 3 then
		return Tshape
	elseif r == 4 then
		return rightT
	elseif r == 5 then
		return leftT
	elseif r == 6 then
		return leftL
	elseif r == 7 then
		return rightL
	end
end

function max(a, b)
	if( a>b) then
		return a
	end
	return b
end

function min(a, b)
	if( a<b) then
		return a
	end
	return b
end

local command = {right, left, turn, down}

local world = {
grid = {},
size = { x = 10, y = 20 },
piece,
position = { x = 5, y = 1 },
rotation = 1,
nbTry = 0,
lines = 0,
fall = 1 }

-- init world
for i=1,world.size.x do
	world.grid[i] = {}
	for j=1,world.size.y do
		world.grid[i][j] = 0
	end
end

world.piece = pickNewPiece()

function cubePos( world, i )
	local x = world.position.x+ world.piece.positions[world.rotation][i].x
	local y = world.position.y+ world.piece.positions[world.rotation][i].y
	return x, y
end

function checkLine( world, index )
	local line = true
	for k=1, world.size.x do
		if( world.grid[k][index] == 0 ) then
			line = false
			break
		end
	end
	return line
end

function pieceToWorld( world )
	local ymax = 0
	local ymin = world.size.y
	local line = 0

	-- add the piece to the world
	for i=1, 4 do
		local x, y = cubePos( world, i )
		world.grid[x][y] = world.piece.index
		ymin = min( ymin, y )
		ymax = max( ymax, y )
	end

	--check for lines
	for i=ymin, ymax do
		if( checkLine( world, i ) == true ) then
			line = line + 1 -- full line
			for j=i-1, 1, -1 do
				for k=1, world.size.x do
					world.grid[k][j+1] = world.grid[k][j]
				end
			end
		end
	end

	-- remove lines
	for i=1, line do
		for k=1, world.size.x do
			world.grid[k][i] = 0
		end
	end

	if( line > 0 ) then
		world.lines = world.lines + line
		print( "lines : ", world.lines )
	end
end

function tryPosition( world, position, rotation )
	for i = 1, 4 do
		local x = position.x+ world.piece.positions[rotation][i].x
		local y = position.y+ world.piece.positions[rotation][i].y
		if( y < 1 ) then
			return true
		end
		if( x< 1 or x >world.size.x ) then
			return false
		end
		if( y > world.size.y ) then
			return false
		end
		if( world.grid[x][y] > 0 ) then
			return false
		end
	end
	return true
end

function advance( world, command )
	local nextPosition = { x = world.position.x, y = world.position.y + 1 }

	local result = tryPosition( world, nextPosition, world.rotation )
	if( result == false ) then
		world.nbTry = world.nbTry + 1
	end

	if( result == true ) then
		world.position.y = nextPosition.y
	elseif( world.nbTry > 2 ) then
		pieceToWorld( world )
		world.position.x = 5
		world.position.y = 1
		world.rotation = 1
		world.nbTry = 0
		world.piece = pickNewPiece()
		world.nbTry = 0
		world.fall = 1
		if( tryPosition( world, world.position, world.rotation ) == false ) then
			print( "you loose" )
			command.close = true
		end
	end

end

function draw( world )
	--clear
	myLib.color(0,0,0)
	myLib.clear()

	--draw current piece
	local color = bColor[world.piece.index]
	myLib.color( color.r,color.b,color.g )
	for i=1,4 do
		local x, y = cubePos(world, i)
		myLib.square(
		1*((x - 1)*2/world.size.x) - 1,
		-1*((y )*2/world.size.y - 1),
		1.9/world.size.x,
		1.9/world.size.y )
	end

	--draw rest of the world
	for i=1,world.size.x do
		for j=1,world.size.y do
			if( world.grid[i][j] > 0 ) then
					local color = bColor[world.grid[i][j]]
					myLib.color( color.r,color.b,color.g )
					myLib.square(
						(i - 1)*2/world.size.x - 1,
						-1*((j )*2/world.size.y - 1),
						1.9/world.size.x,
						1.9/world.size.y )
			end
		end
	end

	--swap buffer
	myLib.swap()
end

function clearCommand( command )
	command.right = 0
	command.left = 0
	command.turn = 0
	command.down = 0
	command.close = false
end

function lateralMove( world, command )
	local nextPosition = { x = world.position.x, y = world.position.y }

	if( command.left > 0 ) then
		nextPosition.x = nextPosition.x - command.left
	end
	if( command.right > 0 ) then
		nextPosition.x = nextPosition.x + command.right
	end
	for i = 1, 4 do
		local x = nextPosition.x+ world.piece.positions[world.rotation][i].x
		if( x > world.size.x ) then
			nextPosition.x = nextPosition.x - x + world.size.x
		end
		if( x < 1 ) then
			nextPosition.x = nextPosition.x - x + 1
		end
	end
	if( command.right>0 or command.left >0 ) then
		local result = tryPosition( world, nextPosition, world.rotation )
		if( result == true ) then
			world.nbTry = 0
			world.position = nextPosition
		end
	end
end

function turn( world, command )
	local newRotation = world.rotation
	local newPosition = { x = world.position.x, y = world.position.y }

	while( command.turn > 0 ) do
		newRotation = newRotation % 4 + 1
		local result = tryPosition( world, newPosition, newRotation )
		if( result == false ) then
			newPosition.y = newPosition.y + 1
			result = tryPosition( world, newPosition, newRotation )
		end
		if( result == true ) then
			world.nbTry = 0
			world.rotation = (newRotation - 1) % 4 + 1
			world.Position = newPosition
		end
		command.turn = command.turn - 1
	end
end

function event( world, command )
	local i = 0
	isEvent, key = myLib.key()
	while isEvent>0 do
		if key == 273 then
			command.turn = command.turn + 1
		elseif key == 274 then
			world.fall = world.fall * 5
		elseif key == 275 then
			command.right = command.right + 1
		elseif key == 276 then
			command.left = command.left + 1
		end
		if isEvent == 2 then
			command.close = true
		end
		isEvent, key = myLib.key()
	end
end

-- main loop
command.close = false
local loop = 0
while command.close == false do

	clearCommand( command )

	event(world, command)

	lateralMove( world, command )

	turn( world, command )

	loop = loop + 1
	if( loop >= 500/world.fall ) then
		loop = 0
		advance( world, command )
	end


	if command.close == false then
		draw( world )
	end
end
myLib.close()
