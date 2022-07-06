Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    -- these variables are for keeping track of our velocity on both the
    -- X and Y axis, since the ball can move in two dimensions
    self.dy = math.random(-50, 50)
    self.dx = math.random(2) == 1 and -100 or 100
end
--check for collision and treturn a boolean value
function Ball:collides(paddle)
    --first check to see if left edge of either is farther to the right
    --then the right edge of the other
    --check horizontally we've collided
    if self.x > paddle.x + paddle.w or paddle.x > self.x + self.width then
        return false
    --check vertically if we've collided
    elseif self.y > paddle.y + paddle.h or paddle.y > self.y +self.height then
        return false

    --if neither of the ones above are true, then we have collisions
    else 
        return true
    end
end

--Places the ball in the middle of the screen, with an initial random velocity on both axes.
function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dy = math.random(2) == 1 and -100 or 100
    self.dx = math.random(-50, 50)
end

--Simply applies velocity to position, scaled by deltaTime.
function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end