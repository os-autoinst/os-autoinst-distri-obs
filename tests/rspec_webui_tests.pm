use base "basetest";
use strict;
use testapi;

sub run() {
    my $branch = "master";
    if (get_var('VERSION') != "Unstable") {
        $branch = get_var('VERSION');
    }

    assert_script_run("git clone --single-branch --branch $branch --depth 1 https://github.com/openSUSE/open-build-service.git  /tmp/open-build-service", 240);
    assert_script_run("cd /tmp/open-build-service/dist/t");
    # download.o.o temporarily down
    assert_script_run("mkdir /etc/zypp/repos.d/old");
    assert_script_run("mv /etc/zypp/repos.d/*.repo /etc/zypp/repos.d/old");
    assert_script_run("zypper ar -f -c https://ftp.gwdg.de/pub/opensuse/repositories/OBS:/Server:/Unstable/openSUSE_42.2/OBS:Server:Unstable.repo");
    assert_script_run("sed -i 's|download.opensuse.org|ftp.gwdg.de/pub/opensuse|' /etc/zypp/repos.d/OBS_Server_Unstable.repo");
    assert_script_run("zypper ref");
    # download.o.o temporarily down
    assert_script_run("zypper -vv -n --gpg-auto-import-keys in --force-resolution --no-recommends phantomjs libxml2-devel libxslt-devel ruby2.4-devel", 600);
    assert_script_run("bundle.ruby2.4 install", 600);
    assert_script_run("set -o pipefail; bundle.ruby2.4 exec rspec --format documentation | tee /tmp/rspec_tests.txt", 600);
    save_screenshot;
    upload_logs("/tmp/rspec_tests.txt");
}

sub test_flags() {
    return {important => 1};
}

sub post_fail_hook {
    assert_script_run("tar cvfj /tmp/capybara_screens.tar.bz2 /tmp/rspec_screens/*");
    upload_logs("/tmp/capybara_screens.tar.bz2");
    assert_script_run("tar cvfj /tmp/srv_www_obs_api_logs.tar.bz2 /srv/www/obs/api/log/*");
    upload_logs("/tmp/srv_www_obs_api_logs.tar.bz2");
    assert_script_run("tar cvfj /tmp/srv_obs_build.tar.bz2 /srv/obs/build/*");
    upload_logs("/tmp/srv_obs_build.tar.bz2");
    assert_script_run("tar cvfj /tmp/srv_obs_log.tar.bz2 /srv/obs/log/*");
    upload_logs("/tmp/srv_obs_log.tar.bz2");
}

1;

# vim: set sw=4 et:
