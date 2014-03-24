require("myLib")
require("math")

windowsSize = { x = 500, y = 500 }
math.randomseed( os.time() )
myLib.init( windowsSize.x, windowsSize.y )

local world = {
field = {},
snakeSize = 2,
size = { x = 10, y = 10 },
snake = {
{ x=5, y=5 },
{ x=4, y=5},
{ x=3, y=5} },
grow = true,
v = { x = 1, y = 0 },
candy = { x=0, y =0 } }



local command = {
turnUp,
turnDown,
turnRight,
turnLeft,
close = 0 }

--init world
for i=1,world.size.x do
	world.field[i] = {}
	for j=1,world.size.y do
		world.field[i][j] = 0
	end
end

world.candy.x = math.random(world.size.x)
world.candy.y = math.random(world.size.y)

function advance( world, command )
	if world.grow == false then
		world.field[
		world.snake[world.snakeSize].x][world.snake[world.snakeSize].y] = 0
	end
	world.grow = false

	for i=world.snakeSize, 2, -1 do
		world.snake[i] = { x = world.snake[i-1].x, y = world.snake[i-1].y }
	end
	world.snake[1].x = (world.snake[1].x+world.v.x-1)%world.size.x+1
	world.snake[1].y = (world.snake[1].y+world.v.y-1)%world.size.y+1

	-- Can we cross the walls?
--	if snakex[1]>sizex or snakex[1]<1 or snakey[1]>sizey or snakey[1]<1 then
		--close = 1

	-- auto-collision
	if world.field[world.snake[1].x][world.snake[1].y] == 1 then
		print("loose")
		command.close = 1
	else
		if world.field[world.snake[1].x][world.snake[1].y] == 2 then
			world.grow = true -- we found the candy, snake will grow
		end
		world.field[world.snake[1].x][world.snake[1].y] = 1
	end
end

function event( command )
	--delay
	for i=0, 10000000 do
	end
	local isEvent, key = myLib.key()
	while isEvent>0 do
		if key == 273 then
			command.turnUp = true
		elseif key == 274 then
			command.turnDown = true
		elseif key == 275 then
			command.turnRight = true
		elseif key == 276 then
			command.turnLeft = true
		end
		if isEvent == 2 then
			command.close = 1
			break
		end
		isEvent, key = myLib.key()
	end
end

function draw( world )
	--clear the back buffer
	myLib.color(0.1, 0.5, 0)
	myLib.clear()

	-- draw the circle
	myLib.color(0, 0, 1)
	myLib.circle((world.candy.x-1)*2/world.size.x-1+1/world.size.x, (world.candy.y-1)*2/world.size.y-1+1/world.size.y, 1/world.size.x*0.8)

	-- draw snake
	myLib.color(1, 0, 0)
	for i=1,world.snakeSize do
		myLib.square(
			(world.snake[i].x-1)*2/world.size.x-1,
			(world.snake[i].y-1)*2/world.size.y-1,
			1.9/world.size.x,
			1.9/world.size.y )
	end

	--swap buffer
	myLib.swap()
end

function clearCommand( command )
	command.turnUp = false
	command.turnDown = false
	command.turnRight = false
	command.turnLeft = false
end

function direction( world, command )
	if command.turnUp == true and world.v.x ~= 0 then
		world.v.x = 0
		world.v.y = 1
	elseif command.turnDown == true and world.v.x ~= 0 then
		world.v.x = 0
		world.v.y = -1
	elseif command.turnRight == true and world.v.y ~= 0 then
		world.v.x = 1
		world.v.y = 0
	elseif command.turnLeft == true and world.v.y ~= 0 then
		world.v.x = -1
		world.v.y = 0
	end
end

function grow( world )
	if world.grow == true then
		world.snakeSize = world.snakeSize + 1
		local keepDoing = true
		while keepDoing == true do
			world.candy.x = math.random(world.size.x)
			world.candy.y = math.random(world.size.y)
			if world.field[world.candy.x][world.candy.y] == 0 then
				world.field[world.candy.x][world.candy.y] = 2
				keepDoing = false
			end
		end
	end
end

--main loop
while command.close == 0 do
	clearCommand(command)

	event( command )

	direction( world, command )

	grow( world )

	advance( world, command )


	if command.close == 0 then
		draw( world )
	end
end

myLib.close()
