package App::Yath::Plugin::YathUIDB;

use strict;
use warnings;

our $VERSION = '0.000146';

use Test2::Harness ();

sub new {
    shift; # No need to unpack, but I do want to reset class name.
    if( $Test2::Harness::VERSION gt "2" ) {
        require App::Yath::Plugin::YathUIDB::v2;
        return App::Yath::Plugin::YathUIDB::v1->new(@_);
    }
    require App::Yath::Plugin::YathUIDB::v1;
    return App::Yath::Plugin::YathUIDB::v1->new(@_);
}

1;

__END__

=head1 NAME

App::Yath::Plugin::YathUIDB

=head1 DESCRIPTION

Factory module for giving you the Yath UI reporting opts in yath.

=head1 SYNOPSIS

Since all uses of this are internal to yath itself, providing usage examples aren't relevant in this context.

=head2 SEE ALSO

App::Yath::Plugin::YathUIDB::v1

App::Yath::Plugin::YathUIDB::v2

=cut
