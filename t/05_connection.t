use strict;
use Test::More tests => 46;
use Test::Exception;
use Glib;
use Net::Jabber::Loudmouth;

my $c = Net::Jabber::Loudmouth::Connection->new("foobar");
isa_ok($c, "Net::Jabber::Loudmouth::Connection");

is($c->get_server(), "foobar");

dies_ok {$c->open_and_block()};

$c->set_server("localhost");
is($c->get_server(), "localhost");

is($c->get_jid(), undef);
$c->set_jid('foo@localhost');
is($c->get_jid(), 'foo@localhost');

is($c->get_port(), 5222);
$c->set_port(4333);
is($c->get_port(), 4333);
$c->set_port(5222);

is($c->get_ssl(), undef);
$c->set_ssl(Net::Jabber::Loudmouth::SSL->new(sub {}));
ok($c->get_ssl());
$c->set_ssl(undef);
is($c->get_ssl(), undef);

undef $c;
$c = Net::Jabber::Loudmouth::Connection->new("localhost");

is($c->get_proxy(), undef);
$c->set_proxy(Net::Jabber::Loudmouth::Proxy->new('http'));
ok($c->get_proxy());
$c->set_proxy(undef);
is($c->get_proxy(), undef);

undef $c;
$c = Net::Jabber::Loudmouth::Connection->new("localhost");

my $m = Net::Jabber::Loudmouth::Message->new('foo@localhost', 'message');
$m->get_node->add_child('body', 'bar');

dies_ok {$c->close()};
dies_ok {$c->authenticate()};
dies_ok {$c->send($m)};
dies_ok {$c->send_with_reply($m)};
TODO: {
	local $TODO = "loudmouth doesn't check if the connection is open before doing operations on the GSource elements";
#	dies_ok {$c->send_with_reply_and_block($m)};
}
dies_ok {$c->send_raw($m->get_node->to_string())};

is($c->get_state(), 'closed');
ok(!$c->is_open());
ok($c->open_and_block());
is($c->get_state(), 'open');
ok($c->is_open());
ok(!$c->is_authenticated());
ok($c->close());
ok(!$c->is_open());

my $loop = Glib::MainLoop->new();
ok($c->open(\&open_cb));
$loop->run();

sub open_cb {
	my ($connection, $success) = @_;
	isa_ok($connection, "Net::Jabber::Loudmouth::Connection");
	ok($success);
	ok($connection->is_open());
	ok(!$connection->is_authenticated());
	$loop->quit();
}

dies_ok {$c->authenticate_and_block("alnsldabsdasd", "", "TestSuite")};

ok($c->authenticate_and_block("foo", "bar", "TestSuite"));
TODO: {
	local $TODO = "is_authenticated() doesn't seem to work after authenticate_and_block() even if authed successful. A loudmouth bug?";
	is($c->get_state(), 'authenticated');
	ok($c->is_authenticated());
}
ok($c->close());
ok(!$c->is_authenticated());
ok($c->open_and_block());

ok($c->authenticate("foo", "bar", "TestSuite", \&auth_cb));
$loop->run();

sub auth_cb {
	my ($connection, $success) = @_;
	isa_ok($connection, "Net::Jabber::Loudmouth::Connection");
	ok($success);
	ok($connection->is_authenticated());
	$loop->quit();
}

$c->set_keep_alive_rate(20);

my $handler = Net::Jabber::Loudmouth::MessageHandler->new(sub {});
isa_ok($handler, "Net::Jabber::Loudmouth::MessageHandler");
$c->register_message_handler($handler, 'message', 'normal');
$c->unregister_message_handler($handler, 'message');

ok($c->send($m));
ok($c->send_raw($m->get_node->to_string()));

$c->set_disconnect_function(sub {});
