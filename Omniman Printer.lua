local monitor = peripheral.find("monitor")
monitor.setBackgroundColour(colours.orange)
monitor.clear()
monitor.setCursorPos(13,2)
monitor.setTextScale(0.5)
monitor.setPaletteColour(colours.blue,     0xffbb99)
monitor.setPaletteColour(colours.grey,     0xddeeee)
monitor.setPaletteColour(colours.lightGrey,0x881100)
monitor.setPaletteColour(colours.pink,     0xee5544)
local blackText = {"x",
                   "xxxxxxxxxxxxxxxxxxxxxxxxBBB",
                   "xxxxxxxxxxxxxxxxxxxxxxBBBBBBB",
                   "xxxxxxxxxxxxxxxxxxxxxBBBBBBBB",
                   "xxxxxxxxxxxxxxxxxxxxxBBBSSSGGGG",
                   "xxxxxxxxxxxxxxxxxxxxxxSSSSSGSGG",
                   "xxxxxxxxxxxxxxxxxxxxxxxSSSSSSSSS",
                   "xxxxxxxxxxxxxxxxxxxxxxxxBBSSRRRR",
                   "xxxxxxxxxxxxxxxxxxxxxxxxxSSSRRRRRRR",
                   "xxxxxxxxxxxxxxxxxxxxxxxxxxSRRRRRRRRRR",
                   "xxxxxxxxxxxxxxxxxxxxxxxxxRRRRRRRRRRRRRR",
                   "xxxxxxxxxxxxxxxxxGGGGGGGRRRRRRRRRRRRRRRR",
                   "xxxxxxxxxxxxxxxxGGGGGGGGRRRRRRRRRRRRRRRRR",
                   "xxxxxxxxxxxxxxxGGGGGGGGGRRRRRRRRRRRRRRRRRGGGGG",
                   "xxxxxxxxxxxxxxGGGGGGGGGRRRRRRRRRRRRRRRRRRGGGGGG",
                   "xxxxxxxxxxxxxxGGGGGGGGRRRRRRRRRRRRRRRRRRRGGGGGGG",
                   "xxxxxxxxxxxxxxGGGGGGGRRRRRRRRRRRRRRRRRRRRGGGGGGG",
                   "xxxxxxxxxxxxxxGGGGGGRRRRRRRRRRRRRRRRRRRRRRGGGGGG",
                   "xxxxxxxxxxxxxxGGGGGRRRRRRRRRRDRRRRRRRRRRRRRGGGGG",
                   "xxxxxxxxxxxxxxGGGRRRRRRRRRRRRDRRRDRRRRRRRRRRGGGG",
                   "xxxxxxxxxxxxRRRRRRRRRRRRRRRRDDRRDDRRRRRRRRRRRRGG",
                   "xxxxxxxxxxRRRRRRRRRRRRRRRRRRDDDDDDRRRRRRRRRRRRRR",
                   "xxxxxxxxxRRRRRRRRRRRRRRRRRRDDDDGGGRRRRRRRRRRRRRRR",
                   "xxxxxxxxDDDDDDRRRRRRRRRRRDDDDGGGGGGDRRRRRRRRRRRRRR",
                   "xxxxxxxDDDDGGDDDDDRRRRRDDDDGGGGGGGGGGRRRRRRRRRRRRR",
                   "xxxxxxxRRRGGGGGGDDDRRRRDDDGGGGGGGGGGGGGRRRRRGGGGGRR",
                   "xxxxxxxxRRRGGGGGGDDDDDDDDGGGGGGGGGGGxxxxRRRGGGGGGxR",
                   "xxxxxxxxRRRRGGGGGGDDDDDDGGGRRRRRRRRxxxxxRRRGGGGGG",
                   "xxxxxxxxRRRRGGGGGGxxxxxDDDDDDRRRRRRRxxxxRRRRGGGGG",
                   "xxxxxxxRRRRRDRRRRRRRRxxRRRRRRDDDRRRRRRRRRRRRRRRRR",
                   "xxxxxxxRRRRDRRRRRRRRRRRRRRLWLRRRDDRRRLLRRRRRRRRR",
                   "xxxxxxxRRRDRRRRRRRRRRRRRRRRLLRRRRRDRRRLLLRRRRRR",
                   "xxxxxxRRRDRRRRRRRRRRRRRRRRRRRLRRRRRDRRRRRRRRRRR",
                   "xxxxxRRRDRRRRRRRRRRRRRRRRRRRRRRRRRRRDRRRRRRRRRRR",
                   "xxxxxRRDRRRRRRRRRRRRRRRRRRRRRRRRRRRRDRRRRRRRRRRR",
                   "xxxxxRDRRRRRRRRRRRRRRDRRRRRRRRRRRRRRDRRRRRRRRRRR",
                   "xxxxxDDRRRRRRRRRRRRRRDDRRRRRRRRRRRRRDRRRRRRRRRRRR",
                   "xxxxxDDRRRRRRRRRRRRRRRDDRRRRRRRRRRRRDRRRRRRRRRRRR",
                   "xxxxxxDRRRRRRRGGRRRRRRDDRRRRRRRRRRDDRRRRRRRRGRRRR",
                   "xxxxxxRRRRRRRGGGGGGRRRDDRRRRRRRRDDRRRRRRRRRGGGRR",
                   "xxxxxxxRRRRRRGGGGGGGGRRDRRRRRRDDDRRRRRRRRRRGGGR",
                   "xxxxxxxxRRRRGGGGGGGGGGGDRRRRRDDxDDRRRRRRRRGGGG",
                   "xxxxxxxxxxRRGGGGGGGGGGGGDDDDDDxxxDDDDDDDDGGGG",
                   "xxxxxxxxxxxRGGGGGGGGGGGGGGGGxxxxxxxDDDDGGGG",
                   "xxxxxxxxxxxxxxGGGGGGGGGGGGGGGxxxGGGGGGGGGG",
                   "xxxxxxxxxxxxxxxxxxxxxGGGGGGGGxxxGGGGGGGG",
                   "xxxxxxxxxxxxxxxxxxxxxGGGGGGGxxxxGGGGGGGG",
                   "xxxxxxxxxxxxxxxxxxxxxGGGGGGxxxxxxGGGGGGGG",
                   "xxxxxxxxxxxxxxxxxxxxGGGGGGxxxxxxxxGGGGGGGG",--
                   "xxxxxxxxxxxxxxxxxxxGGGGGGxxxxxxxxxxGGGGGGGG",--
                   "xxxxxxxxxxxxxxxxxGGGGGGGGxxxxxxxxxxxGGGGGGGG",--
                   "xxxxxxxxxxxxxxxxGGGGGGGGGxxxxxxxxxxxGGGGGGGG",}--


local row = 1
while row < 79 do
    for c in blackText[row]:gmatch(".") do
        if (c == 'x') then
            monitor.setBackgroundColour(colours.orange)
            monitor.write(" ")
        elseif (c == 'B') then
            monitor.setBackgroundColour(colours.black)
            monitor.write(" ")
        elseif (c == 'S') then
            monitor.setBackgroundColour(colours.blue)
            monitor.write(" ")
        elseif (c == 'R') then
            monitor.setBackgroundColour(colours.red)
            monitor.write(" ")
        elseif (c == 'G') then
            monitor.setBackgroundColour(colours.grey)
            monitor.write(" ")
        elseif (c == 'D') then
            monitor.setBackgroundColour(colours.lightGrey)
            monitor.write(" ")
        elseif (c == 'W') then
            monitor.setBackgroundColour(colours.white)
            monitor.write(" ")
        elseif (c == 'L') then
            monitor.setBackgroundColour(colours.pink)
            monitor.write(" ")
        else
            monitor.write("X")
        end
        --sleep(0.001)
    end
    row = row+1
    monitor.setCursorPos(13,row)
end