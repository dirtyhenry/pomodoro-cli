# 📜 https://forums.swift.org/t/how-to-distribute-a-swiftpm-executable-on-macos/47127/5
# 📜 https://developer.apple.com/developer-id/

VERSION = 1.2.0
PRODUCT = pomodoro-cli

BINARY = .build/apple/Products/Release/${PRODUCT}
PKG_ROOT = ./pkg/${PRODUCT}-${VERSION}
PKG_DIR =  ${PKG_ROOT}/usr/local/bin
PKG_DMG = ./pkg/${PRODUCT}-${VERSION}.dmg
PKG_DMG_ROOT = ./pkg/out
PKG = ${PKG_DMG_ROOT}/${PRODUCT}-${VERSION}.pkg
BUNDLE_ID = ${REVERSED_DOMAIN}.${PRODUCT}

# Load secrets
$(shell touch .env)
include .env
export $(shell sed 's/=.*//' .env)

prefix ?= /usr/local
bindir = $(prefix)/bin

# --- The Everyday Tasks ---

.PHONY: docs

install:
	swift package update

open:
	open Package.swift

build:
	swift build --skip-update

format:
	swiftformat --verbose .
	swiftlint lint --autocorrect .
	
lint:
	swiftformat --lint .
	swiftlint lint .
	shellcheck Resources/SampleHooks/sample-pomodoro-finish.sh
	shellcheck Resources/SampleHooks/sample-pomodoro-start.sh
	shellcheck Resources/SampleHooks/mickf-pomodoro-finish.sh
	shellcheck Resources/SampleHooks/mickf-pomodoro-start.sh

run-test: build
	.build/debug/${PRODUCT} --duration 5

deploy:
	swift build -c release --disable-sandbox
	sudo install ".build/release/${PRODUCT}" "$(bindir)/pomodoro-cli"
	mkdir -p "$(HOME)/.pomodoro-cli"
	touch "$(HOME)/.pomodoro-cli/journal.yml"
	@test -f "$(HOME)/.pomodoro-cli/pomodoro-finish.sh" || cp Resources/SampleHooks/sample-pomodoro-finish.sh "$(HOME)/.pomodoro-cli/pomodoro-finish.sh"
	@test -f "$(HOME)/.pomodoro-cli/pomodoro-start.sh" || cp Resources/SampleHooks/sample-pomodoro-start.sh "$(HOME)/.pomodoro-cli/pomodoro-start.sh"

deploy-my-hooks:
	cp Resources/SampleHooks/mickf-pomodoro-finish.sh "$(HOME)/.pomodoro-cli/pomodoro-finish.sh"
	cp Resources/SampleHooks/mickf-pomodoro-start.sh "$(HOME)/.pomodoro-cli/pomodoro-start.sh"
	cp Resources/SampleHooks/notify.js "$(HOME)/.pomodoro-cli/notify.js"

docs:
	xcodebuild docbuild -scheme "Pomodoro" -derivedDataPath tmp/derivedDataPath -destination platform=macOS
	rsync -r tmp/derivedDataPath/Build/Products/Debug/Pomodoro.doccarchive/ .Pomodoro.doccarchive
	rm -rf tmp/

clean:
	rm -rf .build/ .swiftpm/ pkg/

serve-docs:
	serve --single .Pomodoro.doccarchive

# --- The Distribution Tasks ---

${BINARY}:
	swift build -c release --product ${PRODUCT} --arch arm64 --arch x86_64
	xcrun codesign -s ${CODESIGN_IDENTITY} \
               --options=runtime \
               --timestamp \
               ${BINARY}
               
${PKG}: ${BINARY}
	rm -rf "${PKG_ROOT}" || true
	rm -rf "${PKG_DMG_ROOT}" || true
	mkdir -p ${PKG_DIR}
	mkdir -p ${PKG_DMG_ROOT}
	cp ${BINARY} ${PKG_DIR}
	xcrun pkgbuild --root ${PKG_ROOT} \
           --identifier "${BUNDLE_ID}" \
           --version "${VERSION}" \
           --install-location "/" \
           --sign ${PKG_CODESIGN_IDENTITY} \
           ${PKG}
           
${PKG_DMG}: ${PKG} staple
	hdiutil create -volname "${PRODUCT}" -srcfolder "${PKG_DMG_ROOT}" -ov -format UDZO "${PKG_DMG}"

.PHONY: build
build: ${BINARY}

.PHONY: package
package: ${PKG}

.PHONY: notarize
notarize: ${PKG}
	xcrun notarytool submit \
		--apple-id "${USERNAME}" \
		--password "${PASSWORD_ID}" \
		--team-id "${TEAM_ID}" \
		--wait \
		"${PKG}"
               
.PHONY: staple
staple:
	xcrun stapler staple "${PKG}"

.PHONY: image
image: ${PKG_DMG}
