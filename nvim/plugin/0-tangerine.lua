local function bootstrap(url)
	local name = url:gsub(".*/", "")
	local path = vim.fn.stdpath([[data]]) .. "/site/pack/packer/start/" .. name

	if vim.fn.isdirectory(path) == 0 then
		print(name .. ": installing in data dir...")
		vim.fn.system({ "git", "clone", "--depth", "1", url, path })
		vim.cmd([[redraw]])
		print(name .. ": finished installing")
		return true
	end
end

local tangerine_bootstrap = bootstrap("https://github.com/udayvir-singh/tangerine.nvim")
bootstrap("https://github.com/udayvir-singh/hibiscus.nvim")

require("tangerine").setup({
  target = vim.fn.stdpath [[data]] .. "/tangerine",
	rtpdirs = { "compiler", "ftplugin" },
	compiler = {
		hooks = { "onsave", "oninit" },
	},
	eval = {
		luafmt = function()
			return "/opt/homebrew/bin/stylua"
		end,
	},
})
if tangerine_bootstrap then
	_G.tangerine.api.compile.all()
end
