use base "basetest";
use strict;
use testapi;

sub run() {
	#assert_script_run("zypper -n ar http://download.opensuse.org/repositories/home:/M0ses:/branches:/OBS:/Server:/Unstable/openSUSE_42.1/home:M0ses:branches:OBS:Server:Unstable.repo");
	#assert_script_run("zypper -n --no-gpg-checks ref -s");
	#assert_script_run("zypper -n in obs-tests-appliance");
	#script_run("sleep 100", 105); #give time to obsapidelayed
	assert_script_run("rm -rf /tmp/open-build-service");
	assert_script_run("git clone --single-branch --branch fix_tests_for_openQA --depth 1 https://github.com/M0ses/open-build-service.git  /tmp/open-build-service", 200);
	#assert_script_run("git checkout -C /tmp/open-build-service fix_tests_for_openQA");
	script_run("echo -en \"[client]\nuser = root\npassword = opensuse\n\" > /root/.my.cnf");
	assert_script_run "make -C /tmp/open-build-service/dist test_system | tee /tmp/appliance_tests.txt -", 600;
	##assert_script_run("prove -v /usr/lib/obs/tests/appliance/*.{t,ts} | tee /tmp/appliance_tests.txt -", 600);
	upload_logs("/tmp/appliance_tests.txt")
	}

sub test_flags() {
    return {important => 1};
	}

1;
