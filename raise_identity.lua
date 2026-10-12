-- Identity to change studio command bar to, from 1 to 13 (I think)
-- 8 is WebService, 2 is GameScript, 4 is CommandBar, etc
-- A breakdown can be found at https://github.com/Pseudoreality/Roblox-Identities
-- Additionally, you can use the CheckCapabilities.luau script from the Roblox-Identities repository to confirm that this script worked.
local IDENTITY = 8

local string_matches = AOBScan("65 6C 65 76 61 74 65 64 53 74 75 64 69 6F 50 6C 75 67 69 6E 00 00 00 00 63 6F 6D")
local lea_matches = AOBScan("48 8D 15 ?? ?? ?? ??")

if string_matches ~= nil and lea_matches ~= nil then
	local string_addr = getAddress(string_matches[0])

	for i = 0, lea_matches.Count - 1 do
		local instr = getAddress(lea_matches[i])
		local target = instr + 7 + readInteger(instr + 3, true)

		local bytes = readBytes(instr + 8, 2, true)

		if target == string_addr and bytes[1] == 0x8B and bytes[2] == 0xC7 then
			local cmdbar_instr_addr = instr - 74

			bytes = readBytes(cmdbar_instr_addr, 3, true)

			if bytes[1] == 0xB8 and bytes[3] == 0 then
				writeBytes(cmdbar_instr_addr, { 0xB8, IDENTITY })
			end
		end
	end
else
	print("Cannot find matches. Roblox probably broke something.")
end
