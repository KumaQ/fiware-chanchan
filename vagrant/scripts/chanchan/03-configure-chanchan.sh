#!/bin/bash

su - chanchan <<EOF
sed -i ${CC_APP_SERVER_PATH}/config.js \
  -e "/^[ ]*config.callback_url =/c config.callback_url = '${CC_APP_CALLBACK}';"
sed -i ${CC_APP_CLIENT_PATH}/app/auth/auth.js \
  -e "/^[ ]*var url =/c\        var url = '${IDM_URL}';" \
  -e "/^[ ]*\\\$scope.user =/c\    \\\$scope.user = '${CC_EMAIL}';" \
  -e "/^[ ]*\\\$scope.password =/c\    \\\$scope.password = '${CC_PASS}';"
EOF

if [ -f "${CC_OAUTH_CREDENTIALS}" ]; then
    ORGANIZATIONS=$( (echo "{" ; (cat "${CC_OAUTH_CREDENTIALS}" | paste -s -d ',') ; echo "}")  | python -m json.tool )
    su - chanchan <<EOF
cat << __EOF > ${CC_APP_CLIENT_PATH}/app/orgs.json
${ORGANIZATIONS}
__EOF
EOF
fi

HOSTS=$(echo '{"chanchan":"'${CC_HOSTNAME}'","idm":"'$IDM_HOSTNAME'"}')
su - chanchan <<EOF
cat << __EOF > ${CC_APP_CLIENT_PATH}/app/hosts.json
${HOSTS}
__EOF
EOF
