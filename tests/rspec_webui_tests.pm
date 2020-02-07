use base "basetest";
use strict;
use testapi;

sub run() {
    my $branch = "master";
    my $tests_packages = "chromedriver xorg-x11-fonts";
    if (get_var('VERSION') != "Unstable") {
        $branch = get_var('VERSION');
        $tests_packages = "phantomjs" unless get_var('VERSION') == "2.10";
    }

    my $ruby_version = "2.5";

    assert_script_run("git clone --single-branch --branch $branch --depth 1 https://github.com/openSUSE/open-build-service.git  /tmp/open-build-service", 240);
    assert_script_run("cd /tmp/open-build-service/dist/t");
    assert_script_run("zypper -vv -n --gpg-auto-import-keys in --force-resolution --no-recommends $tests_packages libxml2-devel libxslt-devel ruby$ruby_version-devel", 600);
    assert_script_run("bundle.ruby$ruby_version install", 600);
    assert_script_run("set -o pipefail; bundle.ruby$ruby_version exec rspec --format documentation | tee /tmp/rspec_tests.txt", 600);
    save_screenshot;
    upload_logs("/tmp/rspec_tests.txt");
}

sub test_flags() {
    return {important => 1};
}

sub post_fail_hook {
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
