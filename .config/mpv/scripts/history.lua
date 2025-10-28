-- ~/.config/mpv/scripts/history.lua
local HOME = os.getenv("HOME")
local log_path = HOME .. "/.config/mpv/playback_history.log"
local last_file_path = HOME .. "/.config/mpv/last_played.txt"

-- Log every file you open
mp.register_event("file-loaded", function()
	local path = mp.get_property("path") or ""
	if path == "" then
		return
	end
	local title = mp.get_property("media-title") or path
	local date = os.date("%Y-%m-%d %H:%M:%S")

	-- append to playback history
	local f = io.open(log_path, "a")
	if f then
		f:write(string.format("[%s] %s (%s)\n", date, title, path))
		f:close()
	end

	-- save last played path
	local lf = io.open(last_file_path, "w")
	if lf then
		lf:write(path)
		lf:close()
	end
end)

-- When mpv starts idle (no file), try loading the last one
mp.register_event("idle", function()
	local f = io.open(last_file_path, "r")
	if not f then
		return
	end
	local path = f:read("*l")
	f:close()
	if not path or path == "" then
		return
	end

	mp.osd_message("Resuming last file: " .. path)
	mp.msg.info("Auto-loading last file: " .. path)
	mp.commandv("loadfile", path, "replace")
end)
