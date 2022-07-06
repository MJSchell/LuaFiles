function love.draw()
    hour=os.date('%I')
    minute=os.date('%M')
    love.graphics.print(hour..':'..minute, 400, 300)
end
love.draw()