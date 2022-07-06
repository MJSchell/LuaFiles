-- class Paddle:  for python
Paddle = Class{}

-- 'init' function or Constructor
-- def __init__(self,x,y,width,height):
--        self.x = x
function Paddle:init(x,y,width,height)
     self.x = x
     self.y = y
     self.w = width
     self.h = height
     self.dy = 0
end

-- Paddle will update and do some updating
function Paddle:update(dt)
     --check to see if we are going up or down
     if self.dy<0 then
          --check to see if we are at 0 or somewhere on the board
          self.y = math.max(0,self.y + self.dy * dt)          --add dy means down
     else
          --check to see if we are off the bottom of the board
          self.y = math.min(VIRTUAL_HEIGHT-self.h , self.y + self.dy * dt)          --subtract dy means up
     end 
end

function Paddle:update2(dt)
     --check to see if we are going left or right
     if self.dx<0 then
          --check to see if we are at 0 or somewhere on the board
          self.x = math.max(0,self.x + self.dx * dt)          --add dy means down
     else
          --check to see if we are off the bottom of the board
          self.x = math.min(VIRTUAL_WIDTH-self.w , self.x + self.dx * dt)          --subtract dy means up
     end 
end

-- Paddle will need to be drawn or render
function Paddle:render()
     love.graphics.rectangle('fill',self.x,self.y,self.w,self.h)
end