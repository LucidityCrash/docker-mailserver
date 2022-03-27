load 'test_helper/common'

function setup_file() {
  local PRIVATE_CONFIG
  PRIVATE_CONFIG=$(duplicate_config_for_container .)

  docker run -d --name mail_getmail \
    -v "${PRIVATE_CONFIG}":/tmp/docker-mailserver \
    -v "$(pwd)/test/test-files":/tmp/docker-mailserver-test:ro \
    -e ENABLE_GETMAIL=1 \
    --cap-add=NET_ADMIN \
    -h mail.my-domain.com -t "${NAME}"

  wait_for_finished_setup_in_container mail_getmail
}

function teardown_file() {
  docker rm -f mail_getmail
}

#
# processes
#

@test "checking process: getmail (getmail server enabled)" {
  run docker exec mail_getmail /bin/bash -c "ps aux --forest | grep -v grep | grep '/usr/bin/getmail'"
  assert_success
}

#
# getmail
#

@test "checking getmail: gerneral options in getmailrc are loaded" {
  run docker exec mail_getmail grep 'set syslog' /etc/getmailrc
  assert_success
}

@test "checking getmail: getmail.cf is loaded" {
  run docker exec mail_getmail grep 'pop3.example.com' /etc/getmailrc
  assert_success
}

#
# supervisor
#

@test "checking restart of process: getmail" {
  run docker exec mail_getmail /bin/bash -c "pkill getmail && sleep 10 && ps aux --forest | grep -v grep | grep '/usr/bin/getmail'"
  assert_success
}
