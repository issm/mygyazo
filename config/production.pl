use 5.16.0;
use warnings;
use utf8;
use File::Basename;
use File::Spec;
my $basedir = File::Spec->catdir( File::Spec->rel2abs(dirname __FILE__), '..' );
do 1 while $basedir =~ s!/[^/]+/\.\.!!;

+{
    'base_url' => '',
    'path' => {
        imgdir => '',
    },
};
