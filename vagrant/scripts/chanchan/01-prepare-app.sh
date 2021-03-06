#!/bin/bash

su - chanchan <<EOF
# clone app repository
git clone https://github.com/Bitergia/fiware-chanchan.git fiware-chanchan

cd \${HOME}/fiware-chanchan
if [ "${GIT_REV_CHANCHAN}" != "master" ]; then
    git checkout ${GIT_REV_CHANCHAN}
fi

cd \${HOME}/${CC_APP_SERVER_PATH}

# install dependencies for server side
npm install --loglevel warn

cd \${HOME}/${CC_APP_CLIENT_PATH}

# avoid bower propmts
export CI=true

# install dependencies for client side
npm install --loglevel warn
EOF
