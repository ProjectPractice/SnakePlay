
io.stdout:setvbuf("no")

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


local debugMode = false  -- to view debug info on the game play screen

local soundMode = true   -- to play sound or silent game play
local wormEatenSound

local soundOnIcon
local soundOffIcon

local bg    --the background image
local food = {
               strawberry = {imgname = "strawberry_0.png"}
             }

local fStrawberry
local fStrawberryWidth
local fStrawberryHeight

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

   love.graphics.setNewFont('xfiles.ttf', 20) -- debug message font
   love.graphics.setColor(0,0,0)

   --love.graphics.circle("fill", 300, 300, 50, 5)

   --love.graphics.setBackgroundColor(100,20,100)   -- the background screen of the game

   wormEatenSound = love.audio.newSource("menu-interface-confirm.wav", "static")
   soundOnIcon    = love.graphics.newImage("Sound-On.png")
   soundOffIcon   = love.graphics.newImage("Sound-Off.png")

   bg = love.graphics.newImage("jungle-background.jpg")


   fStrawberry = love.graphics.newImage(food.strawberry.imgname)
   fStrawberryWidth = fStrawberry:getWidth()
   fStrawberryHeight = fStrawberry:getHeight()

end

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
function love.draw()
   love.graphics.setColor(255,200,0)

   love.graphics.draw(bg)

   --rectangle("fill", wormCharacter.x, wormCharacter.y, width, height)
   love.graphics.draw(fStrawberry, wormCharacter.x, wormCharacter.y, math.rad(0), 0.1, 0.1, fStrawberryWidth/5, fStrawberryHeight/5)

   if soundMode == true then
      love.graphics.draw(soundOnIcon, 1040, 10)  --TODO: not use absolute co-ordinate values
   else
      love.graphics.draw(soundOffIcon, 1040, 10)
   end
 
   if debugMode then
      love.graphics.print(snakeCharacter.name.." pos: ("..snakeCharacter.x..",  "..snakeCharacter.y..")", debug.dSnake.x, debug.dSnake.y)
      love.graphics.print(wormCharacter.name.." pos: ("..wormCharacter.x..",  "..wormCharacter.y..")", debug.dWorm.x, debug.dWorm.y)

      love.graphics.print("delta-X: "..(math.abs(snakeCharacter.x - wormCharacter.x)), debug.dDeltaX.x, debug.dDeltaX.y)      
      love.graphics.print("delta-Y: "..(math.abs(snakeCharacter.y - wormCharacter.y)), debug.dDeltaY.x, debug.dDeltaY.y)  
   end
   
   --love.graphics.rotate(angle)
   love.graphics.setColor(255, 255, 255)    
   rectangle("fill", snakeCharacter.x, snakeCharacter.y, snakeCharacter.width, snakeCharacter.height)
end

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
function love.update(dt)

   --on pressing the 'right arrow' key, rotate to the right
   if love.keyboard.isDown('right') then
      snakeCharacter.x = snakeCharacter.x + steps * dt
   -- else if we press 'left arrow', rotate to the left
   elseif love.keyboard.isDown('left') then
      snakeCharacter.x = snakeCharacter.x - steps * dt
   end
   
   if love.keyboard.isDown('up') then
      snakeCharacter.y = snakeCharacter.y - steps * dt
   elseif love.keyboard.isDown('down') then
      snakeCharacter.y = snakeCharacter.y + steps * dt
   end

   if( (math.abs(snakeCharacter.x - wormCharacter.x) <= tolerance) and 
      (math.abs(snakeCharacter.y - wormCharacter.y) <= tolerance) ) then
      
      if soundMode  == true then
         wormEatenSound:play() -- give acoustic feedback to the player
      end

      -- core update operation here
      updateCharacters();

   end

end

function love.keypressed(key)
   --space key toggles sound
   if key == ' ' then  
      if soundMode == false then
         soundMode = true
      else 
         soundMode = false
      end
   end

   --esacpe key quits the game
   if key == 'escape' then
      love.event.quit()
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

   if debugMode == "true" then
      updateCoordDisplay(snakeCharacter)
      updateCoordDisplay(wormCharacter)
   end
end

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
function updateSnake()
   snakeCharacter.width = snakeCharacter.width + width
end

----------------------------------------------------------------------------------
-- @description respawns the worm after it has been eaten by the snake
----------------------------------------------------------------------------------
function updateWorm()
   wormCharacter.x = love.math.random(0, 1095-width)
   wormCharacter.y = love.math.random(0, 730-height)
end

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
function love.quit()
  print("Thanks for playing! Come back soon!")
end