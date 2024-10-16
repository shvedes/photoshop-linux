SOURCE_FILES := $(shell shfmt -f .)

check:
	desktop-file-validate ./photoshop.desktop
	shellcheck -x $(SOURCE_FILES)

fmt:
	shfmt -w $(SOURCE_FILES)

