local BuffsTable = {
    alert = true,
    removed = nil,
    added = nil,
    helpful = {},
    setRemoved = function(self, tb)
        self.remove = tb
    end,
    setAdded = function(self, tb)
        self.added = tb
    end,
    --  Should it generate its own new table?
    diff = function(self, new)
        local ai = {}
        local r = {}
        local newBuffs = {}
        for i, v in ipairs(self.helpful) do
            r[i] = v
            ai[v] = i
        end
        for i, v in ipairs(new) do
            if ai[v] ~= nil then
                table.remove(r, ai[v])
            else
                table.insert(newBuffs, v)
            end
        end
        self.removed = r
        self.added = newBuffs
        return r, newBuffs
    end,
    -- Print/Display Functions
    printTRemoved = function(self)
        print(removed, " Was removed!")
    end,
    printHelpful = function(self)
        for i, v in ipairs(self.helpful) do
            print(i, v)
        end
    end,
    printRemoved = function(self)
        print("Last Removed Buffs are:> ")
        for i, v in ipairs(self.removed) do
            print("[", i, "] : ", v)
        end
    end,
    printAdded = function(self)
        print("Last Added Buffs are:> ")
        for i, v in ipairs(self.added) do
            print("[", i, "] : ", v)
        end
    end
}

--  Should make it so the function does the return?
function ConstructBufflist()
    local retTable = {}
    local index = 1
    local Buff
    repeat
        buff = UnitAura("player", index, "HELPFUL")
        -- print(UnitAura('player', index , "HELPFUL"));
        -- print(buff);
        index = index + 1
        table.insert(retTable, buff)
    until (buff == nil)

    return retTable
end

BuffsTable.helpful = ConstructBufflist()
BuffsTable:printHelpful()

local MyFrame = CreateFrame("Frame", "", UIParent)
MyFrame:RegisterEvent("UNIT_AURA")
MyFrame:SetScript(
    "OnEvent",
    function(self, event, ...)
        if ... == "player" then
            print("!UNIT_AURA!")
            -- Get the new buffList
            local newBuffTable = ConstructBufflist()
            -- Get the lists of faded and new buffs
            BuffsTable:diff(newBuffTable)
            BuffsTable:printAdded()
            BuffsTable:printRemoved()
            BuffsTable.helpful = newBuffTable
        end
    end
)

function BagBuddy_OnLoad(self)
    SetPortraitToTexture(self.portrait, "Interface\\Icons\\INV_Misc_EngGizmos_30")
    self.items = {}
    for idx = 1, 24 do
        local item = CreateFrame("Button", "THP_Item" .. idx, self, "THPItemTemplate")
        self.items[idx] = item
        if idx == 1 then
            item:SetPoint("TOPLEFT", 40, -73)
        elseif idx == 7 or idx == 13 or idx == 19 then
            item:SetPoint("TOPLEFT", self.items[idx - 6], "BOTTOMLEFT", 0, -7)
        else
            item:SetPoint("TOPLEFT", self.items[idx - 1], "TOPRIGHT", 12, 0)
        end
    end
    -- Make the Frame Dragable
    -- MakeMovable(self);
end

function MakeMovable(frame)
    frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
end
