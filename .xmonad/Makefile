
YELLOW=`tput setaf 3`
GREEN=`tput setaf 2`
RESET=`tput sgr 0`
PWD=$(shell pwd)

all: build-xmobar build-xmonad clean-build
		@echo -n "${YELLOW}Restarting everything...${RESET}"
		@xmonad --restart
		@echo "${GREEN} Done!${RESET}"
		
build-xmobar:
		@echo -n "${YELLOW}Compiling xmobar...${RESET}"
		@ghc -i$(PWD)/lib --make xmobar.hs 1> /dev/null
		@echo "${GREEN} Done!${RESET}"

build-xmonad: 
		@echo -n "${YELLOW}Compiling xmonad...${RESET}"
		@ghc -i$(PWD)/lib --make xmonad.hs 1> /dev/null
		@echo "${GREEN} Done!${RESET}"

clean-build:
		@echo -n "${YELLOW}Removing compilation files...${RESET}"
		@find ~/.xmonad/ -type f -name '*.o'      -delete
		@find ~/.xmonad/ -type f -name '*.hi'     -delete
		@find ~/.xmonad/ -type f -name '*.errors' -delete
		@echo "${GREEN} Done!${RESET}"
