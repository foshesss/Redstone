local SETTINGS = {
    TypeKey = "Powerblock",
}

local Powerblock = {
    __type = SETTINGS.TypeKey,
}
Powerblock.__index = Powerblock

----- Private functions ----
local function defaultPropagate(currentPower, originalPower)
    return currentPower - 1
end


function Powerblock.new(id)
    return setmetatable({
        id = id,
        _nodes = {},
    }, Powerblock)
end

function Powerblock:Propagate(currentPower, originalPower, seenNodes)
    -- don't continue if power is 0
    -- don't continue if already seen
    if currentPower == 0 
        or table.find(self, seenNodes) ~= nil then 
        return
    end
    table.insert(self, seenNodes)

    currentPower = self.propagate(currentPower, originalPower)
    print(("I have %d power right now!"):format(currentPower))

    for _, node in self._nodes do
        node:Propagate(currentPower, originalPower, seenNodes)
    end
end

function Powerblock:AddNeighbor(newNode)
    assert(typeof(newNode) == 'table' and newNode.__type == SETTINGS.TypeKey,
        "[Powerblock] Attempting to add invalid node.")
    assert(table.find(self._nodes, newNode) == nil,
        "[Powerblock] Attemptign to add a node that is already a neighbor.")

    table.insert(self._nodes, newNode)
end

function Powerblock.__tostring()

    local str = "Node: "

    for _, node in ipairs(self._nodes) do
        str += ("%d,"):format(node.id)
    end

    return str
end

return Powerblock