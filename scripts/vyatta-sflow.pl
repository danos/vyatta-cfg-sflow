#! /usr/bin/perl
# Copyright (C) 2012-2015 Vyatta, Inc.
# Copyright (c) 2019, AT&T Intellectual Property.
# All Rights Reserved.

# SPDX-License-Identifier: GPL-2.0-only

use strict;
use lib '/opt/vyatta/share/perl5';
use warnings;
use Getopt::Long;
use Module::Load::Conditional qw[can_load];
use Vyatta::Config;
use Vyatta::VPlaned;

my $vrf_available = can_load( modules => { "Vyatta::VrfManager" => undef },
	autoload => "true" );

# Vyatta config
my $config = new Vyatta::Config;

#
# main
#
my ( $cmd, $proto, $state, $param );
my $rd_id = "";

GetOptions(
    "cmd=s"   => \$cmd,
    "proto=s" => \$proto,
    "state=s" => \$state,
    "param=s" => \$param,
);

my $ctrl = new Vyatta::VPlaned;

if ( $vrf_available && $proto eq "server" &&
        $config->exists("service sflow server-address $state routing-instance")) {
    $rd_id = Vyatta::VrfManager::get_vrf_id($config->returnValue(
        "service sflow server-address $state routing-instance"));
}

if ( $cmd =~ /enable/ ) {
    $ctrl->store(
            "service sflow $proto $state $param $rd_id",
            "sflow set $proto $state $param $rd_id"

    );
}
elsif ( $cmd =~ /disable/ ) {
    $ctrl->store(
            "service sflow $proto $state $param $rd_id",
            "sflow del $proto $state $param $rd_id"
    );
}
