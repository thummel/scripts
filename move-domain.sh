#!/bin/bash

DOMAIN="${1}"

OLD_SITE="${2}"

NEW_SITE="${3}"

terminus domain:remove "${OLD_SITE}" "${DOMAIN}"

terminus domain:add "${NEW_SITE}" "${DOMAIN}"
