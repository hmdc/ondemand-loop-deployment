all:: version
.PHONY: version release_notes

version:
	./scripts/version.sh $(VERSION_TYPE)

release_notes:
	./scripts/release_notes.sh
