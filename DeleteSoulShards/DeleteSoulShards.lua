--creates a Namespace so i can reference f in OnEvent
dssns = {}

SLASH_DELETESOULSHARDS1, SLASH_DELETESOULSHARDS2 = '/dss', '/deletesoulshards'
SLASH_DELETESOULSHARDSSTATUS1, SLASH_DELETESOULSHARDSSTATUS2 = '/dssstatus', '/deletesoulshardsstatus'
SLASH_DELETESOULSHARDSMAX1, SLASH_DELETESOULSHARDSMAX2, SLASH_DELETESOULSHARDSMAX3 = '/dssmax', '/deletesoulshardsmax', '/deletesoulshardsmaximum'


--this gets called, when one of the registered events fires
local function OnEvent(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == "DeleteSoulShards" then
	
			--initialize Variables on warlocks and trying to deactivate the addon on non-warlocks
		if select(2, UnitClass("player")) == "WARLOCK" then
			DeleteSoulShards_InitVars()
		else
			SLASH_DELETESOULSHARDS1, SLASH_DELETESOULSHARDS2 = nil
			SLASH_DELETESOULSHARDSSTATUS1, SLASH_DELETESOULSHARDSSTATUS2 = nil
			SLASH_DELETESOULSHARDSMAX1, SLASH_DELETESOULSHARDSMAX2, SLASH_DELETESOULSHARDSMAX3 = nil
			
			dssns.f:UnregisterEvent("BAG_UPDATE")
			dssns.f:UnregisterEvent("ADDON_LOADED")
			dssns.f:SetScript("OnEvent", nil)
		end

	end
	
	local shardsToDelete = GetItemCount(6265) - DeleteSoulShards['MaxAmount']
    
	--cycles through all bags
    for x = 0,4 do
        --cycles through all slots in that bag
        for y = 1, GetContainerNumSlots(x) do
            --if there are too many shards, it deletes 1, when it finds 1
            if (shardsToDelete > 0) then
                local l = GetContainerItemID(x,y)
                
                if l and l == 6265 then
                    PickupContainerItem(x,y)
                    DeleteCursorItem()
                    shardsToDelete = shardsToDelete - 1
                end
            end
        end
    end
	
end

function SlashCmdList.DELETESOULSHARDS(msg, editbox)
	print("Type '/dssmax NUMBER', to set the maximum amount of Soul Shards to keep. Type /dssstatus to see the value currently set - the default is 32.")
end

function SlashCmdList.DELETESOULSHARDSSTATUS(msg, editbox)
	print("Current maximum amount of Soul Shards: "..DeleteSoulShards['MaxAmount']..".")
end

function SlashCmdList.DELETESOULSHARDSMAX(msg, editbox)
	
	--checks if it was given a number and makes it an integer, if it had decimals. Then checks if the number makes sense >=0 and <=32
	if tonumber(msg) then
		local intMsg = math.floor(tonumber(msg))
		
		if intMsg >= 0 and intMsg <= 32 then
			--sets saved Variable value to new value
			DeleteSoulShards['MaxAmount'] = intMsg
			print("Maximum amount of Soul Shards set to: "..DeleteSoulShards['MaxAmount']..".")
			OnEvent()
		else
			print("Invalid input, please use a whole number between 0 and 32.")
		end
	else
		print("Invalid input, please use a whole number between 0 and 32.")
	end
	
end

--creates a table for values if there is none and sets the default Value of the 'MaxAmount', if there is none
function DeleteSoulShards_InitVars()
	if DeleteSoulShards == nil or type(DeleteSoulShards) ~= "table" then
		DeleteSoulShards = {}
	end
	if not DeleteSoulShards['MaxAmount'] or DeleteSoulShards['MaxAmount'] == nil or type(DeleteSoulShards['MaxAmount']) ~= "number" then
		DeleteSoulShards['MaxAmount'] = 32
	end
end

-- this has to be last, as functions need to be defined, before they can be referenced
dssns.f = CreateFrame("Frame")
dssns.f:RegisterEvent("BAG_UPDATE")
dssns.f:RegisterEvent("ADDON_LOADED")
dssns.f:SetScript("OnEvent", OnEvent)