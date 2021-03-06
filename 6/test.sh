#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

cid="$(
	docker run -d -e DRUPAL_VERSION=6 "${IMAGE}"
)"
trap "docker rm -vf ${cid} > /dev/null" EXIT

docker exec "${cid}" make init -f /usr/local/bin/actions.mk
echo -n "Checking Drupal version... "
docker exec "${cid}" drush -r "/var/www/html/web" status | grep -q 'Drupal version *: *6\.38'
echo "OK"
