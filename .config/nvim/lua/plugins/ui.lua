return {
	"snacks.nvim",
	opts = {
		image = {
			enabled = true,
			doc = {
				-- Personally I set this to false, I don't want to render all the
				-- images in the file, only when I hover over them
				-- render the image inline in the buffer
				-- if your env doesn't support unicode placeholders, this will be disabled
				-- takes precedence over `opts.float` on supported terminals
				inline = false,
				-- only_render_image_at_cursor = vim.g.neovim_mode == "skitty" and false or true,
				-- render the image in a floating window
				-- only used if `opts.inline` is disabled
				float = true,
				-- Sets the size of the image
				max_width = 60,

				max_height = 30,
				-- Apparently, all the images that you preview in neovim are converted
				-- to .png and they're cached, original image remains the same, but
				-- the preview you see is a png converted version of that image
				--
				-- Where are the cached images stored?
				-- This path is found in the docs
				-- :lua print(vim.fn.stdpath("cache") .. "/snacks/image")
				-- For me returns `~/.cache/neobean/snacks/image`
				-- Go 1 dir above and check `sudo du -sh ./* | sort -hr | head -n 5`
			},
		},
		dashboard = {
			preset = {
				pick = function(cmd, opts)
					return LazyVim.pick(cmd, opts)()
				end,
				header = [[
   ██████╗ ██╗  ██╗ ██╗███████╗
  ██╔═████╗██║  ██║███║╚════██║
  ██║██╔██║███████║╚██║    ██╔╝
  ████╔╝██║╚════██║ ██║   ██╔╝ 
  ╚██████╔╝     ██║ ██║   ██║  
 ╚═════╝      ╚═╝ ╚═╝   ╚═╝ ]],
        -- stylua: ignore
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
			},
		},
	},
}
