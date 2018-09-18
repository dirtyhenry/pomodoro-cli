build:
	swift build

deploy:
	cp .build/debug/pomodoro-cli $(HOME)/bin/

install:
	swift package update
