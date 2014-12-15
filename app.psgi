use Mojo::Server::PSGI;
use Plack::Builder;
use FindBin;
use lib "$FindBin::Bin/lib";
use Mose;
use strict;

my $psgi = Mojo::Server::PSGI->new( app => Mose->new );

builder {
    enable 'Runtime';
    $psgi->to_psgi_app;
};
