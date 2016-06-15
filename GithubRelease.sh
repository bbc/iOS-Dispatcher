#!/bin/bash
ORGANIZATION_NAME=BBC
REPOSITORY_NAME=iOS-Dispatcher
LIBRARY_VERSION=$1
LIBRARY_PATH=$2
ACCESS_TOKEN=$3
PRERELEASE=$4

PACKAGE_NAME="smp-ios-$LIBRARY_VERSION.zip"
RELEASE_NOTES_NAME="Notes-$LIBRARY_VERSION.txt"

API_JSON=$(printf '{"tag_name": "%s", "target_commitish": "master", "name": "%s", "body": "Release of version %s", "draft": false, "prerelease": %s}' $LIBRARY_VERSION $LIBRARY_VERSION $LIBRARY_VERSION $PRERELEASE)
RELEASE_URL=$(curl -i --data "$API_JSON" https://api.github.com/repos/$ORGANIZATION_NAME/$REPOSITORY_NAME/releases?access_token=$ACCESS_TOKEN | tr -d '\r' | sed -En 's/^Location: (.*)/\1/p')
RELEASE_ID="${RELEASE_URL##*/}"

cat $RELEASE_NOTES_PATH
curl -# -XPOST -H "Authorization:token $ACCESS_TOKEN" -H "Content-Type:application/octet-stream" --data-binary @$LIBRARY_PATH https://uploads.github.com/repos/$ORGANIZATION_NAME/$REPOSITORY_NAME/releases/$RELEASE_ID/assets?name=$PACKAGE_NAME
curl -# -XPOST -H "Authorization:token $ACCESS_TOKEN" -H "Content-Type:text/plain" --data-binary @$RELEASE_NOTES_PATH https://uploads.github.com/repos/$ORGANIZATION_NAME/$REPOSITORY_NAME/releases/$RELEASE_ID/assets?name=$RELEASE_NOTES_NAME

