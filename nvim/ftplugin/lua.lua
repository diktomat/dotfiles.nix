if vim.g.lua_format == nil then
	vim.api.nvim_create_user_command("Format", "w | !stylua %", {})
end
-- if vim.g.lua_autoformat == nil then
-- 	vim.g.lua_autoformat = true
-- 	vim.api.nvim_create_autocmd("BufWritePre", {
-- 		pattern = "*.lua",
-- 		callback = function()
-- 			vim.cmd("%!stylua --stdin-filepath % -")
-- 		end,
-- 	})
-- end
