--var = import or require the file 'push'
push = require 'push'
Class = require 'class'
require 'Paddle'
require 'Ball'

WINDOW_WIDTH=800
WINDOW_HEIGHT=800

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

--A function to start up the window that initialzes the game
function love.load()
     
     --"seed" the RNG so that calls to random are always random
     -- use the current time, since that will vary on startup every time
     math.randomseed(os.time())

     -- use nearest-neighbor filtering on upscaling and downscaling to prevent blurry
     love.graphics.setDefaultFilter('nearest','nearest')

     love.window.setTitle("Pong")
     
     -- var = love's graphics module.newFont('file',fontsize)
     smallFont = love.graphics.newFont('font.ttf',8)
     scoreFont = love.graphics.newFont('font.ttf',32)

     --sounds table
     sounds = {
          --key = love.audio.newSource('file path','static')
          ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav','static'),
          ['score'] = love.audio.newSource('sounds/score.wav','static'),
          ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav','static'),
     }

     --this method changes the screen to our virtual resolution
     push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
          fullscreen=false,
          resizable=true,
          vsync=true
     })

     player1Score=7
     player2Score=7
     player3Score=7
     player4Score=7


     --initialize the servingPlayer var
     servingPlayer = 1


     player1 = Paddle(10,30,5,20)
     player2 = Paddle(VIRTUAL_WIDTH-10, VIRTUAL_HEIGHT-30, 5, 20)
     player3 = Paddle(VIRTUAL_WIDTH/2, VIRTUAL_HEIGHT-10, 20, 5)
     player4 = Paddle(VIRTUAL_WIDTH/2, VIRTUAL_HEIGHT/10-20, 20, 5)
     

     ball=Ball(VIRTUAL_WIDTH/2-2,VIRTUAL_HEIGHT/2-2, 4, 4)

     --determining a random dx and dy to move the ball
     ballDx = math.random(2) == 1 and 100 or -100
     ballDy = math.random(-50,50)

     --this var will help determine what is going on in the game
     --in the beginning, menu, main game, high score, etc
     gameState = 'start'

end



function love.resize(w,h)
     push:resize(w,h)
end


--this f(x) is ran every frame, pass in dt. 
--dt is delta time or change in seconds since the last frame
function love.update(dt)
     --ball movement
     if gameState == 'serve' then
          --set the dy and dx of the ball based on the server
          ball.dy = math.random(-50,50)
          if servingPlayer == 1 then
               ball.dx = math.random(140,200)
          elseif servingPlayer == 2 then
               ball.dx = -math.random(140,140)
          elseif servingPlayer == 3 then
               ball.dy = -math.random(140,200)
          elseif servingPlayer == 4 then
               ball.dy = math.random(140,140)
          end
     elseif gameState == 'play' then
          --check for collision, if there is collision move the ball ball
          --check for collision, if there is collision move the ball ball
          if ball:collides(player1) then
               ball.dx = -ball.dx*1.03
               ball.x = player1.x+5
               --velocity going in the same direction, but a little random
               if ball.dy<0 then
                    ball.dy=-math.random(10,150)
               else
                    ball.dy=math.random(10,150)
               end
               sounds['paddle_hit']:play()
          end
          if ball:collides(player2) then
               ball.dx = -ball.dx*1.03
               ball.x = player2.x-5
               --velocity going in the same direction, but a little random
               if ball.dy<0 then
                    ball.dy=math.random(10,150)
               else
                    ball.dy=-math.random(10,150)
               end
               sounds['paddle_hit']:play()
          end
          if ball:collides(player3) then
               ball.dy = -ball.dy*1.03
               ball.y = player3.y-5
               --velocity going in the same direction, but a little random
               if ball.dx<0 then
                    ball.dx=math.random(10,150)
               else
                    ball.dx=-math.random(10,150)
               end
               sounds['paddle_hit']:play()
          end
          if ball:collides(player4) then
               ball.dy = -ball.dy*1.03
               ball.y = player4.y+5
               --velocity going in the same direction, but a little random
               if ball.dx<0 then
                    ball.dx=-math.random(10,150)
               else
                    ball.dx=math.random(10,150)
               end
               sounds['paddle_hit']:play()
          end
          --check for collision with the walls
          --detect upper and lower screen boundary collision and reverse if collided
          if ball.y <= 0 then
               servingPlayer = 4
               player4Score = player4Score - 1
               if player4Score == 0 then
                    winningPlayer = 4
                    gameState = 'done'
               else
                    ball:reset()
                    gameState = 'serve'
               end
               sounds['score']:play()
          end
          
          -- -4 to account for the ball's size
          if ball.y >= VIRTUAL_HEIGHT - 4 then
               servingPlayer = 3
               player3Score = player3Score - 1
               if player3Score == 0 then
                    winningPlayer = 3
                    gameState = 'done'
               else
                    ball:reset()
                    gameState = 'serve'
               end
               sounds['score']:play()
          end
          --if the ball has went past a paddle
          if ball.x <= 0 then
               servingPlayer = 1
               player1Score = player1Score - 1
               if player1Score == 0 then
                    winningPlayer = 1
                    gameState = 'done'
               else
                    ball:reset()
                    gameState = 'serve'
               end
               sounds['score']:play()
          end
          
          if ball.x >= VIRTUAL_WIDTH then
               servingPlayer = 2
               player2Score = player2Score - 1
               if player2Score == 0 then
                    winningPlayer = 2
                    gameState = 'done'
               else
                    ball:reset()
                    gameState = 'serve'
               end
               sounds['score']:play()
          end

          ball:update(dt)
          
     end

     --player 1 movement
     if love.keyboard.isDown('w') then
          -- move up by add a negative paddle speed to the y scaled by dt
         player1.dy = -PADDLE_SPEED
     elseif love.keyboard.isDown('s') then
          -- move down by add a positive paddle speed to the y scaled by dt
          player1.dy = PADDLE_SPEED
     else
          player1.dy = 0
     end

     --player 2 movement
     if love.keyboard.isDown('up') then
          -- move up by add a negative paddle speed to the y scaled by dt
          player2.dy = -PADDLE_SPEED
     elseif love.keyboard.isDown('down') then
          -- move down by add a positive paddle speed to the y scaled by dt
          player2.dy = PADDLE_SPEED
     else
          player2.dy = 0
     end
     --'HELPME'
     --player 3 movement
     if love.keyboard.isDown('left') then
          -- move up by add a negative paddle speed to the y scaled by dt
          player3.dx = -PADDLE_SPEED
     elseif love.keyboard.isDown('right') then
          -- move down by add a positive paddle speed to the y scaled by dt
          player3.dx = PADDLE_SPEED
     else
          player3.dx = 0
     end
     --player 4 movement
     if love.keyboard.isDown('a') then
          -- move up by add a negative paddle speed to the y scaled by dt
          player4.dx = -PADDLE_SPEED
     elseif love.keyboard.isDown('d') then
          -- move down by add a positive paddle speed to the y scaled by dt
          player4.dx = PADDLE_SPEED
     else
          player4.dx = 0
     end

     player1:update(dt)
     player2:update(dt)
     player3:update2(dt)
     player4:update2(dt)

end


--Check for any keypressing
function love.keypressed(key)
     -- keys can be access by string name
     if key=='escape' then
          love.event.quit()  --this will close the window
     elseif key == 'enter' or key == 'return' then
          if gameState == 'start' then
               gameState = 'serve'
          elseif gameState == 'serve' then
               gameState = 'play'
          elseif gameState == 'done' then
               gameState = 'serve'
               ball:reset()
               player1Score = 7
               player2Score = 7
               player3Score = 7
               player4Score = 7
               if winningPlayer == 1 then
                    servingPlayer = 2
               elseif winningPlayer == 2 then
                    servingPlayer = 1
               elseif winningPlayer == 3 then
                    servingPlayer = 4
               elseif winningPlayer == 4 then
                    servingPlayer = 3
               end
          end
     end
end

--draw on the screen the letters
--update the screen with information:  draw anything that is needed
function love.draw()
     --begin rendering at a virtual resolution
     push:apply('start')

     --clear the screen and reset the background color
     --love.graphics.clear(r,g,b,a)
     love.graphics.clear(40,45,52,255)
     --set font for love
     love.graphics.setFont(smallFont)

     if gameState == 'start' then
          love.graphics.setFont(smallFont)
          love.graphics.printf('Hello Start State!',0,20,VIRTUAL_WIDTH,'center')
          love.graphics.printf('Press Enter To Begin!',0,30,VIRTUAL_WIDTH,'center')
     elseif gameState == 'serve' then
          love.graphics.setFont(smallFont)
          love.graphics.printf('Hello Serve State!',0,20,VIRTUAL_WIDTH,'center')
          love.graphics.printf('Press Enter To Begin!',0,30,VIRTUAL_WIDTH,'center')
     elseif gameState == 'play' then
          -- no UI message to display
     elseif gameState == 'done' then
          love.graphics.setFont(scoreFont)
          love.graphics.printf('Player '..tostring(winningPlayer)..' Loses',0,150,VIRTUAL_WIDTH,'center')
          love.graphics.setFont(smallFont)
          love.graphics.printf('Press Enter To Begin!',0,20,VIRTUAL_WIDTH,'center')
     end

     love.graphics.setFont(scoreFont)
     love.graphics.print(tostring(player1Score),VIRTUAL_WIDTH/2-50,VIRTUAL_HEIGHT/2)
     love.graphics.print(tostring(player2Score),VIRTUAL_WIDTH/2+50,VIRTUAL_HEIGHT/2)
     love.graphics.print(tostring(player3Score),VIRTUAL_WIDTH/2,VIRTUAL_HEIGHT/2+50)
     love.graphics.print(tostring(player4Score),VIRTUAL_WIDTH/2,VIRTUAL_HEIGHT/2-50)

     -- Draw the paddles and the ball
     player1:render()
     player2:render()
     player3:render()
     player4:render()
     ball:render()

     displayFPS()
     --end virtual resolution
     push:apply('end')
end



--anything that is a function that is not a love function should be at the bottom
function displayFPS()
     love.graphics.setFont(smallFont)
     love.graphics.setColor(0,255,0,255)
     --print("FPS: 60",x y)
     love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()),10,10)
end