use strict;
use Test::More tests => 21;
use Glib qw/TRUE FALSE/;
use Net::Jabber::Loudmouth;

my $m = Net::Jabber::Loudmouth::Message->new('', 'message');
my $n = $m->get_node();
isa_ok($n, "Net::Jabber::Loudmouth::MessageNode");

is($n->get_name(), 'message');
is($n->get_value(), undef);
is($n->get_raw_mode(), FALSE);

$n->set_name('foo');
is($n->get_name(), 'foo');

$n->set_value('bar');
is($n->get_value(), 'bar');

$n->set_raw_mode(TRUE);
is($n->get_raw_mode(), TRUE);

my $child = $n->add_child('moo');
isa_ok($child, "Net::Jabber::Loudmouth::MessageNode");
is($child->get_name(), 'moo');
is($child->get_value(), undef);
is($child->get_raw_mode(), FALSE);

$child = $n->add_child('kooh', 'moo');
isa_ok($child, "Net::Jabber::Loudmouth::MessageNode");
is($child->get_name(), 'kooh');
is($child->get_value(), 'moo');
is($child->get_raw_mode(), FALSE);

$n->set_attributes(foo => 'bar', moo => 'kooh');
is($n->get_attribute('foo'), 'bar');
is($n->get_attribute('moo'), 'kooh');
is($n->get_attribute('mookooh'), undef);

$n->set_attributes(foo => 'mookooh');
is($n->get_attribute('foo'), 'mookooh');

$child = $n->get_child_by_name('kooh');
isa_ok($child, "Net::Jabber::Loudmouth::MessageNode");
is($child->get_value(), 'moo');
