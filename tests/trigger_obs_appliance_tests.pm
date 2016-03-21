use base "basetest";
use strict;
use testapi;

sub run() {
	assert_script_run("zypper -n --no-gpg-checks ref -s", 600);
	assert_script_run("zypper -n dup", 200);
	assert_script_run("zypper -n in obs-tests-appliance obs-api-testsuite-deps ruby2.3-devel libxml2-devel libxslt-devel", 300);
	script_run("echo -en \"[client]\nuser = root\npassword = opensuse\n\" > /root/.my.cnf");
	#assert_script_run("cd ~ ; git clone --single-branch --branch fix_tests_networking --depth 1 https://github.com/M0ses/open-build-service.git  /tmp/open-build-service", 200);	
	script_run("prove -v /usr/lib/obs/tests/appliance/*.{t,ts} 2>&1 | tee /tmp/appliance_tests.txt", 360);
	#assert_script_run "make -C /tmp/open-build-service/dist test_system | tee /tmp/appliance_tests.txt", 600;
	upload_logs("/tmp/appliance_tests.txt");
	script_run("rm -rf /tmp/open-build-service");
	}

sub test_flags() {
    return {important => 1};
	}

1;
