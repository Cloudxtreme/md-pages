SERVER  = fswatch . 'make clear build && 	\
	kill `pidof fswatch` && 			\
	kill `pidof node` && 				\
	node ./node_modules/.bin/http-server ./build -p 5000 & SRVPID=$$!'

clear:
	@rm -rf build

build: $(shell find ./src)
	@./node_modules/.bin/cake build

serve: clear build
	@clear
	@echo 'Start watching $(shell pwd)'
	@echo '***'
	@echo ''
	@node ./node_modules/.bin/http-server ./build -p 5000 & SRVPID=$$!
	@while true; do $(SERVER);done




.PHONY: clean watch run run-prod matching css-vendor open dev prod


