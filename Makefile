SHELL := /bin/bash
.PHONY: all check lint docs

all: check

check:
	./scripts/validate.sh

lint:
	if command -v shellcheck &> /dev/null; then \
		shellcheck -x install.sh scripts/*.sh || true; \
	else \
		echo "shellcheck not installed"; \
	fi

docs:
	@echo "No docs build step defined. See docs/ for contribution guidelines."