SLASH_DELETESOULSHARDS1, SLASH_DELETESOULSHARDS2 = '/dss', '/deletesoulshards'
SLASH_DELETESOULSHARDSSTATUS1, SLASH_DELETESOULSHARDSSTATUS2 = '/dssstatus', '/deletesoulshardsstatus'
SLASH_DELETESOULSHARDSMAX1, SLASH_DELETESOULSHARDSMAX2, SLASH_DELETESOULSHARDSMAX3 = '/dssmax', '/deletesoulshardsmax', '/deletesoulshardsmaximum'



local function OnEvent(self, event, ...)
	if event == "ADDON_LOADED" then
		DeleteSoulShards_InitVars()
	end
	
	local shardsToDelete = GetItemCount(6265) - DeleteSoulShards['MaxAmount']
    
    for x = 0,4 do
        
        for y = 1, GetContainerNumSlots(x) do
            
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

	if tonumber(msg) then
		local intMsg = math.floor(tonumber(msg))
		
		if intMsg >= 0 and intMsg <= 32 then
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

function DeleteSoulShards_InitVars()
	if DeleteSoulShards == nil or type(DeleteSoulShards) ~= "table" then
		DeleteSoulShards = {}
	end
	if not DeleteSoulShards['MaxAmount'] or DeleteSoulShards['MaxAmount'] == nil or type(DeleteSoulShards['MaxAmount']) ~= "number" then
		DeleteSoulShards['MaxAmount'] = 32
	end
end


local f = CreateFrame("Frame")
f:RegisterEvent("BAG_UPDATE")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", OnEvent)