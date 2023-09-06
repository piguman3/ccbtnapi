local api = {}
objs = {}

btnmeta = {
    __index = {
        h=0,
        w=0,
        fg=colors.black,
        bg=colors.white,
        bg2=colors.gray,
        text="",
        draw=function(self,term)
            term.setCursorPos(self.x, self.y)

            -- Draw button

            local clr, clr2 = term.getBackgroundColor(), term.getTextColor()
            if self.bg then
                term.setBackgroundColor(self.bg)
            end
            term.setTextColor(self.fg)
            term.write(self.text)
            term.setBackgroundColor(clr)
            term.setTextColor(clr2)
        end
    }
}

labelmeta = {
    __index = {
        fg=colors.white,
        bg=colors.black,
        text="",
        draw=function(self,term)
            term.setCursorPos(self.x, self.y)

            -- Draw button

            local clr, clr2 = term.getBackgroundColor(), term.getTextColor()
            term.setBackgroundColor(self.bg)
            term.setTextColor(self.fg)
            term.write(self.text)
            term.setBackgroundColor(clr)
            term.setTextColor(clr2)
        end
    }
}

function api.newBtn(txt, x, y, func, bg, bg2, fr, w, h, param, cntrX, cntrY, draw)
    local t = { x = x, y = y, h = h, w = w, fg = fg, bg = bg, bg2 = bg2, text = txt, func = func, draw = draw, param = param, type = "button"}

    if t.w==nil then
        t.w = string.len(txt)-1
    end

    if cntrX then
        local w, h = term.getSize()
        if cntrY then
            t.x = math.floor((w / 2) - (txt:len() / 2)) + 1
            t.y = math.floor(h / 2)
        else
            t.x = math.floor((w / 2) - (txt:len() / 2)) + 1
            t.y = y
        end
    end

    setmetatable(t, btnmeta)
    table.insert(objs, t)
    return t
end

function api.newLabel(txt, x, y, bg, fr, w, h, cntrX, cntrY, draw)
    local t = { x = x, y = y, fg = fg, bg = bg, text = txt, draw = draw, type = "label"}

    if t.w==nil then
        t.w = string.len(txt)-1
    end

    if cntrX then
        local w, h = term.getSize()
        if cntrY then
            t.x = math.floor((w / 2) - (txt:len() / 2)) + 1
            t.y = math.floor(h / 2)
        else
            t.x = math.floor((w / 2) - (txt:len() / 2)) + 1
            t.y = y
        end
    end

    setmetatable(t, labelmeta)
    table.insert(objs, t)
    return t
end

function api.newBar() end

function api.check(but, mx, my) if (mx >= but.x) and (mx <= but.x + but.w) and (my >= but.y) and (my <= but.y + but.h) then return true else return false end end

function api.update(draw)
    local _, _, xPos, yPos = os.pullEvent("monitor_touch")
    for k,obj in pairs(objs) do
        if obj.type == "button" then
            if api.check(obj, xPos, yPos) then
                --Button press graphic
                if obj.bg2 then
                    local old = obj.bg
                    obj.bg = obj.bg2
                    draw()
                    sleep()
                    obj.bg = old
                end
                if obj.func then
                    obj:func()
                end
            end
        end
    end
    sleep()
end

function api.autoUpdate()
    while true do
        api.update()
    end
end

return api