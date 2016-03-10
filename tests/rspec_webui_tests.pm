use base "basetest";
use strict;
use testapi;

sub run() {
	assert_script_run("cd ~ ; rm -rf /tmp/open-build-service");
	assert_script_run("zypper -n --no-gpg-checks ref -s", 300);
	assert_script_run("zypper -n in obs-api-testsuite-deps ruby2.3-devel libxml2-devel libxslt-devel", 200);
	assert_script_run("git clone --single-branch --branch master --depth 1 https://github.com/shyukri/open-build-service.git  /tmp/open-build-service", 200);
	assert_script_run("cd /tmp/open-build-service/dist/t"); # we don't need bundle install in the appliance!
	assert_script_run("rspec");
	}

sub test_flags() {
    return {important => 1};
	}

1;