
-- library imports
local rectangle = love.graphics.rectangle

--local image
local angle      = 0
local width      = 40
local height     = 40
local steps      = 150*2  --determines the speed of movement
local circleRad  = 30
local tolerance  = 10  -- the allowed distance between the worm and the snake -- for the snake to have eaten the worm

local debug      = { 
                     dSnake  = { x = 10, y = 0}, 
                     dWorm   = { x = 10, y = 20},
                     dDeltaX = { x = 10, y = 40},
                     dDeltaY = { x = 10, y = 60}
                   }



----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
function love.load()
   --image = love.graphics.newImage("cake.png")
   snakeCharacter = {}
   snakeCharacter.x = 300
   snakeCharacter.y = 400
   snakeCharacter.name = "snake"
   snakeCharacter.width = width
   snakeCharacter.height = height

   wormCharacter = {}
   wormCharacter.x = 300
   wormCharacter.y = 300
   wormCharacter.name = "worm"
   wormCharacter.rad = 15

   love.graphics.setNewFont(20) -- debug message font
   love.graphics.setColor(0,0,0)

   --love.graphics.circle("fill", 300, 300, 50, 5)

   love.graphics.setBackgroundColor(100,200,100)

end

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
function love.draw()

   love.graphics.setColor(255, 255, 255) 
   rectangle("fill", wormCharacter.x, wormCharacter.y, width, height)

   --love.graphics.draw(image, imgx, imgy)
   --love.graphics.print("Click and drag the cake around or use the arrow keys", 10, 10)
   love.graphics.print(snakeCharacter.name.." pos: ("..snakeCharacter.x..",  "..snakeCharacter.y..")", debug.dSnake.x, debug.dSnake.y)
   love.graphics.print(wormCharacter.name.." pos: ("..wormCharacter.x..",  "..wormCharacter.y..")", debug.dWorm.x, debug.dWorm.y)

   love.graphics.print("delta-X: "..(math.abs(snakeCharacter.x - wormCharacter.x)), debug.dDeltaX.x, debug.dDeltaX.y)    
   love.graphics.print("delta-Y: "..(math.abs(snakeCharacter.y - wormCharacter.y)), debug.dDeltaY.x, debug.dDeltaY.y)  

   --love.graphics.print(wormCharacter.name.." pos: ("..wormCharacter.x..",  "..wormCharacter.y..")", 300, 400)
   
   love.graphics.rotate(angle)
   love.graphics.setColor(0,0,0)
   rectangle("fill", snakeCharacter.x, snakeCharacter.y, snakeCharacter.width, snakeCharacter.height)  

end

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
function love.update(dt)
   --on pressing the 'right arrow' key, rotate to the right
   if love.keyboard.isDown('right') then
      --angle = angle + math.pi * dt
      snakeCharacter.x = snakeCharacter.x + steps * dt
   -- else if we press 'left arrow', rotate to the left
   elseif love.keyboard.isDown('left') then
      --angle = angle - math.pi * dt
      snakeCharacter.x = snakeCharacter.x - steps * dt
   end
   
   if( (math.abs(snakeCharacter.x - wormCharacter.x) <= tolerance) and 
      (math.abs(snakeCharacter.y - wormCharacter.y) <= tolerance) ) then
      updateCharacters();
   end

   if love.keyboard.isDown('up') then
      snakeCharacter.y = snakeCharacter.y - steps * dt
   elseif love.keyboard.isDown('down') then
      snakeCharacter.y = snakeCharacter.y + steps * dt
   end

end

----------------------------------------------------------------------------------
-- @description prints the current postion of the snake
----------------------------------------------------------------------------------
function updateCoordDisplay(entity)
   if entity.name == "snake" then
      love.graphics.print(entity.name.." pos: ("..entity.x..",  "..entity.y..")", debug.dSnake.x, debug.dSnake.y)
   elseif entity.name == "worm" then
      love.graphics.print(entity.name.." pos: ("..entity.x..",  "..entity.y..")", debug.dWorm.x, debug.dWorm.y)      
   end

   love.graphics.print(" delta-X: "..(math.abs(snakeCharacter.x - wormCharacter.x)), debug.dDeltaX.x, debug.dDeltaX.y)    
   love.graphics.print(" delta-Y: "..(math.abs(snakeCharacter.y - wormCharacter.y)), debug.dDeltaY.x, debug.dDeltaY.y)         

end

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
function updateCharacters()
   updateWorm()
   updateSnake()
   updateCoordDisplay(snakeCharacter)
   updateCoordDisplay(wormCharacter)
end

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
function updateSnake()
   snakeCharacter.width = snakeCharacter.width + width
end

----------------------------------------------------------------------------------
-- @description respawns  the worm after it has been eaten by the snake
----------------------------------------------------------------------------------
function updateWorm()
   wormCharacter.x = love.math.random(0, 800-width)
   wormCharacter.y = love.math.random(0, 600-height)
end

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
function love.quit()
  print("Thanks for playing! Come back soon!")
end