use base "basetest";
use strict;
use testapi;

sub run() {
	assert_script_run("zypper -n --no-gpg-checks ref -s", 600);
	#assert_script_run("zypper -n dup", 200);
	assert_script_run("zypper -n in obs-tests-appliance obs-api-testsuite-deps ruby2.3-devel libxml2-devel libxslt-devel", 300);
	script_run("echo -en \"[client]\nuser = root\npassword = opensuse\n\" > /root/.my.cnf");
	script_run("prove -v /usr/lib/obs/tests/appliance/*.{t,ts} && touch /tmp/SUCC | tee /tmp/appliance_tests.txt", 360);
	upload_logs("/tmp/appliance_tests.txt")
	}

sub test_flags() {
    return {important => 1};
	}

1;
