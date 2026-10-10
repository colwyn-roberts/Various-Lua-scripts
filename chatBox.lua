local chatBox = peripheral.find("chatBox")

local message = {}
    message.target = "Squid_Pig"
    message.title = "You are not Safe here"
    message.textuser = "!!!"
    message.text = ""

chatBox.sendToastToPlayer(message.text,message.title,message.target,message.textuser)
chatBox.sendMessageToPlayer(".",message.target,"Herobrine")