INSTALL_DIR=~/.local/bin

all:
	@echo "Pleas run 'make install'"

install:
	@echo ""
	mkdir -p $(INSTALL_DIR)
	cp swiftcommandline.sh $(INSTALL_DIR)
	@echo ""
	@echo "Please add 'source $(INSTALL_DIR)/swiftcommandline.sh' to your .bashrc file"
	@echo ''
	@echo 'USAGE:'
	@echo '------'
	@echo 's <reference_name> <file> - Saves the path to the file  as "reference_name"'
	@echo 's <reference_name> - Saves the path  as "reference_name"'
	@echo 'g <reference_name> - Jumps to the path specified'
	@echo 'e <reference_name> - Open reference file in vim'
	@echo 'o <reference_name> - Open reference file in default program'
	@echo 'p <reference_name> - Prints the directory associated with "reference_name"'
	@echo 'd <reference_name> - Deletes the reference'
	@echo 'l                  - Lists all available references'
