use 5.16.0;
use warnings;
use Plack::Builder;
use File::Basename;
use File::Spec;
use lib File::Spec->catdir(dirname(__FILE__), 'lib');
use MyGyazo::Util;
use MyGyazo::Web::Upload;
use MyGyazo::Web::Image;

builder {
    enable 'ReverseProxy';
    mount '/upload/' => MyGyazo::Web::Upload->to_app();
    mount '/img/' => MyGyazo::Web::Image->to_app();
    mount '/' => sub {
        return [ 200, [ 'Content-Type' => 'text/plain' ], [ 'hello' ] ];
    };
};
