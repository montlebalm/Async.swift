PROJECT_NAME?=AsyncLib

test:
	@xctool -scheme ${PROJECT_NAME} test -parallelize

.PHONY: test
