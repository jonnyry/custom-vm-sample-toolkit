SHELL := /bin/bash

.PHONY: help
help: ## Show this help
	@echo
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%s\033[0m|%s\n", $$1, $$2}' \
        | column -t -s '|'
	@echo

vm-show-env: ## show the environment variables associated with custom VM images
	. ./scripts/load_env.sh && ./scripts/vm-show-env.sh

vm-create-role: ## creates the custom role defintion (run once per subscription)
	. ./scripts/load_env.sh && ./scripts/vm-create-role.sh

vm-view-role: ## views the custom role defintion
	. ./scripts/load_env.sh && ./scripts/vm-view-role.sh

vm-deploy-core: ## deploy core infra required for custom VMs (run once per environment)
	. ./scripts/load_env.sh && ./scripts/vm-deploy-core.sh

vm-define-basic-linux-image: ## create basic linux image definitions within Azure Compute Gallery
	. ./scripts/load_env.sh && ./scripts/vm-define-images.sh ./templates/basic-linux/image_metadata.txt

vm-deploy-template-artifacts: ## copy VM templates and supporting scripts to storage in Azure (run when templates are updated)
	. ./scripts/load_env.sh && ./scripts/vm-deploy-template-artifacts.sh ./templates

vm-create-basic-linux-template: ## create the basic linux template in Azure (run once per template)
	. ./scripts/load_env.sh && ./scripts/vm-create-template.sh --template-url ./templates/basic-linux/image_template.json --metadata-url ./templates/basic-linux/image_metadata.txt

vm-build-basic-linux-image: ## builds the basic Linux VM image
	. ./scripts/load_env.sh && ./scripts/vm-build-image.sh --metadata-url ./templates/basic-linux/image_metadata.txt
