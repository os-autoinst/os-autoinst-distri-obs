use base "basetest";
use strict;
use testapi;

my $setup_script;

sub upgrade_script() {
  script_run("echo -en \"[client]\nuser = root\npassword = opensuse\n\" > /root/.my.cnf");
  $setup_script .= "
    zypper ms --disable openSUSE/13.2:Update
    zypper ms --disable openSUSE:13.2
    zypper rs OBS:Server:2.6
    zypper rs openSUSE:Tools
    zypper -n --gpg-auto-import-keys ar http://download.opensuse.org/repositories/OBS:/Server:/Unstable/openSUSE_42.1/OBS:Server:Unstable.repo
    zypper -n ref -s
    rpm -e ruby2.1-rubygem-passenger rubygem-passenger rubygem-passenger-apache2
    zypper -n dup --download in-advance
    update-alternatives --set rake /usr/bin/rake.ruby.ruby2.3
    cd /srv/www/obs/api/; RAILS_ENV=\"production\" rake db:migrate
    chown -R wwwrun.www /srv/www/obs/api/log
    chown -R wwwrun.www /srv/www/obs/api/tmp
    service apache2 restart
    service obsapidelayed restart
    service memcached restart
    # Steps only needed for test
    zypper -n --no-gpgchecks ar http://download.opensuse.org/repositories/devel:/languages:/perl/openSUSE_42.1/devel:languages:perl.repo
    # workaround for bug in zypper on 13.2
    echo \"repo_gpgcheck = off\" >> /etc/zypp/zypp.conf
    echo \"pkg_gpgcheck = off\" >> /etc/zypp/zypp.conf
    zypper -n in perl-Devel-Cover
    #only to make sure, tests will succeed
    rm -rf /srv/obs/certs/*
    /usr/lib/obs/server/setup-appliance.sh --non-interactive
    rcapache2 restart
    make -C /tmp/open-build-service/dist test_system
    make -C /tmp/open-build-service/src/backend test_unit
    ";
    assert_script_run($setup_script, 1500);
    }
sub run() {
    upgrade_script();
    upload_logs("/tmp/zypp.log");
    upload_logs("/var/log/zypper.log");
  }

sub test_flags() {
    return {important => 1};
	}

  sub post_fail_hook {
    upload_logs("/var/log/zypper.log");
  }

1;
