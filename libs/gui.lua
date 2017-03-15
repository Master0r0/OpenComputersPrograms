local component = require("component");
local event = require("event");
local coroutine = require("coroutine");

local gui = {};

function gui.init(gGPU,gScreen,color)
    gui.screen = component.proxy(gScreen.address);
    if not gui.screen.isOn() then
        gui.screen.turnOn();
    end
    gui.screen.setPrecise(true);
    gui.gpu = component.proxy(gGPU.address);
    gui.gpu.bind(gui.screen.address);
    gui.w, gui.h = gui.gpu.getResolution();
    gui.defaultBackground = color;
    gui.gpu.setBackground(color);
    gui.gpu.fill(1,1,gui.w,gui.h," ");
    gui.buttons = {};
    gui.staticBars = {};
    gui.interBars = {};
    gui.setExitButton(true);
    gui.clear();
    gui.running = true;
end

function gui.setBackground(color)
    gui.gpu.setBackground(color);
    gui.gpu.fill(1,1,gui.w,gui.h," ");
end

function gui.clear()
    gui.gpu.setBackground(gui.defaultBackground);
    gui.gpu.fill(1,1,gui.w,gui.h," ");
end

function gui.draw(x,y,width,height,color,char)
    prevColor = gui.gpu.setBackground(color);
    gui.gpu.fill(x,y,width,height,char);
    gui.gpu.setBackground(prevColor);
end

function gui.drawTextBox(x,y,width,height,color,text,textColor)
    prevColor = gui.gpu.setBackground(color);
    gui.gpu.fill(x,y,width,height," ");
    textLength = #tostring(text);
    gui.write(x+((width/2)-textLength/2),y+(height/2),text,textColor);
    gui.gpu.setBackground(prevColor);
end

function gui.drawBar(x,y,width,height,barColor,backColor,showPerc,textColor)
    if(showPerc)then
        gui.draw(x,y,width,height,backColor," ");
        gui.draw(x+1,y+1,width-2,height-2,barColor," ");
        text = tostring("100").."%";
        textLength = #text;
        gui.write(x+((width/2)-textLength/2),y+(height/2),"100%",textColor);
    else
        gui.draw(x,y,width,height,backColor," ");
        gui.draw(x+1,y+1,width-2,height-2,barColor," ");
    end
end

function gui.write(x,y,text,color)
    prevColor = gui.gpu.setForeground(color);
    success = gui.gpu.set(x,y,tostring(text));
    gui.gpu.setForeground(prevColor);
    return success;
end

function gui.checkButtonsExe(x,y)
    for id,btn in pairs(gui.buttons) do
        if(x>=btn.x and x<=(btn.x+btn.width)) then
            if(y>=btn.y and tonumber(y)<=((btn.y-btn.height/2)+btn.height)) then
                btn.execute();
            end
        end
    end
end

function gui.updateButtons()
    for id,btn in pairs(gui.buttons) do
        btn.update();
    end
end

function gui.updateBars()
    for id,bar in pairs(gui.staticBars) do
        bar.update();
    end
end

function gui.setExitButton(enable)
    gui.exitButton = enable;
end

function gui.isExitButtonEnabled()
    return gui.exitButton;
end

function gui.createBar(x,y,width,height,barColor,backColor,showPerc,textColor,update)
    bar = {};
    bar.id = (#gui.staticBars)+1;
    bar.x = x;
    bar.y = y;
    bar.mWidth = width;
    bar.mHeight = height;
    bar.sX = x+1;
    bar.sY = y+1;
    bar.sWidth = width-2;
    bar.sHeight = height-2;
    bar.barColor = barColor;
    bar.backColor = backColor;
    bar.showPerc = showPerc;
    bar.perc = 100;
    bar.textColor = textColor;
    bar.update = update;
    bar.setUpdate = function(newUpdate)
        bar.update = newUpdate;
    end
    bar.redraw = function(self)
        gui.draw(self.x,self.y,self.mWidth,self.mHeight,0x000000," ");
        gui.draw(self.x,self.y,self.mWidth,self.mHeight,self.backColor," ");
        percWidth = (self.perc/100)*self.sWidth;
        gui.draw(self.sX,self.sY,percWidth,self.sHeight,self.barColor," ");
        if(self.showPerc)then
            text = tostring(math.floor(self.perc)).."%"
            textLength = #text;
            gui.write(x+((width/2)-textLength/2),y+(height/2),text,self.textColor);
        end 
    end
    gui.drawBar(x,y,width,height,barColor,backColor,showPerc,textColor);
    gui.staticBars[#gui.staticBars+1] = bar;
    return bar;
end

function gui.createButton(x,y,width,height,color,text,textColor,execute,update)
    button = {};
    button.id = (#gui.buttons)+1;
    button.x = x;
    button.y = y;
    button.width = width;
    button.height = height;
    button.color = color;
    button.text = text;
    button.textColor = textColor;
    button.setText = function(newText)
        button.text = newText;
    end
    button.execute = execute;
    button.setExecute = function(newExecute)
        button.execute = newExecute;
    end
    button.update = update;
    button.setUpdate = function(newUpdate)
        button.update = newUpdate;
    end
    button.redraw = function(self)
        gui.draw(self.x,self.y,self.width,self.height,0x000000," ");
        gui.drawTextBox(self.x,self.y,self.width,self.height,self.color,self.text,self.textColor);
    end
    button.debug = function(self)
        print(self.x,self.y,self.width,self.height,self.color,self.text,self.textColor);
    end
    gui.drawTextBox(x,y,width,height,color,text,textColor);
    gui.buttons[#gui.buttons+1] = button;
    return button;
end

function gui.getButtons()
    return gui.buttons;
end

function gui.getButton(id)
    for btnId,btn in pairs(gui.buttons)do
        if(id==btnId)then
            return btn;
        end
    end
end

function gui.getBars()
    return gui.staticBars;
end

function gui.getBar(id)
    for barId,bar in pairs(gui.staticBars)do
        if(id==barId)then
            return bar;
        end
    end
end

function gui.redraw()
    gui.clear();
    for btnId,btn in pairs(gui.buttons)do
        --print(btnId,btn);
        btn.redraw(btn);
    end
    for barId,bar in pairs(gui.staticBars)do
        bar.redraw(bar);
    end
end

function gui.getGPU()
    return gui.gpu;
end

function gui.run()
    if(gui.isExitButtonEnabled())then
        gui.createButton(1,1,5,3,0xFF0000,"X",0x000000,function() gui.running = false end,function() end);
    end
    tThread = coroutine.create(touch);
    uThread = coroutine.create(updates);
    while(gui.running)do
        if(coroutine.status(tThread)=="dead")then
            gui.running=false;
        end
        if(coroutine.status(uThread)=="dead")then
            gui.running=false;
        end
        coroutine.resume(tThread);
        coroutine.resume(uThread);
    end
end

touch = function()
    while(true)do
        print("EVT Loop");
        evtName, scrAddr, x, y, btn, player = event.pull(1,"touch");
        if(evtName)then
            gui.checkButtonsExe(x,y);
            gui.redraw();
        end
        coroutine.yield();
    end
end

updates = function()
    while(true)do
        print("UPD Loop");
        gui.updateButtons();
        gui.updateBars();
        coroutine.yield();
    end
end

return gui;
