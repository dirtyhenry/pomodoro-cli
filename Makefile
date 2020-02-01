prefix ?= /usr/local
bindir = $(prefix)/bin

.PHONY: docs

install:
	brew bundle
	swift package update
	swift package generate-xcodeproj
	bundle install

open:
	open Pomodoro.xcodeproj

build:
	swift build --skip-update

lint:
	swiftformat .
	swiftlint

run-test:
	.build/debug/PomodoroCLI --duration 10

deploy:
	swift build -c release --disable-sandbox
	install ".build/release/PomodoroCLI" "$(bindir)/pomodoro-cli"
	mkdir -p "$(HOME)/.pomodoro-cli"
	cp Resources/SampleHooks/did*.sh "$(HOME)/.pomodoro-cli"

docs:
	./scripts/generateDocs.sh

clean:
	rm -rf .build