AIBasic = class("AIBasic")

function AIBasic:initialize(owner)
    self.owner = owner
end

function AIBasic:takeTurn(dt)
    if not self.moving then
        self.owner:randomMove()
    end
end
