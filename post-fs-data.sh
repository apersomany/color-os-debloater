#!/system/bin/sh

# STAGE 1: BLACKLIST ROOTS + WHITELIST REGEX
BLACKLIST_ROOTS="
/my_product/del-app
/my_preload/del-app
/my_stock/del-app
"
WHITELIST_REGEX="Calculator|FileManager|Clock|Recorder"
for ROOT in $BLACKLIST_ROOTS; do
    # GUARD: Skip if root directory doesn't exist
    [ ! -d "$ROOT" ] && continue
    for APP_PATH in "$ROOT"/*; do
        # GUARD: Skip if it's NOT a directory (ignore files/failed globs)
        [ ! -d "$APP_PATH" ] && continue
        # GUARD: Whitelist check
        echo "${APP_PATH##*/}" | grep -qE "$WHITELIST_REGEX" && continue
        # ACTION: Hide the directory
        mount --bind "${0%/*}/empty" "$APP_PATH"
    done
done

# STAGE 2: BLACKLIST ROOTS + BLACKLIST REGEX
BLACKLIST_ROOTS="
/my_stock/app
/my_stock/priv-app
/product/app
/product/priv-app
"
BLACKLIST_REGEX="AI|KeKe|Game|Wallet|HeyTap|UMS|Baidu|CloudService|ColorAccessibilityAssistant|ColorDirectService|Contacts|Mms|InCallUI|Browser"
for ROOT in $BLACKLIST_ROOTS; do
    # GUARD: Skip if root directory doesn't exist
    [ ! -d "$ROOT" ] && continue
    for APP_PATH in "$ROOT"/*; do
        # GUARD: Skip if it's NOT a directory
        [ ! -d "$APP_PATH" ] && continue
        # GUARD: Blacklist check
        echo "${APP_PATH##*/}" | grep -qE "$BLACKLIST_REGEX" || continue
        # ACTION: Hide the directory
        mount --bind "${0%/*}/empty" "$APP_PATH"
    done
done