prefix ?= /usr/local
bindir = $(prefix)/bin

install:
	brew bundle
	swift package update
	swift package generate-xcodeproj

open:
	open Pomodoro.xcodeproj

build:
	swift build

lint:
	swiftformat .
	swiftlint

run-test:
	.build/debug/PomodoroCLI --duration 10

deploy:
	swift build -c release --disable-sandbox
	install ".build/release/PomodoroCLI" "$(bindir)/pomodoro-cli"

clean:
	rm -rf .build