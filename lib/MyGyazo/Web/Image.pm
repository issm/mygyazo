package MyGyazo::Web::Image;
use 5.16.0;
use warnings;
use utf8;
use MyGyazo::Util;
use parent 'Plack::Component';
use Plack::Request;
use File::Basename;
use File::Path qw/make_path/;

state $config = config();

sub call {
    my ($self, $env) = @_;
    my $req = Plack::Request->new( $env );

    if ( $req->method ne 'GET' ) {
        return [
            405,
            [ 'Content-Type' => 'text/plain' ],
            [ 'method not allowed' ],
        ];
    }

    my ($img_id) = ( $req->path =~ m!^/(.{40})$! );
    my $file_glob = sprintf(
        '%s/%s/%s/%s/%s.*',
        $config->{path}{imgdir},
        ( $img_id =~ /^(.)(.)(.)/ ),
        $img_id,
    );
    my ($imgfile) = glob $file_glob;
    if ( ! $imgfile ) {
        return [
            404,
            [ 'Content-Type' => 'text/plain' ],
            [ 'not found' ],
        ];
    }

    open my $fh, '<', $imgfile  or return [
        500,
        [ 'Content-Type' => 'text/plain' ],
        [ 'cannot open file' ],
    ];

    return [
        200,
        [ 'Content-Type' => 'image/png' ],
        $fh,
    ];
}

1;
