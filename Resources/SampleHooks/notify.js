// Import standard library
ObjC.import("stdlib");

// Convert arguments from Objective-C array to JavaScript array
const args = $.NSProcessInfo.processInfo.arguments;
const argc = $.NSProcessInfo.processInfo.arguments.count;
var arguments = [];
for (var i = 4; i < argc; i++) {
  // Starting from 4 to skip script name and AppleScript overhead arguments
  arguments.push(ObjC.unwrap(args.objectAtIndex(i)));
}

const displayNotification = (title, subtitle, message, soundName) => {
  const app = Application.currentApplication();
  app.includeStandardAdditions = true;

  // 📜 Checkout out sound names in /System/Library/Sounds/
  app.displayNotification(message, {
    withTitle: title,
    subtitle: subtitle,
    soundName: soundName,
  });
};

// Use arguments in the function
if (arguments.length >= 4) {
  displayNotification(arguments[0], arguments[1], arguments[2], arguments[3]);
} else {
  console.log(
    "Usage: osascript myScript.js <title> <subtitle> <message> <soundName>"
  );
}
