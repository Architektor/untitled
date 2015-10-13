

function onReceive(data)

     local pheader = string.sub(data,1,3)
     local data = string.sub(data,4)
     print('RECIEVED ' .. data .. ' WITH HEADER ' .. pheader .. ' FROM SERVER')
     
      if(pheader == '000') then
        print('auth failed or user already exists')
        backtoMenu()
      end
      if(pheader == '001') then
        print('login is free')
        local loginfree = true
      end
      if(pheader == '002') then
        print('User ' .. login .. ' registered')
      end
      if(pheader == '003') then
        print('auth passed')
        netTest:gotoState('Client')
      end
      if(pheader == '004') then
        local sender = string.sub(data,1,5)
        local message = string.sub(data, 6)
       -- print('new message ' .. message .. ' from ' .. client_name[sender]) 
        if sender == '10000' then
          chat[#chat+1] = "System message : " .. message
        else
          chat[#chat+1] = client_name[sender] .. " : " .. message
        end
      end
      if(pheader  == '005') then
        local newid = string.sub(data,1,5)
        local newname = string.sub(data,6)
        print('new client with id ' .. newid .. ' and name ' .. newname)
        client_name[newid] = newname
        clients[#clients+1] = newname
        print('clients online')
        for i=1,#clients do
          print(clients[i])
          end
      end
      if(pheader == '006') then
       print('server sent some worlddata')
       print('data')
       local sep = string.find(data,'|')
       
      end
      if(pheader == '007') then
        --print(data .. " disconnected")
        for i=1,#clients do
          if clients[i] == data then
            clients[i] = ''
          end
        end
      end
    end