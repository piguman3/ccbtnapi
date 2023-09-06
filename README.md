# CC btn-api
A button API for lazy people

## Some example code
```lua
local api = require("btn-api")

local function _draw() --Let's you edit how stuff renders!
    mon.clear()
    for k,obj in pairs(objs) do
        obj:draw(mon)
    end
end

local numbs = {}
local numbLabel = api.newLabel("",1,1,nil) --There is support for labels and buttons

local function pressBtn(self)
    sleep()
    table.insert(numbs, self.param.number)
    print(numbLabel.text)
    numbLabel.text = table.concat(numbs,"") --Adds
end

for x=0,2 do
    for y=0,2 do
        api.newBtn(tostring(x+y*3+1),x*2+2,y+3,pressBtn,nil,nil,nil,nil,nil,{number=x+y*3+1}) --Creates a small 3x3 keypad
        --[[
          Buttons can have some text in them,
          a position, a function, colors, and
          even custom parameters!
        --]]
    end
end

while 1 do
    _draw()
    api.update(_draw)
end
```
