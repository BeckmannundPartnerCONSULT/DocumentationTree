#!/bin/bash
set -e

java -version
mvn -v

cd $GITHUB_WORKSPACE

echo "#################################################"
echo "Create Maven settings"

cat > settings.xml <<EOF
<!--
  ~ Copyright 2020 Beckmann & Partner CONSULT
  ~
  ~ Licensed under the Apache License, Version 2.0 (the "License");
  ~ you may not use this file except in compliance with the License.
  ~ You may obtain a copy of the License at
  ~
  ~     http://www.apache.org/licenses/LICENSE-2.0
  ~
  ~ Unless required by applicable law or agreed to in writing, software
  ~ distributed under the License is distributed on an "AS IS" BASIS,
  ~ WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  ~ See the License for the specific language governing permissions and
  ~ limitations under the License.
  -->

<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                      http://maven.apache.org/xsd/settings-1.0.0.xsd">

    <activeProfiles>
        <activeProfile>github</activeProfile>
    </activeProfiles>

    <profiles>
        <profile>
            <id>github</id>
            <repositories>
                <repository>
                    <id>central</id>
                    <url>https://repo1.maven.org/maven2</url>
                    <releases><enabled>true</enabled></releases>
                    <snapshots><enabled>true</enabled></snapshots>
                </repository>
                <repository>
                    <id>github</id>
                    <name>GitHub BeckmannundPartnerCONSULT Apache Maven Packages</name>
                    <url>https://maven.pkg.github.com/BeckmannundPartnerCONSULT/DocumentationTree</url>
                </repository>
            </repositories>
        </profile>
    </profiles>

    <servers>
        <server>
            <id>github</id>
            <username>beckDev</username>
            <password>${GITHUB_TOKEN}</password>
        </server>
    </servers>
</settings>
EOF

echo "#################################################"
echo "Starting the Maven Action"

sh -c "mvn release:prepare --settings settings.xml"
sh -c "mvn release:perform --settings settings.xml"

echo "#################################################"
echo "Published"
