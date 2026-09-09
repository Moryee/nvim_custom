local constants = require('constants')


vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'avante.nvim' and (kind == 'install' or kind == 'update') then
      -- Use `./build.sh` to use prebuilt libraries
      vim.system({ 'make', 'BUILD_FROM_SOURCE=false' }, { cwd = ev.data.path }):wait()
    end
  end,
})

vim.pack.add {
  {
    src = 'https://github.com/yetone/avante.nvim',
    version = 'main', -- default
  },

  -- Deps
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',

  -- Optional deps
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
  'https://github.com/hrsh7th/nvim-cmp',
  'https://github.com/nvim-tree/nvim-web-devicons', -- since you use fzf-lua!
  'https://github.com/HakonHarnes/img-clip.nvim',
  'https://github.com/zbirenbaum/copilot.lua',
  'https://github.com/folke/snacks.nvim', -- for modern input UI
}



-- Config customizations
require('avante').setup {
  mode = 'legacy',
  debug = false,
  log_level = vim.log.levels.DEBUG,
  behaviour = {
    auto_suggestions = false,
    auto_set_keymaps = true,
    auto_add_current_file = false,
    auto_approve_tool_permissions = false,
    confirmation_ui_style = 'inline_buttons',
    enable_fastapply = false,
  },
  windows = {
    ask = {
      start_insert = false,
    },
  },
  -- ~1243 tokens
  override_prompt_dir = constants.paths.avante_base_prompts_dir,

  -- custom change at ~/.local/share/nvim_custom/site/pack/core/opt/avante.nvim/lua/avante/llm.lua
  ignore_extra_prompts = true,

  -- Other required fields
  acp_providers = {},
  rules = {},
  rag_service = {}, ---@diagnostic disable-line: missing-fields
  web_search_engine = {},
  prompt_logger = {}, ---@diagnostic disable-line: missing-fields
  disabled_tools = {},
  custom_tools = {},
  slash_commands = {},
  shortcuts = {},
  ask_opts = {},

  -- Openrouter as default provider
  provider = 'openrouter',

  -- Custom OpenRouter provider
  providers = {
    openrouter = {
      __inherited_from = 'openai',
      endpoint = 'https://openrouter.ai/api/v1',
      api_key_name = 'OPENROUTER_API_KEY',
      model = '@preset/coding-preset',
      disable_tools = true,
      -- TODO: add automatic git diff append to latest message
      -- - Append at the start of the system prompt =commit to fix it for the whole chat
      parse_curl_args = function(opts, prompt_opts)
        local curl_args = require('avante.providers').openai.parse_curl_args(opts, prompt_opts)
        if curl_args and curl_args.body and curl_args.body.messages then
          local msgs = curl_args.body.messages
          local last_content = msgs[#msgs].content
          local text = type(last_content) == "string" and last_content or (type(last_content) == "table" and last_content[1].text or "")

          if text:find(constants.ai_custom_commands.commit) then
            local file = io.open(constants.ai_custom_prompts.commit_message, "r")
            if file then
              local content = file:read("*a")
              file:close()
              if msgs[1] then msgs[1].content = content end
              vim.notify("Commit prompt applied!", vim.log.levels.INFO, { title = "Avante" })
            end
          end
        end
        return curl_args
      end,
    },
  },
}
