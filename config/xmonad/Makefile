
YELLOW=`tput setaf 3`
GREEN=`tput setaf 2`
RESET=`tput sgr 0`
PWD=$(shell pwd)

all: build-xmobar build-xmonad
		@echo -n "${YELLOW}Restarting everything...${RESET}"
		@./xmonad-x86_64-linux --restart
		@echo "${GREEN} Done!${RESET}"

restart: 	
	@./xmonad-x86_64-linux --restart

build-xmobar:
		@echo -n "${YELLOW}Compiling xmobar...${RESET}"
		@stack ghc -- -i$(PWD)/lib --make xmobar-1.hs 1> /dev/null
		@stack ghc -- -i$(PWD)/lib --make xmobar-2.hs 1> /dev/null
		@echo "${GREEN} Done!${RESET}"

build-xmonad: 
		@echo -n "${YELLOW}Compiling xmonad...${RESET}"
		@stack ghc -- -package mtl -i$(PWD)/lib --make xmonad.hs 1> /dev/null
		@mv xmonad xmonad-x86_64-linux
		@echo "${GREEN} Done!${RESET}"
