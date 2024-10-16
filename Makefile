SOURCE_FILES := $(shell shfmt -f .)

FORMAT_FLAGS := -kp -sr -i 2 -s

check:
	desktop-file-validate ./photoshop.desktop
	shellcheck -x $(SOURCE_FILES)

fmt:
	shfmt -w \
		$(FORMAT_FLAGS) \
		$(SOURCE_FILES)

