use base "basetest";
use strict;
use testapi;

sub run() {
	assert_script_run("git clone --single-branch --branch make_rspec_webui_tests_work --depth 1 https://github.com/shyukri/open-build-service.git  /tmp/open-build-service", 200);
	assert_script_run("cd /tmp/open-build-service/dist/t"); # we don't need bundle install in the appliance!
	assert_script_run("set -o pipefail; rspec --format documentation | tee /tmp/rspec_tests.txt", 480);
	save_screenshot;
	}

sub test_flags() {
	return {important => 1};
	}

sub post_fail_hook {
	upload_logs("/tmp/rspec_tests.txt");
	assert_script_run("tar cjf /tmp/capybara_screens.tar.bz2 /tmp/rspec_screens/*");
	upload_logs("/tmp/capybara_screens.tar.bz2");
	assert_script_run("tar cjf /tmp/srv_www_obs_api_logs.tar.bz2 /srv/www/obs/api/log/*");
	upload_logs("/tmp/srv_www_obs_api_logs.tar.bz2");
	assert_script_run("tar cjf /tmp/srv_obs_build.tar.bz2 /srv/obs/build/*");
	upload_logs("/tmp/srv_obs_build.tar.bz2");
	assert_script_run("tar cjf /tmp/srv_obs_log.tar.bz2 /srv/obs/log/*");
	upload_logs("/tmp/srv_obs_log.tar.bz2");
	}
1;
