-- Docker: compose files get yaml.docker-compose so compose LS attaches.
-- Avoid dual yamlls + compose on the same buffer.

vim.filetype.add({
  filename = {
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
    ["compose.yml"] = "yaml.docker-compose",
    ["compose.yaml"] = "yaml.docker-compose",
  },
  pattern = {
    [".*/docker%-compose%..*%.ya?ml"] = "yaml.docker-compose",
    [".*/compose%..*%.ya?ml"] = "yaml.docker-compose",
  },
})

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
