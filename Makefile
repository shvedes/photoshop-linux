check:
	desktop-file-validate ./photoshop.desktop
	shellcheck ./install.sh

fmt:
	shfmt -w .

