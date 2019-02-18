prefix ?= /usr/local
bindir = $(prefix)/bin

install:
	brew bundle
	swift package update

build:
	swift build

lint:
	swiftformat .
	swiftlint

run-test:
	.build/debug/pomodoro-cli 10

deploy:
	swift build -c release --disable-sandbox
	install ".build/release/pomodoro-cli" "$(bindir)"

clean:
	rm -rf .build
