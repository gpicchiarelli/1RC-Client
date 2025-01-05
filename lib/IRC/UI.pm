package IRC::UI;
use Term::ReadLine;
use Term::ANSIColor;
use warnings;
use strict;

# Dichiarazione globale delle finestre
our $term;
our $input;

sub run {
    # Crea un oggetto Term::ReadLine
    $term = Term::ReadLine->new('1RC-Client');
    my $prompt = colored("1RC-Client>:", 'bold green');
    my $OUT = $term->OUT || \*STDOUT;

    print colored("\n=== 1RC-Client ===", 'bold');
    print colored("\n=== https://github.com/gpicchiarelli/1RC-Client ===\n\n", 'bold');
        
    while (defined (my $input = $term->readline($prompt))) {
        chomp $input;
        $input =~ s/^\s+|\s+$//g;  # Rimuove spazi iniziali e finali

        # Gestione dei comandi
        if ($input eq 'help') {
            print_help($OUT);
        }
        elsif ($input eq 'exit' || $input eq 'quit') {
            print colored("\nUscita dalla CLI. Arrivederci!\n", 'bold green');
            last;
        }
        elsif ($input eq 'connect-server') {
            print colored("\nConnect to $input\n", 'bold magenta');
            
        }else {
            print colored("Comando non riconosciuto. Digita 'help' per la lista dei comandi.\n", 'bold red');
        }
        # Aggiunge l'input alla cronologia
        $term->addhistory($input) if $input;
    }
    if (defined($input)){
        # Aggiungi la linea di input alla cronologia
        $term->addhistory($input) if $input =~ /\S/;
    }
    # Ritorna l'input dell'utente
    return $input;
}

# Funzione per stampare l'help
sub print_help {
    my ($OUT) = @_;
    print colored("\n=== Comandi disponibili ===\n", 'bold cyan');
    print colored("  help                      ", 'red black'), "Mostra questo messaggio di aiuto.\n";
    print colored("  exit | quit               ", 'red black'), "Esce dalla CLI.\n";
    print colored("  connect                 ", 'black black'), "Esegue la connessione al server.\n";
}

1;
