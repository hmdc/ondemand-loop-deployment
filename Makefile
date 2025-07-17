all:: version
.PHONY: version release_notes

WORKING_DIR := $(shell pwd)

version:
	docker run --rm -e VERSION_TYPE=$(VERSION_TYPE) -v $(WORKING_DIR)/application:/usr/local/app -v $(WORKING_DIR)/scripts:/usr/local/scripts -w /usr/local/app $(LOOP_BUILDER_IMAGE) /usr/local/scripts/loop_version.sh

release_notes:
	./scripts/loop_release_notes.sh
