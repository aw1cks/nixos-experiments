.PHONY: build run ssh rm clean help
.DEFAULT_GOAL := help

# VM configuration name
VM_NAME := nixosvirt01

# Build the VM
build: rm ## Build the NixOS VM
	@echo "Building NixOS VM configuration..."
	nix build .#nixosConfigurations.$(VM_NAME).config.system.build.vmWithBootLoader

# Run the VM (depends on build)
run: build ## Build and run the NixOS VM
	@echo "Starting NixOS VM..."
	@echo "Press Ctrl+A then X to quit QEMU"
	env QEMU_NET_OPTS="hostfwd=tcp::2221-:22" ./result/bin/run-$(VM_NAME)-vm

ssh:
	ssh -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no alex@localhost -p 2221

rm: ## Remove VM files
	@echo "Cleaning up VM artifacts..."
	rm -vf result $(VM_NAME).qcow2 $(VM_NAME)-efi-vars.fd

clean: rm ## Clean up VM files and run garbage collection
	@echo "Running nix garbage collection..."
	nix-collect-garbage -d

# Check if VM is built
status: ## Check VM build status
	@if [ -L result ]; then \
		echo "VM is built (result symlink exists)"; \
		ls -la result; \
	else \
		echo "VM is not built (no result symlink)"; \
	fi
	@if [ -f $(VM_NAME).qcow2 ]; then \
		echo "VM disk image exists: $(VM_NAME).qcow2"; \
		ls -lh $(VM_NAME).qcow2; \
	else \
		echo "No VM disk image found"; \
	fi

# Rebuild (clean then build)
rebuild: clean build ## Clean and rebuild the VM

# Help target
help: ## Show this help message
	@echo "NixOS VM Management Makefile"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-12s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
