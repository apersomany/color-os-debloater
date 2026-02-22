#!/system/bin/sh

MODDIR="${0%/*}"
LOG="/data/local/tmp/color-os-debloater.log"
echo "=== $(date) ===" > "$LOG"

# STAGE 1: BLACKLIST ROOTS + WHITELIST REGEX
BLACKLIST_ROOTS="/my_product/del-app /my_preload/del-app /my_stock/del-app"
WHITELIST_REGEX="Calculator|FileManager|Clock|Recorder|Weather"
for ROOT in $BLACKLIST_ROOTS; do
    [ ! -d "$ROOT" ] && continue
    for APP_PATH in "$ROOT"/*; do
        [ ! -d "$APP_PATH" ] && continue
        echo "${APP_PATH##*/}" | grep -qE "$WHITELIST_REGEX" && continue
        echo "mount: $APP_PATH" >> "$LOG"
        mount --bind "$MODDIR/empty" "$APP_PATH"
    done
done

# STAGE 2: BLACKLIST ROOTS + BLACKLIST REGEX
BLACKLIST_ROOTS="/my_stock/app /my_stock/priv-app /product/app /product/priv-app"
BLACKLIST_REGEX="AI|KeKe|Game|Wallet|HeyTap|UMS|Baidu|CloudService|ColorAccessibilityAssistant|ColorDirectService|Contacts|Mms|InCallUI|Browser"
for ROOT in $BLACKLIST_ROOTS; do
    [ ! -d "$ROOT" ] && continue
    for APP_PATH in "$ROOT"/*; do
        [ ! -d "$APP_PATH" ] && continue
        echo "${APP_PATH##*/}" | grep -qE "$BLACKLIST_REGEX" || continue
        echo "mount: $APP_PATH" >> "$LOG"
        mount --bind "$MODDIR/empty" "$APP_PATH"
    done
done
echo "=== Done ===" >> "$LOG"
