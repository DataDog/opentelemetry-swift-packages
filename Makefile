.PHONY: test xcframework publish-github bump-carthage-version

ECHO_TITLE=$(PWD)/scripts/utils/echo-color.sh --title
ECHO_ERROR=$(PWD)/scripts/utils/echo-color.sh --err
ECHO_SUCCESS=$(PWD)/scripts/utils/echo-color.sh --succ

define require_param
    if [ -z "$${$(1)}" ]; then \
        $(ECHO_ERROR) "Error:" "$(1) parameter is required but not provided."; \
        exit 1; \
    fi
endef

test:
	@$(ECHO_TITLE) "make test"
	swift build | xcbeautify
	@$(ECHO_SUCCESS) "'swift build' Succeeded"

xcframework:
	@$(ECHO_TITLE) "make xcframework"
	./scripts/build.sh --source . --target OpenTelemetryApi

publish-github:
	@$(call require_param,VERSION)
	@$(ECHO_TITLE) "make publish-github VERSION='$(VERSION)'"
	./scripts/publish_github.sh --version "$(VERSION)"

bump-carthage-version:
	@$(call require_param,VERSION)
	@$(ECHO_TITLE) "make bump-carthage-version VERSION='$(VERSION)'"
	./scripts/bump_version.sh --version "$(VERSION)"
