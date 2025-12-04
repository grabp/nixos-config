return {
	{
		"snacks.nvim",
		opts = {
			dashboard = {
				sections = {
					{ section = "header" },
					{
						icon = " ",
						title = "Recent Files",
						section = "recent_files",
						padding = 1,
						cwd = true,
					},
					{ icon = " ", title = "Projects", section = "projects", padding = 1 },
					{ section = "keys", padding = 1 },
					{
						icon = " ",
						title = "Git Status",
						section = "terminal",
						enabled = function()
							return Snacks.git.get_root() ~= nil
						end,
						cmd = "git status --short --branch --renames",
						height = 5,
						padding = 1,
						ttl = 5 * 60,
					},
					{ section = "startup" },
				},
				preset = {
					header = [[
██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗
██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║
██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║
██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║
███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║
╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝]],
				},
			},
		},
	},
}
