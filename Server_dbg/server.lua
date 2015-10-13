local driver = require("luasql.mysql")
local env = driver.mysql()
local Server = NetTest:addState('Server')
      genWorld = false

  function Server:enterState()
    
    clearLoveCallbacks()
    print("initializing server")
    client_id = {}
    client_name = {}
    chat = {}
    query_t = {}
    query_f = {}
    time = 0
    online = 0
  
  function onConnect(ip, port)
    print("Connection from " .. ip)
    online = online + 1;
    --print(ip .. " recieved id " .. client_id[ip])
    --server:send('003' .. '10000' .. 'You recieved id ' .. client_id[ip], ip) --packet sending as 'XXX' header ++ 'DATA'
  end
  
  function onReceive(data, ip, port)
    
    pheader = string.sub(data,1,3)
    data = string.sub(data,4)
    
    if(pheader == '000') then
      print('someone authorizing with ' .. data .. ' token')
      dot = string.find(data,'|')
      authlogin = string.sub(data,1,dot-1)
      authpass  = string.sub(data,dot+1)
      conn = env:connect('LUADB', 'root', 'Kolokolq11')
      query = conn:execute('SELECT `Login`, `Pass` FROM `Users` WHERE `Login` = "' .. authlogin .. '" AND `Pass` = "' .. authpass .. '" ')
      row = query:fetch({},'a')
      if row ~= nil then
        print(ip .. ' passed auth ' .. row.Login .. ' == ' .. authlogin .. "|" .. row.Pass .. " == " .. authpass)
        --choose random id for new auth
       client_id[ip] = math.random(10001,99999)
        --remember new auth's login
       client_name[client_id[ip]] = authlogin
        --send world to new auth
        MainWorld:sendChunk(1,ip)
        --send all data about existing players to new auth
       for i = 1,#client_id do
         if client_id[i] ~= nil then
          server:send('005' .. client_id[i] .. client_name[client_id[i]], ip)
         end
       end
        --send system message "new username connected"
       server:send('004' .. '10000' .. authlogin .. ' connected')
        --grant access to the server to the new arrival
       server:send('003',ip)
        --send id/name of new arrival to all
       server:send('005' .. client_id[ip] .. client_name[client_id[ip]])
      else
        server:send('000',ip)
      end
        conn:close()
        query = nil
        passed = nil
    end
    
    if(pheader == '001') then
        newlogin = data
        print('someone registering with login ' .. newlogin)
        conn = env:connect('LUADB', 'root', 'Kolokolq11')
        query = conn:execute('SELECT `Login` FROM `Users` WHERE `Login` = "' .. newlogin .. '"')
        query = query:fetch()
        if query == newlogin then
          print(newlogin .. ' is already registered')
          server:send('000',ip)
        end
        if query == nil then
            print(newlogin .. ' is free')
            server:send('001',ip)
        end
        conn:close()
        query = nil
    end
  
    if(pheader == '002' and fail == nil) then
      dot = string.find(data,'|')
      newlogin = '"' .. string.sub(data,1,dot-1) .. '"'
      newpass = '"' .. string.sub(data,dot+1) .. '"'
      conn = env:connect('LUADB', 'root', 'Kolokolq11')
      query = conn:execute('INSERT INTO Users VALUES(' .. newlogin .. ',' .. newpass ..');')
      conn:close()
      server:send('002',ip)
      query = nil
      fail = nil
      end
      
    if(pheader == '003') then
      message = data
      if client_id[ip] ~= nil then
        print('recieved chat messgage : ' .. message .. ' from ' .. client_id[ip])
      end
      chat[#chat+1] = message
      if client_id[ip] ~= nil then
        server:send('004' .. client_id[ip] .. data)
      else
        print('WARNING client_id[' .. ip .. '] is nil')
      end
    end 

        
      message = nil
    end

    
  function onDisconnect(ip, port)
    online = online - 1
    client_name[client_id[ip]] = nil
    client_id[ip] = nil
    server:send('007' .. client_id[ip])
  end
  
  server = lube.server(3557)
  server:setCallback(onReceive, onConnect, onDisconnect)
  server:setHandshake("Hi!")
  print("initialized server")
  
  function love.update(dt)
    time = time + 1
    server:update(dt)
  end
  function love.draw()
  end
  function love.keypressed(k)
    if k=='escape' then
      netTest:gotoState('Menu')
    end
  end
  end
function Server:exitState()
  --TODO: Server EXIT CODE
  print("Exiting server")
end
