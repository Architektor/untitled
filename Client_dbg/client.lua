
local Client = NetTest:addState('Client')
function Client:enterState()
  clearLoveCallbacks()
  print("initializing client")
  
  grass = love.graphics.newImage('sprites/grass.png')
  rocks = love.graphics.newImage('sprites/rocks.png')
  brick = love.graphics.newImage('sprites/brick.png')
  selection = love.graphics.newImage('sprites/selection.png')
  
  world:NewTile(0,grass)
  world:NewTile(1,rocks)
  world:NewTile(2,brick)
  world:NewTile(3,selection)
  
  cam = Camera(love.window:getWidth()/2,love.window:getHeight()/2)
  
--------------------GUI------------------
  chatbox = Block:new(0,0,0,love.window.getWidth(0)/8,200)
------------------ WORLD------------------
-----------------------------------------

  function round(x)
    if x%math.floor(x) > 0.5 then
      return math.ceil(x)
    else
      return math.floor(x)
    end
  end    
  function toIso(x,y)
    return x-y,(x+y)/2
  end
  function toCartesian(isox,isoy)
    return (2*isoy+isox)/2,(2*isoy-isox)/2
  end
------------------------------------------
   function love.update(dt)
     client:update(dt)
     if(#chat > 15) then
       chat[1] = nil
       for i = 1,15 do
         chat [i] = chat[i+1]
       end
       chat[16] = nil
     end
       worldx , worldy = cam:worldCoords(cam:pos())

   end
------------------------------------------  
  function love.draw()
    cam:attach()
    
      world:Draw()
    --[[for i =1,#world+1 do
    love.graphics.line((i-2)*(-32), (i-1)*16, (#world+1)*32-(i-1)*32,#world*16+(i-1)*16)
    end
    for j = 1,#world+1 do
      love.graphics.line(j*32,(j-1)*16,(#world-1)*(-32)+(j-1)*32,#world*16+(j-1)*(16))
    end]]--
    
    cam:detach()
    if input_line == 1 then
      love.graphics.printf(input,0,8+(#chat+1)*mainfont:getHeight( ),love.graphics.getWidth())
      love.graphics.printf('|',mainfont:getWidth(input)+1,8+(#chat + 1)*mainfont:getHeight( ),love.graphics.getWidth())
    end
    for i = 1,#chat do
      love.graphics.printf(chat[i], 0, 8+i*mainfont:getHeight( ), love.graphics.getWidth())
    end
    for i = 1,#client_name do
      love.graphics.printf(clients[i], 200, 8+i*mainfont:getHeight( ), love.graphics.getWidth())
    end
      --love.graphics.printf(drawx .. " : " ..  drawy, 0, 100, love.graphics.getWidth())
      if drawborder == 1 then
       -- love.graphics.draw(border,tileX,tileY)

      end
  end
-----------------------------------------
  function love.mousepressed(x, y, button)
    if button == 'r' then
      drawx , drawy = cam:mousepos()
      --tileX = round(drawy/64)
      --tileY = round((drawy/32)*2)
      --drawborder = 1
    end
  end
  function love.mousemoved( x, y, dx, dy )
    if love.mouse.isDown('l') then
     cx, cy = cam:pos()
     mx , my = cam:mousepos()
    cam:lookAt(cx-dx, cy-dy)
    end
  end
------------------------------------------
  function love.keypressed(k)
    if k=='escape' then
      netTest:gotoState('Menu')
    end
    if k == 'y' then
      love.keyboard.setTextInput(true)
      input_line = 1
    end
    if k == 'a' then
      client:send('004')
    end
    if k == 'return' and input_line == 1 then
      client:send('003' .. input)
      love.keyboard.setTextInput(false)
      input_line = 0
      input = ''
    end
    if k == "backspace" then
        local byteoffset = utf8.offset(input, -1)
        if byteoffset then
            input = string.sub(input, 1, byteoffset - 1)
        end
    end
  end
----------------------------------------- 
  function Client:exitState()
    print("Exiting client")
  end
end


