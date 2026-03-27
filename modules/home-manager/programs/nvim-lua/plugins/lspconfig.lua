return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			-- LSP Server Settings
			-- Sets the default configuration for an LSP client (or all clients if the special name "*" is used).
			---@alias lazyvim.lsp.Config vim.lsp.Config|{mason?:boolean, enabled?:boolean, keys?:LazyKeysLspSpec[]}
			---@type table<string, lazyvim.lsp.Config|boolean>
			servers = {
				nil_ls = {},
				nixd = {},
				pyrefly = {
					settings = {
						python = {
							pyrefly = {
								displayTypeErrors = "force-on",
							},
						},
					},
				},
				ts_ls = {},
				biome = {},
				astro = {},
				docker_compose_language_service = {},
				dockerls = {},
				taplo = {},
				tflint = {},
				yamlls = {},
				systemd_ls = {
					filetypes = { "systemd", "container" },
				},
				terraformls = {},
			},
		},
	},
}
