# lib/IRC/Core.pm
package IRC::Core;
use IO::Socket::INET;
use DBI;

sub new {
    my ($class, %args) = @_;
    return bless { %args }, $class;
}

sub connect {
    my $self = shift;
    my $sock = IO::Socket::INET->new(
        PeerAddr => $self->{server},
        PeerPort => $self->{port},
        Proto    => 'tcp'
    ) or die "Unable to connect: $!";

    $self->{sock} = $sock;
    $self->_login();
}

sub _login {
    my $self = shift;
    my $sock = $self->{sock};
    print $sock "NICK $self->{nick}\r\n";
    print $sock "USER $self->{nick} 0 * :$self->{nick}\r\n";
    print $sock "JOIN $self->{channel}\r\n";
}

1;
