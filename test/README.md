# Tests

The `test/` directory contains a headless CI suite that runs inside the devcontainer image. All steps are orchestrated by `ci_validate.sh`.

## Test scripts

- **`ci_install_plugins.lua`** — boots lazy.nvim in headless mode and runs `lazy.sync()`. Fails with exit code 1 if lazy.nvim is not loadable or the sync step errors.

- **`ci_validate_lsp.lua`** — verifies the native LSP layer loads without errors:
  - `require("lsp")` succeeds (global capabilities set via `vim.lsp.config('*', {...})`)
  - `vim.lsp.config["*"]` contains the expected capabilities table
  - Spot-checks that each `after/lsp/<name>.lua` file was sourced by asserting `vim.lsp.config[name].settings` is present for: `gopls`, `lua_ls`, `rust_analyzer`, `yamlls`, `helm_ls`, `eslint`, `ansiblels`, `jsonnet_ls`

- **`install_parsers.lua`** — installs all treesitter parsers via `TSInstall!` in headless mode, then polls until all `.so` files appear on disk (timeout: 5 min). Fails if any parser times out.
  - Parsers: `go`, `terraform`, `hcl`, `yaml`, `bash`, `gotmpl`, `dockerfile`, `jsonnet`, `python`, `markdown`, `markdown_inline`

- **`validate_treesitter.lua`** — loads each parser against a real source fixture and calls `parser:parse()`. Fails if any parser cannot be loaded or produces no parse trees.

## Test fixtures

| File | Parser(s) tested |
|------|-----------------|
| `fixtures/hello.go` | `go` |
| `fixtures/main.tf` | `terraform` |
| `fixtures/deployment.yaml` | `yaml` |
| `fixtures/script.sh` | `bash` |
| `fixtures/helm_deployment.yaml` | `gotmpl` |
| `fixtures/Dockerfile` | `dockerfile` |
| `fixtures/dashboard.jsonnet` | `jsonnet` |
| `fixtures/script.py` | `python` |
| `fixtures/README.md` | `markdown`, `markdown_inline` |

## Running locally

See [Running the CI pipeline locally](../README.md#running-the-ci-pipeline-locally) in the root README.
