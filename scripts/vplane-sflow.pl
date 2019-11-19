#! /usr/bin/perl
# Copyright (C) 2012-2016 Vyatta, Inc.
# Copyright (c) 2019, AT&T Intellectual Property.
# All Rights Reserved.

# SPDX-License-Identifier: GPL-2.0-only

use strict;
use lib '/opt/vyatta/share/perl5';
use warnings;
use Getopt::Long;
use Vyatta::Config;
use Vyatta::VPlaned;

use vyatta::proto::SFlowConfig;

# Vyatta config
my $config = new Vyatta::Config;

#
# main
#
my ( $cmd, $intf, $type, $vif ) = ( "", "", "", "" );

GetOptions(
    "cmd=s"  => \$cmd,
    "intf=s" => \$intf,
    "type=s" => \$type,
    "vif=s"  => \$vif
);

if ( $vif ne "" ) {
    $intf = "$intf.$vif";
}

my $setting;
my $ctrl = new Vyatta::VPlaned;

if ( $cmd =~ /enable/ ) {
    $setting = SFlowConfig::Setting::ENABLE;
} elsif ( $cmd =~ /disable/ ) {
    $setting = SFlowConfig::Setting::DISABLE;
} else {
    die("Incorrect command name: $cmd\n");
}

my $sflowconfig = SFlowConfig->new(
    {
        ifname  => $intf,
        command => $setting,
    }
);

$ctrl->store_pb( "interface $type sflow $intf", $sflowconfig, "vyatta:sflow" );
