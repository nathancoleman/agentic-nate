# factory

A [Paperclip](https://github.com/paperclipai/paperclip) company package that defines my software factory. It follows the [Agent Companies spec](https://github.com/paperclipai/paperclip/blob/master/docs/companies/companies-spec.md), so any machine running Paperclip can import it.

| Agent | Model | Role |
| --- | --- | --- |
| `architect` | `claude-opus-5-5` | Breaks large efforts into an in-repo roadmap of demo-able stages and PR titles, opens a PR for it, and waits for my Paperclip board approval. |
| `developer` | `claude-sonnet-5-5` | Implements one approved stage at a time with the repo's coding and PR skills, then waits for me to test. |
| `reviewer` | `claude-opus-5-5` | Reviews each stage's PRs against the repo's skills before it reaches me. |

Go and Terraform are the defaults for backend services. Every agent adapts to the GitHub org it is working in through the `org-conventions` skill.

## Layout

```
factory/
├── COMPANY.md                 # company, goals, flow, and gates
├── .paperclip.yaml            # adapters, models, roles, env inputs
├── Makefile                   # deps, run, service, local-claude, sync, export
├── scripts/                   # deps, run, service, local-claude, sync-skills (not part of the import)
├── agents/<slug>/AGENTS.md    # per-agent instructions and skill list
└── skills/
    ├── org-conventions/       # package-local skill
    └── <slug>/                # copied from ../skills by make skills (gitignored)
```

`skills/` at the repo root is the only place skills are defined. `make skills` copies them into `factory/skills/`, and `run`, `import`, and `sync` call it for you. The copies are gitignored, so they're never committed and never edited by hand. Each import uses whatever is in your checkout, including uncommitted skill edits; run `make sync` to push skill changes into a running company. Symlinks won't work instead of copies, because Paperclip skips them when it reads a package.

Every repo skill is available to the company. An agent uses a skill only when the skill is listed in its `skills:`. `org-conventions` is the one skill defined only in this package, and it's committed.

The package lives in this subdirectory, not at the repo root, because Paperclip imports every `AGENTS.md` it finds as an agent, and the root `AGENTS.md` holds OpenCode instructions.

## Run it

```bash
make run
```

`make run` installs anything missing, starts Paperclip, and imports the factory as a new company if it isn't already there. It installs Homebrew, git, jq, gh, Go, Terraform, Node.js 24.11 or newer, Claude Code, and the Paperclip CLI. Press Ctrl-C to stop the server.

To install the tools without starting anything, or to preview what would be installed:

```bash
make deps
```

```bash
DRY_RUN=1 make deps
```

Authenticate `gh` (`gh auth login --insecure-storage`) and Claude Code once per machine; `make deps` warns if `gh` isn't logged in.

## Start Paperclip at login

On macOS, run Paperclip as a background service instead of keeping `make run` open:

```bash
make service
```

This registers Paperclip's login service and points it at a small launcher, `~/.paperclip/bin/paperclip-service`, that puts Homebrew on its PATH. Without it, the service gets launchd's bare PATH, so Paperclip can't find `claude` and agents can't find `gh`. `make run` sees the running service and only imports the company.

`paperclipai service install` and `paperclipai service restart` rewrite the service and drop the launcher. Restart with `make restart` instead, and run `make service` again after a Paperclip update reinstalls the service.

## Agents use this machine's gh and claude

Agents run on the `claude_local` adapter with `engine: cli`, so they run the `claude` on PATH as you and use your `gh` login rather than a Paperclip GitHub connection.

- **gh token storage:** the service can't read the macOS Keychain, so `make deps` moves your `gh` token into `~/.config/gh/hosts.yml` (readable only by you).
- **CLI engine:** the default ACP engine runs a copy of Claude Code bundled with Paperclip, which can be too old for the newest models. The CLI engine uses your Homebrew `claude`.
- **No GitHub connection:** an installed Paperclip GitHub connection takes over from your `gh` login. If an agent asks to connect GitHub, decline it.

The Paperclip UI has no option for `claude_local`: its "Claude Code" harness is Paperclip's sandboxed runner, where agents get a private home folder and can't use your `gh` login. Saving an agent's harness in the UI switches it to the runner. To switch agents back, or to switch agents you created in the UI:

```bash
make local-claude COMPANY_ID=<company-id> DRY_RUN=1
```

```bash
make local-claude COMPANY_ID=<company-id>
```

Add `AGENTS="Maintainer Scout"` to switch only some agents.

## Sync changes into an existing company

`make run` doesn't overwrite an existing company. To apply local changes, preview first and then apply:

```bash
make sync COMPANY_ID=<company-id> DRY_RUN=1
```

```bash
make sync COMPANY_ID=<company-id>
```

## Capture edits made in the Paperclip UI

```bash
make export COMPANY_ID=<company-id>
```

This writes back `COMPANY.md`, `.paperclip.yaml`, `agents/`, and `skills/org-conventions/`. It doesn't touch the repo skills or this README. Review the diff before committing; exports scrub secrets and machine-specific paths, but they can rewrite formatting.

Run `make help` to list every target.
