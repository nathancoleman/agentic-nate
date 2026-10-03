SHELL := /bin/bash
.DEFAULT_GOAL := help

PAPERCLIP := $(shell command -v paperclipai 2>/dev/null || echo npx -y paperclipai@latest)

.PHONY: help
help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*## "} {printf "  %-10s %s\n", $$1, $$2}'

.PHONY: deps
deps: ## Install Paperclip and any missing tools (brew, git, jq, gh, go, terraform, node, claude); DRY_RUN=1 to preview
	@./scripts/deps.sh

.PHONY: skills
skills: ## Copy the repo's ../skills into skills/ (gitignored)
	@./scripts/sync-skills.sh

.PHONY: run
run: deps skills ## Install deps, start Paperclip, and import the factory if it is not already imported
	@./scripts/run.sh

.PHONY: onboard
onboard: ## Set up a local Paperclip instance
	$(PAPERCLIP) onboard --yes

.PHONY: import
import: skills ## Import the factory as a new company
	$(PAPERCLIP) company import . --target new --yes

.PHONY: sync
sync: skills ## Apply the factory over an existing company (COMPANY_ID=..., DRY_RUN=1 to preview)
	@test -n "$(COMPANY_ID)" || { echo "COMPANY_ID is required"; exit 1; }
	$(PAPERCLIP) company import . --target existing -C $(COMPANY_ID) --collision replace $(if $(filter 1,$(DRY_RUN)),--dry-run,--yes)

.PHONY: export
export: ## Export edits made in the Paperclip UI back into this directory (COMPANY_ID=...)
	@test -n "$(COMPANY_ID)" || { echo "COMPANY_ID is required"; exit 1; }
	@tmp="$$(mktemp -d)"; trap 'rm -rf "$$tmp"' EXIT; \
	$(PAPERCLIP) company export $(COMPANY_ID) --out "$$tmp" --include company,agents,skills --force && \
	cp "$$tmp/COMPANY.md" "$$tmp/.paperclip.yaml" . && \
	rsync -a --delete "$$tmp/agents/" agents/ && \
	if [ -d "$$tmp/skills/org-conventions" ]; then rsync -a --delete "$$tmp/skills/org-conventions/" skills/org-conventions/; fi && \
	echo "exported COMPANY.md, .paperclip.yaml, agents/, and skills/org-conventions; repo skills stay in ../skills"
