# client_irc.pl - Entry Point
use strict;
use warnings;
use lib './lib';
use IRC::Core;
use IRC::UI;
use IRC::Config;

my $config = IRC::Config::load_config();

my $client = IRC::Core->new(
    server   => $config->{server} || 'irc.libera.chat',
    port     => $config->{port} || 6667,
    nick     => $config->{nick} || '1rc-client',
    channel  => $config->{channel} || '#test_channel'
);

$client->connect();
IRC::UI::start_ui($client);

