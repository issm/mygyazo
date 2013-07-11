package MyGyazo::Util;
use 5.16.0;
use warnings;
use utf8;
use parent 'Exporter';
use Data::Dumper qw/Dumper/;
use File::Basename;
use File::Spec;
use Time::Piece ();

our @EXPORT = qw/ D Dc t base_dir config /;

sub D  { Dumper @_ }
sub Dc { return "[32m" . (Dumper @_) . "[0m" }

sub t {
    my (@args) = @_;
    if ( @args == 2 ) { return Time::Piece->strptime(@args) }
    else              { return Time::Piece::localtime( $args[0] // time ) }
}

sub base_dir {
    my $dir = File::Spec->catdir( File::Spec->rel2abs(dirname __FILE__), '..', '..' );
    do 1 while $dir =~ s!/[^/]+/\.\.!!;
    return $dir;
}

sub config {
    my $env = $ENV{PLACK_ENV} // 'development';
    my $file = "@{[ base_dir() ]}/config/${env}.pl";
    my $config = do $file  or  die "message:$!  file:$file";
    {
        no strict 'refs';
        no warnings 'redefine';
        my $caller = caller;
        *{"$caller\::config"} = sub { $config };
    }
    return $config;
}

1;
