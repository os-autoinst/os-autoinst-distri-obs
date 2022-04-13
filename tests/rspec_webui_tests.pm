use base "basetest";
use strict;
use testapi;

sub run() {
    my $branch = "master";
    if (get_var('VERSION') != "Unstable") {
        $branch = get_var('VERSION');
    }

    assert_script_run("curl -O https://raw.githubusercontent.com/openSUSE/open-build-service/$branch/dist/t/Makefile", 240);
    assert_script_run("make install", 840);
    assert_script_run("cd /tmp/open-build-service/dist/t");
    assert_script_run("set -o pipefail; prove -v *-check_required_services.ts | tee /tmp/check_required_services_tests.txt", 300);
    assert_script_run("set -o pipefail; bundle exec rspec --format documentation | tee /tmp/rspec_tests.txt", 600);
    save_screenshot;
    upload_logs("/tmp/check_required_services_tests.txt");
    upload_logs("/tmp/rspec_tests.txt");
}

sub test_flags() {
    return {important => 1};
}

sub post_fail_hook {
    upload_logs("/tmp/check_required_services_tests.txt", failok => 1);
    upload_logs("/tmp/rspec_tests.txt", failok => 1);
    script_run("tar cvfj /tmp/capybara_screens.tar.bz2 /tmp/rspec_screens/*");
    upload_logs("/tmp/capybara_screens.tar.bz2", failok => 1);
    script_run("tar cvfj /tmp/srv_www_obs_api_logs.tar.bz2 /srv/www/obs/api/log/*");
    upload_logs("/tmp/srv_www_obs_api_logs.tar.bz2", failok => 1);
    script_run("tar cvfj /tmp/srv_obs_build.tar.bz2 /srv/obs/build/*");
    upload_logs("/tmp/srv_obs_build.tar.bz2", failok => 1);
    script_run("tar cvfj /tmp/srv_obs_log.tar.bz2 /srv/obs/log/*");
    upload_logs("/tmp/srv_obs_log.tar.bz2", failok => 1);
    script_run("tar cvfj /tmp/zypper_log.tar.bz2 /var/log/zypper.log");
    upload_logs("/tmp/zypper_log.tar.bz2", failok => 1);
}

1;

# vim: set sw=4 et:
