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

The GitHub Actions workflow (`.github/workflows/validate.yml`) builds the devcontainer image and mounts the repo into it. You can reproduce this locally in two ways.

### Option 1 — Direct Docker (recommended for this config)

The most reliable local approach, since the workflow uses Docker-in-Docker internally:

```bash
# Build the devcontainer image
docker build -f .devcontainer/Dockerfile -t nvim-config:ci .

# Run the full validation suite
docker run --rm \
  -e CI=true \
  -v "$(pwd):/home/dev/.config/nvim:ro" \
  nvim-config:ci \
  bash /home/dev/.config/nvim/test/ci_validate.sh
```

The `-e CI=true` flag skips heavy binary downloads (LSP servers, DAP adapters) so the run completes in under 5 minutes.

### Option 2 — [act](https://github.com/nektos/act)

[act](https://github.com/nektos/act) runs GitHub Actions workflows locally using Docker. Install it via your package manager, then:

```bash
# Run the validate job (mirrors what GitHub runs on push/PR)
act push -j validate
```

> **Note:** Because the workflow itself uses `docker/build-push-action`, `act` requires Docker-in-Docker. If the build step fails, fall back to Option 1 above.
