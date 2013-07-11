package MyGyazo::Web::Upload;
use 5.16.0;
use warnings;
use utf8;
use MyGyazo::Util;
use parent 'Plack::Component';
use Plack::Request;
use File::Basename;
use File::Path qw/make_path/;
use Time::HiRes ();
use Digest::SHA1 qw/sha1_hex/;
use File::Copy;

state $config = config();

sub call {
    my ($self, $env) = @_;
    my $req = Plack::Request->new( $env );
    my $up = $req->uploads->get( 'imagedata' );

    if ( $req->method ne 'POST' ) {
        return [
            405,
            [ 'Content-Type' => 'text/plain' ],
            [ 'method not allowed' ],
        ];
    }

    my $user_id = $req->param('id');
    my $img_id = sha1_hex( sprintf '%s::%010.8f', $user_id, Time::HiRes::time );

    my $imgdir = $config->{path}{imgdir};
    my $dest = sprintf(
        '%s/%s/%s/%s/%s.png',
        $imgdir,
        ( $img_id =~ /^(.)(.)(.)/ ),
        $img_id,
    );
    my $destdir = dirname $dest;
    make_path $destdir  if ! -d $destdir;
    move $up->path, $dest;

    my $url = sprintf '%simg/%s', $config->{base_url}, $img_id;

    return [
        200,
        [ 'Content-Type' => 'text/plain' ],
        [ $url ],
    ];
}

1;
