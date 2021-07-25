# Dev, QA, Release enviornment
ENVIORNMENT=''
# Build identifier
BUNDLE_IDENTIFIER=$PRODUCT_BUNDLE_IDENTIFIER
# Name of the Crashlytics GoogleService-Info.plist
FIREBASE_CRASHLYTICS_INFO_PLIST=GoogleService-Info.plist
# Source location from where we have to copy GoogleService-Info.plist
PLIST_LOCATION=''
# Destination location to copy GoogleService-Info.plist
PLIST_DESTINATION=${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.appex

# Bundle ID's
WIDGET_BUNDLE_ID_DEV=com.blacksheep.widget.dev
WIDGET_BUNDLE_ID_QA=com.blacksheep.widget.qa
WIDGET_BUNDLE_ID_RELEASE=com.blacksheep.widget.release

function getEnviornment() {
    local env=$1
    case $env in
        $WIDGET_BUNDLE_ID_DEV)
            ENVIORNMENT='DEV'
        ;;
        $WIDGET_BUNDLE_ID_QA)
            ENVIORNMENT='QA'
        ;;
        $WIDGET_BUNDLE_ID_RELEASE)
            ENVIORNMENT='RELEASE'
        ;;
        *)
        echo 'Reason for build failure: Use valid bundle identifier. Check firebase.sh at location Crashlytics/'
        exit 1
        ;;
    esac
}

getEnviornment $BUNDLE_IDENTIFIER
PLIST_LOCATION=Firebase/${ENVIORNMENT}/${FIREBASE_CRASHLYTICS_INFO_PLIST}

if [ -f $PLIST_LOCATION ]
then
    cp "${PLIST_LOCATION}" "${PLIST_DESTINATION}"
    "${PODS_ROOT}/FirebaseCrashlytics/run"
    echo "GoogleService-Info.plist has been copied successfully at ${PLIST_DESTINATION}"
else 
    echo "Reason for build failure: GoogleService-Info.plist is not available at ${PLIST_LOCATION}."
    exit 1
fi
