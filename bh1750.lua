--BH1750 module for ESP8266 with nodeMCU
local M = {}
M.GY_30_address = 0x23
M.id = 0
M.l = 0
M.CMD = 0x10
M.init = false

function M.init(sda, scl)
    i2c.setup(M.id, sda, scl, i2c.SLOW)
    init = true
end

local function read_data(callback)
    i2c.start(M.id)
    i2c.address(M.id, M.GY_30_address, i2c.TRANSMITTER)
    i2c.write(M.id, M.CMD)
    i2c.stop(M.id)
    i2c.start(M.id)
    i2c.address(M.id, M.GY_30_address, i2c.RECEIVER)

    tmr.create():alarm(2000, 0, function(t)
        c = i2c.read(M.id, 2)
        i2c.stop(M.id)
        local UT = c:byte(1) * 256 + c:byte(2)
        M.l = (UT*1000/12)
        t = nil
        if callback then callback(M.l) end
    end)
end

function M.getlux(callthen)
    if (not M.init) then
        print("init() must be called before read.")
    else
        read_data(callthen)
    end
end

return M

 
