# lib/IRC/UI.pm
package IRC::UI;
use Curses;
use IRC::Config;

my ($win, $input_win, $sidebar_win);

sub start_ui {
    my ($client) = @_;
    initscr();
    start_color();
    cbreak();
    noecho();
    keypad(stdscr, 1);
    curs_set(1);

    # Setup windows
    my $height = LINES - 3;
    my $width = COLS - 30;
    $win = newwin($height, $width, 0, 0);
    $input_win = newwin(3, $width, $height, 0);
    $sidebar_win = newwin(LINES, 30, 0, $width);

    scrollok($win, 1);
    box($input_win, 0, 0);
    box($sidebar_win, 0, 0);

    refresh_windows();

    while (1) {
        my $input = get_input();
        process_command($client, $input);
    }
}

sub refresh_windows {
    wrefresh($win);
    wrefresh($input_win);
    wrefresh($sidebar_win);
}

sub get_input {
    mvwprintw($input_win, 1, 1, " ");
    wrefresh($input_win);
    mvwgetstr($input_win, 1, 1);
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
            endwin();
            exit;
        }
    } else {
        $client->{sock}->send("PRIVMSG $client->{channel} :$input\r\n");
    }
    refresh_windows();
}

1;
