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
├── Makefile                   # deps, run, sync, export
├── scripts/                   # deps.sh, run.sh, sync-skills.sh (not part of the import)
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

Authenticate `gh` (`gh auth login`) and Claude Code once per machine; `make deps` warns if `gh` isn't logged in.

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
