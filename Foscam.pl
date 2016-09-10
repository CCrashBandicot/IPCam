#!/usr/bin/perl
# For Grabb FosCam
# Use //proc/kcore vuln or test this path /videostream.cgi?user=admin&pwd=

use LWP::UserAgent;

system $^O eq 'MSWin32' ? 'cls' : 'clear';

print "\t\n       FosCam grabber\n\n\n";


open(op,"<$ARGV[0]") or die "$!";
while(<op>){
chomp($ips = $_);

my $ua = LWP::UserAgent->new();

$ua->agent("Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36");

my $req = $ua->get("http://".$ips."/")->header('server');

if($req =~/Netwave IP Camera/) {


print " [".$ips."] => FosCam Detected \n";

open(foscam, ">>foscam_grabbed.txt");
print foscam $ips."\n";
close foscam;



}
}
