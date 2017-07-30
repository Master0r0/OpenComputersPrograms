# OpenComputersPrograms
A repo of all my minecraft OpenComputers programs and libraries

# GUI Lib
My GUI lib requires you to pass the gpu component and screen component id's in the init along with a background color.

To add a button:

<code>
    
    local component = require("component");
    local gui = require("gui");
    local screen = component.proxy("04c7ec61-b048-41ad-aa9c-83dbb302c169");
    local gpu = component.proxy("c482e7a3-5bd1-4d30-911a-3a4a16aae22a");
    gui.init(gpu,screen,0x000000);
    btn = gui.createButton(x:num,y:num,width:num,height:num,Background Color:hex,"Text":string,Text Color:hex,function() --[[ called on button press --]] end,function() --[[ called every cycle --]] end);
    gui.run();
    
</code>

To add a bar:

<code>
    
    local component = require("component");
    local gui = require("gui");
    local screen = component.proxy("04c7ec61-b048-41ad-aa9c-83dbb302c169");
    local gpu = component.proxy("c482e7a3-5bd1-4d30-911a-3a4a16aae22a");
    gui.init(gpu,screen,0x000000);
    bar = gui.createBar(x:num,y:num,width:num,height:nun,bar color:hex,background color:hex,display percentage:bool,text color:hex,function() --[[ called every cycle --]] end);
    gui.run();
    
</code>

# outputFunctions.lua
A program for spitting out the component data for any component into a txt file.
Args: ComponentName
Example: outputFunctions.lua transposer - creates a file in home/functions called transposer.txt
