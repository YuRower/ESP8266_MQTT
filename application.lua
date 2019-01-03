--an application.lua file that will hold our app code
local module = {}
m = nil
sda = 1
scl = 2
ls = 0
bh1750 = require("bh1750")
bh1750.init(sda, scl) 

local function send_lux()
print("----Publish to a Topic----")
bh1750.getlux(printlux)  
m:publish("myCourseWorkTopic/iot","Lux = "..ls.." lx",0,0)
end

local function register_myself()
   print("----Subscribe to a Topic----")
   m:subscribe("myCourseWorkTopic/iot",0,function(conn)
   m:publish("myCourseWorkTopic/iot" ,"Successfully subscribed to data endpoint",0,0)
    end)
end

local function mqtt_start()
   m = mqtt.Client(node.chipid(), 120,"username","password")   
   m:on("connect", function(conn) print("client connected") end)
   m:on("offline", function(conn) print("client offline") end)
   m:on("message", function(conn, topic, data) 
  --  print(topic .. ": " .. data)
      if data ~= nil then
        print(topic .. ": " .. data)
      end
    end)
    print("Connect to broker")
m:connect('test.mosquitto.org',1883,0,function(conn)  --  m:connect('iot.eclipse.org',1883,0,function(conn)
        register_myself()    
        tmr.stop(6)   
        tmr.alarm(6, 2000, 1, send_lux)
    end) 
end

function module.start()
print("app start")
  mqtt_start()
end
  function printlux(l)
   ls = string.format("%.2f", l/100)
  end 
return module
