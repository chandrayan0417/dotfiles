return {
	{
		"vimpostor/vim-tpipeline",
		dependencies = "nvim-lualine/lualine.nvim",
		config = function()
			vim.cmd([[
        set laststatus=2
        let g:tpipeline_autoembed = 1
        let g:tpipeline_preservebg = 1
      ]])
		end,
	},
}
