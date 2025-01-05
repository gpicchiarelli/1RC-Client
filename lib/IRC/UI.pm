package IRC::UI;
use Term::ANSIColor;
use warnings;
use strict;

# Dichiarazione globale delle finestre
our $input_line;

sub refresh_screen {
    system("clear");
    print colored($input_line, 'bold green');
    print "\n" . ('-' x 80) . "\n";
    print colored('Command: ', 'bold blue');
}

sub get_input {
    # Cancella la linea di input precedente
    print colored(' ' x 70, 'bold blue') . "\rCommand: ";
    
    # Ottieni la stringa di input
    my $input = <STDIN>;
    chomp $input;
    
    # Ritorna l'input dell'utente
    return $input;
}

sub start_ui {
    my ($client) = @_;

    $input_line = '';

    refresh_screen();  # Aggiorna lo schermo

    while (1) {
        my $input = get_input();  # Ottieni l'input dall'utente
        process_command($client, $input);  # Elabora il comando
    }
}

sub process_command {
    my ($client, $input) = @_;
    if ($input =~ m{^/(\w+)(?:\s+(.*))?}) {
        my ($cmd, $args) = ($1, $2);
        if ($cmd eq 'join') {
            $client->{sock}->send("JOIN $args\r\n");
        } elsif ($cmd eq 'part') {
            $client->{sock}->send("PART $args\r\n");
        } elsif ($cmd eq 'msg') {
            my ($target, $message) = split /\s+/, $args, 2;
            $client->{sock}->send("PRIVMSG $target :$message\r\n");
        } elsif ($cmd eq 'nick') {
            $client->{sock}->send("NICK $args\r\n");
        } elsif ($cmd eq 'topic') {
            $client->{sock}->send("TOPIC $args\r\n");
        } elsif ($cmd eq 'kick') {
            my ($channel, $user) = split /\s+/, $args, 2;
            $client->{sock}->send("KICK $channel $user\r\n");
        } elsif ($cmd eq 'ban') {
            my ($channel, $user) = split /\s+/, $args, 2;
            $client->{sock}->send("MODE $channel +b $user\r\n");
        } elsif ($cmd eq 'list') {
            $client->{sock}->send("LIST\r\n");
        } elsif ($cmd eq 'whois') {
            $client->{sock}->send("WHOIS $args\r\n");
        } elsif ($cmd eq 'invite') {
            my ($user, $channel) = split /\s+/, $args, 2;
            $client->{sock}->send("INVITE $user $channel\r\n");
        } elsif ($cmd eq 'quit') {
            $client->{sock}->send("QUIT :$args\r\n");
            system("clear");
            exit;
        }
    } else {
        $client->{sock}->send("PRIVMSG $client->{channel} :$input\r\n");
    }
    $input_line .= "\n$input";  # Aggiungi l'input alla linea di comando
    refresh_screen();
}

1;
