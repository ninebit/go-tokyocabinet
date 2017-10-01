all: test

.PHONY: fmt
fmt:
	@go fmt

.PHONY: test
test:
	@./scripts/test_on_pax.sh
