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

# Vyatta config
my $config = new Vyatta::Config;

#
# main
#
my ( $cmd, $intf, $type, $vif ) = ("", "", "", "");

GetOptions(
    "cmd=s"   => \$cmd,
    "intf=s" => \$intf,
    "type=s"  => \$type,
    "vif=s"  => \$vif
);

if ($vif ne "") {
    $intf = "$intf.$vif";
}

my $ctrl = new Vyatta::VPlaned;

if ( $cmd =~ /enable/ ) {
    $ctrl->store(
            "interface $type sflow $intf",
            "sflow enable $intf"

    );
}
elsif ( $cmd =~ /disable/ ) {
    $ctrl->store(
            "interface $type sflow $intf",
            "sflow disable $intf"
    );
}
