#!/usr/bin/perl
# For WIFI Cam
# To Get Cam GET /videostream.cgi?loginuse=admin&loginpas=  but if pass default is not empty brute it

use LWP::UserAgent;

system $^O eq 'MSWin32' ? 'cls' : 'clear';

print "\t\n       WifiCam grabber\n\n\n";


open(op,"<$ARGV[0]") or die "$!";
while(<op>){
chomp($ips = $_);

my $ua = LWP::UserAgent->new();

$ua->agent("Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36");

my $req = $ua->get("http://".$ips."/")->header('Www-Authenticate');

if($req =~/WIFICAM/) {

 print " [".$ips."] => WIFICAM Detected \n";


}
}
