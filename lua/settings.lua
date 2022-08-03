require('editorconfig').properties.foo = function(bufnr, val)
    vim.b[bufnr].foo = val
end

local cmd = vim.cmd             -- execute Vim commands
local exec = vim.api.nvim_exec  -- execute Vimscript
local g = vim.g                 -- global variables
local opt = vim.opt             -- global/buffer/windows-scoped options
-- Направление перевода с русского на английский
g.translate_source = 'ru'
g.translate_target = 'en'

-- Конфиг ale + eslint
g.ale_fixers = {
    javascript = { 'eslint' },
}
g.ale_sign_error = '$'
g.ale_sign_warning = '!'
g.ale_fix_on_save = 1
g.ale_lint_on_save = 1
-- Автокомплит
g.ale_completion_enabled = 1
g.ale_completion_autoimport = 1
-- Запуск линтера, только при сохранении
g.ale_lint_on_text_changed = 'never'
g.ale_lint_on_insert_leave = 0
g.syntastic_yaml_checkers = {'yamllint'}
-- -- Change these if you want
--g.signify_sign_add               = '+'
--g.signify_sign_delete            = '_'
--g.signify_sign_delete_first_line = '‾'
--g.signify_sign_change            = '~'

-- -- I find the numbers disctracting
-- g.signify_sign_show_count = 0
-- g.signify_sign_show_text = 1

-----------------------------------------------------------
-- Главные
-----------------------------------------------------------
opt.colorcolumn = '120'             -- Разделитель на 140 символов
opt.cursorline = true               -- Подсветка строки с курсором
opt.spelllang= { 'en_us', 'ru' }    -- Словари рус eng
opt.number = true                   -- Включаем нумерацию строк
opt.relativenumber = true           -- Вкл. относительную нумерацию строк
opt.so = 999                        -- Курсор всегда в центре экрана
opt.undofile = true                 -- Возможность отката назад
opt.splitright = true               -- vertical split вправо
opt.splitbelow = true               -- horizontal split вниз
-----------------------------------------------------------
-- Цветовая схема
-----------------------------------------------------------
opt.termguicolors = true      --  24-bit RGB colors
cmd 'colorscheme onedark'
-----------------------------------------------------------
-- Табы и отступы
-----------------------------------------------------------
cmd([[
filetype indent plugin on
syntax enable
]])
opt.expandtab = true       -- use spaces instead of tabs
opt.shiftwidth = 4         -- shift 4 spaces when tab
opt.tabstop = 4            -- 1 tab == 4 spaces
opt.smartindent = true     -- autoindent new lines

-----------------------------------------------------------
-- Различные плюшки из старого конфига
-----------------------------------------------------------
opt.fileencoding = 'utf-8' -- The encoding written to file
opt.encoding = 'utf-8'     -- The encoding displayed
opt.pumheight = 10         -- Makes popup menu smaller
opt.autoindent = true      -- Good auto indent
-- g.onedark_termcolors = 256
-- opt.laststatus = 0         -- Always display the status line
-- opt.cursorline = true -- Enable highlighting of the current line
-- opt.background = 'dark' -- tell vim what the background color looks like
opt.showtabline = 2 -- Always show tabs
-- opt.clipboard = 'unnamedplus' -- Copy paste between vim and everything else
-- opt.updatetime=300 -- Faster completion
-- opt.timeoutlen=500 -- By default timeoutlen is 1000 ms


-- don't auto commenting new lines
cmd [[ au BufEnter * set fo-=c fo-=r fo-=o ]]
-- remove line lenght marker for selected filetypes
cmd [[ autocmd FileType text,markdown,html,xhtml,javascript setlocal cc=0 ]]
-- 2 spaces for selected filetypes
cmd [[ autocmd FileType xml,html,xhtml,css,scss,javascript,lua,yaml,htmljinja setlocal shiftwidth=2 tabstop=2 ]]
-- 4 spaces for selected filetypes
cmd [[ autocmd FileType go,sh,py setlocal shiftwidth=4 tabstop=4 ]]
-- С этой строкой отлично форматирует html файл, который содержит jinja2
cmd[[ autocmd BufNewFile,BufRead *.html set filetype=htmldjango ]]

-----------------------------------------------------------
-- Полезные фишки
-----------------------------------------------------------
-- Запоминает где nvim последний раз редактировал файл
cmd [[ autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif ]]


-----------------------------------------------------------
-- Установки для плагинов
-----------------------------------------------------------
-- Blamer
g.blamer_enabled = 1
g.blamer_delay = 200
g.blamer_date_format = '%y-%m-%d %H:%M'

-- Disable EditorConfig for a specific filetype - gitcommit
cmd [[ au FileType gitcommit let b:EditorConfig_disable = 1 ]]

-- LSP settings
local lsp_installer = require("nvim-lsp-installer")

-- nvim_comment
local nvim_comment = require('nvim_comment')
nvim_comment.setup(
{
    -- Linters prefer comment and line to have a space in between markers
    marker_padding = true,
    -- should comment out empty or whitespace only lines
    comment_empty = false,
    -- trim empty comment whitespace
    comment_empty_trim_whitespace = false,
    -- Should key mappings be created
    create_mappings = true,
    -- Normal mode mapping left hand side
    line_mapping = "gcc",
    -- Visual/Operator mapping left hand side
    operator_mapping = "gc",
    -- text object mapping, comment chunk,,
    comment_chunk_text_object = "ic",
    -- Hook function to call before commenting takes place
    hook = nil
}
)


-- nvim-cmp supports additional completion capabilities
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
vim.o.completeopt = 'menuone,noselect'
-- luasnip setup
local luasnip = require 'luasnip'
-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
        { name = 'buffer', options = {
            get_bufnrs = function()
                return vim.api.nvim_list_bufs()
            end
        },
    },
},
}


require("telescope").load_extension "file_browser"
require('telescope').load_extension('ctags_outline')
require('telescope').setup{
    extensions = {
        ctags_outline = {
            --ctags option
            ctags = {'gotags'},
            --ctags filetype option
            ft_opt = {
                vim = '--vim-kinds=fk',
                lua = '--lua-kinds=fk',
            },
        },
    },
}

-- git
cmd [[ set statusline+=%{get(b:,'gitsigns_status','')} ]]

--go
require('go').setup({

    disable_defaults = false, -- true|false when true set false to all boolean settings and replace all table
    -- settings with {}
    go='go', -- go command, can be go[default] or go1.18beta1
    goimport='gopls', -- goimport command, can be gopls[default] or goimport
    fillstruct = 'gopls', -- can be nil (use fillstruct, slower) and gopls
    gofmt = 'gofumpt', --gofmt cmd,
    max_line_len = 128, -- max line length in golines format, Target maximum line length for golines
    tag_transform = false, -- can be transform option("snakecase", "camelcase", etc) check gomodifytags for details and more options
    gotests_template = "", -- sets gotests -template parameter (check gotests for details)
    gotests_template_dir = "", -- sets gotests -template_dir parameter (check gotests for details)
    comment_placeholder = '' ,  -- comment_placeholder your cool placeholder e.g. ﳑ       
    icons = {breakpoint = '🧘', currentpos = '🏃'},  -- setup to `false` to disable icons setup
    verbose = false,  -- output loginf in messages
    lsp_cfg = false, -- true: use non-default gopls setup specified in go/lsp.lua
    -- false: do nothing
    -- if lsp_cfg is a table, merge table with with non-default gopls setup in go/lsp.lua, e.g.
    --   lsp_cfg = {settings={gopls={matcher='CaseInsensitive', ['local'] = 'your_local_module_path', gofumpt = true }}}
    lsp_gofumpt = false, -- true: set default gofmt in gopls format to gofumpt
    lsp_on_attach = nil, -- nil: use on_attach function defined in go/lsp.lua,
    --      when lsp_cfg is true
    -- if lsp_on_attach is a function: use this function as on_attach function for gopls
    lsp_keymaps = true, -- set to false to disable gopls/lsp keymap
    lsp_codelens = true, -- set to false to disable codelens, true by default, you can use a function
    -- function(bufnr)
    --    vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>F", "<cmd>lua vim.lsp.buf.formatting()<CR>", {noremap=true, silent=true})
    -- end
    -- to setup a table of codelens
    lsp_diag_hdlr = true, -- hook lsp diag handler
    -- virtual text setup
    lsp_diag_virtual_text = { space = 0, prefix = "" },
    lsp_diag_signs = true,
    lsp_diag_update_in_insert = false,
    lsp_document_formatting = true,
    -- set to true: use gopls to format
    -- false if you want to use other formatter tool(e.g. efm, nulls)
    lsp_inlay_hints = {
        enable = true,
        -- Only show inlay hints for the current line
        only_current_line = false,
        -- Event which triggers a refersh of the inlay hints.
        -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
        -- not that this may cause higher CPU usage.
        -- This option is only respected when only_current_line and
        -- autoSetHints both are true.
        only_current_line_autocmd = "CursorHold",
        -- whether to show variable name before type hints with the inlay hints or not
        -- default: false
        show_variable_name = true,
        -- prefix for parameter hints
        parameter_hints_prefix = " ",
        show_parameter_hints = true,
        -- prefix for all the other hints (type, chaining)
        other_hints_prefix = "=> ",
        -- whether to align to the lenght of the longest line in the file
        max_len_align = false,
        -- padding from the left if max_len_align is true
        max_len_align_padding = 1,
        -- whether to align to the extreme right or not
        right_align = false,
        -- padding from the right if right_align is true
        right_align_padding = 6,
        -- The color of the hints
        highlight = "Comment",
    },
    gopls_cmd = nil, -- if you need to specify gopls path and cmd, e.g {"/home/user/lsp/gopls", "-logfile","/var/log/gopls.log" }
    gopls_remote_auto = true, -- add -remote=auto to gopls
    dap_debug = true, -- set to false to disable dap
    dap_debug_keymap = true, -- true: use keymap for debugger defined in go/dap.lua
    -- false: do not use keymap in go/dap.lua.  you must define your own.
    -- windows: use visual studio keymap
    dap_debug_gui = true, -- set to true to enable dap gui, highly recommand
    dap_debug_vt = true, -- set to true to enable dap virtual text
    build_tags = "tag1,tag2", -- set default build tags
    textobjects = true, -- enable default text jobects through treesittter-text-objects
    test_runner = 'go', -- one of {`go`, `richgo`, `dlv`, `ginkgo`}
    verbose_tests = true, -- set to add verbose flag to tests
    run_in_floaterm = false, -- set to true to run in float window. :GoTermClose closes the floatterm
    -- float term recommand if you use richgo/ginkgo with terminal color

    trouble = false, -- true: use trouble to open quickfix
    test_efm = false, -- errorfomat for quickfix, default mix mode, set to true will be efm only
    luasnip = false, -- enable included luasnip snippets. you can also disable while add lua/snips folder to luasnip load
    --  Do not enable this if you already added the path, that will duplicate the entries
})

local lsp_installer_servers = require'nvim-lsp-installer.servers'

local server_available, requested_server = lsp_installer_servers.get_server("gopls")
if server_available then
    requested_server:on_ready(function ()
        local opts = require'go.lsp'.config() -- config() return the go.nvim gopls setup
        requested_server:setup(opts)
    end)
    if not requested_server:is_installed() then
        -- Queue the server to be installed
        requested_server:install()
    end
end

vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').gofmt() ]], false)
vim.api.nvim_exec([[ autocmd BufWritePre (InsertLeave?) <buffer> lua vim.lsp.buf.formatting_sync(nil,500) ]], false)
vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').goimport() ]], false)

vim.notify = require("notify")
