use base "basetest";
use strict;
use testapi;

sub run() {
	script_run("echo -en \"[client]\nuser = root\npassword = opensuse\n\" > /root/.my.cnf");
	assert_script_run "git clone --single-branch --depth 1 https://github.com/openSUSE/open-build-service.git /tmp/open-build-service", 200;
	assert_script_run "make -C  /tmp/open-build-service/dist test_system"
	}

sub test_flags() {
    return {important => 1};
	}

1;
