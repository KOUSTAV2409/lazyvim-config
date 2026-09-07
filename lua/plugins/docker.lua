-- Docker: avoid dual LSP on compose YAML (yamlls + docker_compose).
-- Completions for compose stay on docker_compose_language_service.

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        dockerls = {
          flags = { debounce_text_changes = 400 },
        },
        docker_compose_language_service = {
          flags = { debounce_text_changes = 400 },
        },
        yamlls = {
          -- Drop compose so docker_compose LS owns those buffers
          filetypes = { "yaml", "yaml.gitlab", "yaml.helm-values" },
        },
      },
    },
  },
}
