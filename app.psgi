use CHI;
use Mojo::Server::PSGI;
use Plack::Builder;
use FindBin;
use lib "$FindBin::Bin/lib";
use Mose;

use strict;

$ENV{MOJO_MAX_MESSAGE_SIZE} = 10_000_000;

my $psgi = Mojo::Server::PSGI->new( app => Mose->new );

builder {
    enable 'Session::Simple',
      store =>
      CHI->new( driver => 'FastMmap', root_dir => "$FindBin::Bin/cache" ),
      cookie_name => 'mose';
    $psgi->to_psgi_app;
};
