prefix ?= /usr/local
bindir = $(prefix)/bin

.PHONY: docs

install:
	swift package update
	bundle install

open:
	open Package.swift

build:
	swift build --skip-update

lint:
	swiftformat .
	swiftlint

run-test:
	.build/debug/PomodoroCLI --duration 5

deploy:
	swift build -c release --disable-sandbox
	install ".build/release/PomodoroCLI" "$(bindir)/pomodoro-cli"
	mkdir -p "$(HOME)/.pomodoro-cli"
	touch "$(HOME)/.pomodoro-cli/journal.yml"
	cp Resources/SampleHooks/did*.sh "$(HOME)/.pomodoro-cli"

docs:
	./scripts/generateDocs.sh

clean:
	rm -rf .build .swiftpm
