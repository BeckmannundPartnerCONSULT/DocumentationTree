#!/bin/bash
set -e

cd $GITHUB_WORKSPACE

echo "#################################################"
echo "Starting the Maven Action"

sh -c "mvn clean install"

echo "#################################################"
echo "Maven build done"

echo "#################################################"
echo "Now publishing"
SOME_TOKEN=${GITHUB_TOKEN}

USER_NAME="${GITHUB_ACTOR}"
MAIL="${GITHUB_ACTOR}@users.noreply.github.com"

echo "Set user data."
git config user.name "${USER_NAME}"
git config user.email "${MAIL}"

FILE=release
if [ ! -d "$FILE" ]; then
    mkdir $FILE
fi

cp target/documentationtree-*-jar-with-dependencies.jar release

echo "Add all files."
git add release/*.jar
git status

git diff-index --quiet HEAD || echo "Commit changes." && git commit -m 'Maven build from Action' && echo "Push." && git push

echo "#################################################"
echo "Published"


echo "WOW!"