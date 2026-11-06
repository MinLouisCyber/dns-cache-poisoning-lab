#!/bin/sh
set -eu

named -g -c /etc/bind/named.conf -u bind &
named_pid=$!
trap 'kill -TERM "$named_pid" 2>/dev/null || true; wait "$named_pid" 2>/dev/null || true' TERM INT
wait "$named_pid"
