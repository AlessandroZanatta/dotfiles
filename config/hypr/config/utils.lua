local M = {}

function M.is_work_laptop()
	local monitors = hl.get_monitors()
	local is_work = false

	for _, mon in ipairs(monitors) do
		-- Explicitly match your work panel description
		if mon.description and string.find(mon.description, "BOE 0x0DDE") then
			is_work = true
			break
		end
	end
	return is_work
end

function M.has_external_monitor()
	local monitors = hl.get_monitors()
	local has_external = false

	for _, mon in ipairs(monitors) do
		-- Explicitly match your work panel description
		if mon.description and string.find(mon.description, "Dell Inc. DELL S2725DSM 2LKM0C4") then
			has_external = true
			break
		end
	end
	return has_external
end

return M
