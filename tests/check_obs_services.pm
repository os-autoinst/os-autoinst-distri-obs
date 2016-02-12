use base "basetest";
use strict;
use testapi;

sub run() {
	my $check_enabled;
	my $check_active;
	my $service;
	my @obs_services = ("obsdispatcher", "obsservice", "obssrcserver", "obsapidelayed", "obsapisetup", "obsworker", "obspublisher", "mysql", "apache2");
	foreach $service (@obs_services) {
		$service = $service . ".service";
		my $check_enabled = "systemctl is-enabled ".$service;
	    my $check_active = "systemctl is-active ".$service;
	    validate_script_output $check_enabled, sub { m/^enabled$/ };
    	validate_script_output $check_active, sub { m/^active$/ };
	}
}

sub test_flags() {
    return {important => 1};
}

1;
