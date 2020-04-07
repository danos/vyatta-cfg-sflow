#! /usr/bin/perl

use warnings;
use strict;

use File::Basename;
use Google::ProtocolBuffers;

my ($proto_file, $proto_dir, $proto_suffix) = fileparse($ARGV[0], qr/\Q.proto\E/);
my $target_dir = $ARGV[1];

if ($proto_suffix eq ".proto") {

    my %options;
    $options{include_dir} = "$proto_dir";

    $options{include_dir} = $ENV{'PROTO_PATH'} if defined ($ENV{'PROTO_PATH'});

    my $pb_pm = $proto_file . ".pm";
    $options{generate_code} = $target_dir . "/$pb_pm";

    printf("writing out to: " . $target_dir . "/$pb_pm" . "\n");

    $options{create_accessors} = 1;
    $options{follow_best_practice} = 1;
    Google::ProtocolBuffers->parsefile($ARGV[0], \%options);
}

exit 0;
