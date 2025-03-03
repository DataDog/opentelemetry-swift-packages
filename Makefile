.PHONY: test xcframework bump-carthage-and-cocoapods-version

ECHO_TITLE=$(PWD)/scripts/utils/echo-color.sh --title
ECHO_INFO=$(PWD)/scripts/utils/echo-color.sh --info
ECHO_ERROR=$(PWD)/scripts/utils/echo-color.sh --err
ECHO_WARNING=$(PWD)/scripts/utils/echo-color.sh --warn
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

bump-carthage-and-cocoapods-version:
	@$(call require_param,VERSION)
	@$(ECHO_TITLE) "make bump-carthage-and-cocoapods-version VERSION='$(VERSION)'"
	./scripts/bump_version.sh --version "$(VERSION)"
