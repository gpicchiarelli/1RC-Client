# lib/IRC/Persistence.pm
package IRC::Persistence;
use DBI;

sub init_db {
    my $dbh = DBI->connect("dbi:SQLite:dbname=1rc_client.db", "", "", { RaiseError => 1 })
        or die $DBI::errstr;
    $dbh->do("CREATE TABLE IF NOT EXISTS logs (timestamp TEXT, channel TEXT, message TEXT)");
    $dbh->do("CREATE TABLE IF NOT EXISTS config (key TEXT PRIMARY KEY, value TEXT)");
    return $dbh;
}

1;
