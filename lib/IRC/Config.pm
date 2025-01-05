# lib/IRC/Config.pm
package IRC::Config;
use strict;
use warnings;
use DBI;
use IRC::Persistence;

sub load_config {
    IRC::Persistence::init_db();
    my $dbh = DBI->connect("dbi:SQLite:dbname=1rc_client.db", "", "", { RaiseError => 1 });
    my $sth = $dbh->prepare("SELECT key, value FROM config");
    $sth->execute();
    my %config;
    while (my @row = $sth->fetchrow_array) {
        $config{$row[0]} = $row[1];
    }
    return \%config;
}

1;
