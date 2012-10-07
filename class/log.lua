Log = class("Log")
function Log:initialize(surface)
    self.messages = { "", "" }
    self.maxDisplayedMessages = 5
    self.surface = surface
end

function Log:print(string)
    table.insert(self.messages, string)
end


function Log:showMessages()
    local x = 10
    for i = 1, #self.messages do
        local y = self.surface.h - (#self.messages - i + 1) * LINE_HEIGHT
        love.graphics.print(self.messages[i], x, y)
    end
end