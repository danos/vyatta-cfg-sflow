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

use vyatta::proto::SFlowConfig;

my $vrf_available = can_load(
    modules  => { "Vyatta::VrfManager" => undef },
    autoload => "true"
);

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

if (   $vrf_available
    && $proto eq "server"
    && $config->exists("service sflow server-address $state routing-instance") )
{
    $rd_id = Vyatta::VrfManager::get_vrf_id(
        $config->returnValue(
            "service sflow server-address $state routing-instance")
    );
}

sub PackSubmsg {
    my ($option) = @_;

    if ( $option eq "server" ) {
        my $serverconfig = { address => $state, port => $param };
        $serverconfig->{vrf_id} = $rd_id if ( $rd_id ne "" );
        return "server", Server->new($serverconfig);
    } elsif ( $option eq "agent-address" ) {
        return "agent", AgentAddress->new( { address => $state } );
    } elsif ( $option eq "polling-interval" ) {
        return "poll", PollInterval->new( { interval => $state } );
    } elsif ( $option eq "sampling-rate" ) {
        return "sample", SampleRate->new( { rate => $state } );
    } else {
        die("Incorrect command parameter: $option\n");
    }
}

my $setting;
if ( $cmd =~ /enable/ ) {
    $setting = SFlowConfig::Setting::SET;
} elsif ( $cmd =~ /disable/ ) {
    $setting = SFlowConfig::Setting::DELETE;
} else {
    die("Incorrect command name: $cmd\n");
}

my ( $msgName, $msgContents ) = PackSubmsg($proto);

my $sflowconfig = SFlowConfig->new(
    {
        command  => $setting,
        $msgName => $msgContents
    }
);
$ctrl->store_pb( "service sflow $proto $state $param $rd_id",
    $sflowconfig, "vyatta:sflow" );
