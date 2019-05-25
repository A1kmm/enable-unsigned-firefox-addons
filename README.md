# Purpose

This lets you modify your local Firefox installation so that you can use a standard release channel Firefox, but still install unsigned addons.

You probably only want to do this if you are a developer of add-ons (for example, of your own personal addons you want to run locally but not share with Mozilla for signing).

# About unsigned addon support

The standard release channel builds of Firefox now have a setting built into them that means that all addons must be signed by Mozilla, and this setting cannot be changed by simple means (including through settings in `about:config`).

[Firefox Developer Edition](https://www.mozilla.org/en-US/firefox/developer/) doesn't have this limitation. You can install unsigned extensions by downloading Firefox Developer Edition and then toggle `xpinstall.signatures.required` to false in `about:config`. The Developer Edition is effectively a beta release channel, and is updated nightly.

For various reasons, you might prefer to be on the more stable release channel. If you want that, but to also install unsigned addons, the scripts provided here are what you need.

# Prerequisites

The scripts use `bash`, Info-ZIP `zip` and `unzip`, `mktemp` (from GNU coreutils), and `sed`. Ensure you have these installed before using the script.

# Patching

Follow the following steps to patch Firefox to disable addon signing.

1. Update Firefox to the latest version before starting, to save extra steps to update later.
1. Configure Firefox not to auto-update using `about:preferences#general`, because you will now have additional manual steps to update (see the Updating section).
1. Find the directory where you have installed Firefox. This is the path where the `firefox` binary resides (excluding the name of the binary - so it is the path to the directory and not the binary).
1. Run `export MOZILLA_HOME=/path/to/firefox`, substituting the directory in place of `/path/to/firefox`.
1. Ensure that you have exited from Firefox.
1. Run the `patch-firefox.sh` script. If it works, the last line should be Done.
1. If you have an existing Firefox profile, you will also need to find your profile directory. The location depends on your configuration, but on Linux is usually a subdirectory of `~/.mozilla/firefox/`, called `xxxxxxxx.default`, where xxxxxxxx is replaced with a random string of characters.
1. In that profile directory (if you have one already), you will need to delete the subdirectory called `startupCache`.
1. Start Firefox.
1. Navigate to `about:config`.
1. While on `about:config`, go to the Developer tools (F12 by default), and switch to the Console tab. Type in `ChromeUtils.import("resource://gre/modules/AppConstants.jsm").AppConstants.MOZ_REQUIRE_SIGNING`. If you see `false`, the patching has worked. If you see true, something has not worked. If it did not work, ensure you have run the `patch-firefox.sh` script with the correct MOZILLA_HOME, and that you have successfully deleted the startupCache before starting Firefox, and try again.
1. In `about:config`, search for xpinstall.signatures.required, and change the value to false if it is true.
1. Copy your extension into the extensions subdirectory of your Firefox profile directory.
1. Restart Firefox. Firefox will prompt to confirm that you want to enable the addon.

# Upgrading Firefox

You should continue to upgrade Firefox whenever it prompts you to upgrade it to ensure you have the latest security patches. However, before applying upgrades, you should:

1. Exit from Firefox.
1. Ensure you have exported `MOZILLA_HOME` (per the steps for patching)
1. Run `unpatch-firefox.sh`
1. Start Firefox using the `-ProfileManager` option, and start it using a different profile - create a new one if necessary (don't start it with your normal profile as this will disable all your unsigned addons, and you will need to clear caches again).
1. Apply the update.
1. Run `patch-firefox.sh`
1. Start Firefox again using your default profile.
