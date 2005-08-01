use strict;
use Test::More tests => 3;
use Net::Jabber::Loudmouth;

require "t/server_helper.pl";

my $c = Net::Jabber::Loudmouth::Connection->new("localhost");

ok($c->open_and_block());

ok($c->authenticate_and_block("foo", "bar", "TestSuite"));

ok($c->close());
