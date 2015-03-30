#!/usr/bin/env perl

use warnings;
use strict;

my $filename = 'a.2xi';

open(my $fh, '<', $filename) or die "cant open $filename $!";

my $inside_farm=0;
my %data;
my %db;
my $farm_id;
my $farm_content;
my $hostname;

while(defined(my $line = <$fh>)){


	if($line =~ /\<farm id="\d+"\>/){
		$inside_farm=1;
#		print "\t$line";
	}elsif($line =~ /\<\/farm\>/){
		$inside_farm=0;
#		print "\t$line";
		$db{$hostname}=$farm_content;
		$hostname="";
		$farm_content="";
	}elsif($inside_farm == 1){
#		print "\t\t$line";

		if($line =~ /\<server port=.* primary_server=\"(.*)\" farmsession_id/){
			#print "found: $1\n";
			$hostname=$1;
		}

		chomp($line);
		$farm_content=$farm_content.$line;

	}else{
#		print "$line";
	}
}

print "<!DOCTYPE TUXASCML>\n<farms version=\"2\">\n";

my $count=0;

foreach my $hostname (sort keys %db){
	print "<farm id=\"".$count++."\">\n";
	print "$db{$hostname}\n";
	print "</farm>\n";
}
print "</farms>\n";
__END__
<farms version="2">
 <farm id="0">
  <credentials password="mOZaFSKWc6/55GXTYcMmxw==" use_scard="0" domain="ingres.prv" scard_reader="" username="tonju01" scard_pin="" sso="0" auto_logon="0" save_password="1"/>
  <server port="3389" mode="0" primary_server="usrcdc01.ingres.prv" farmsession_id="0" alias="" is_tserver="1" show_promotion="0" is_securerdp="0"/>
  <sec_conns/>
  <redirection keyboard="0" size="0" redirect_all_drives="0" printer="0" serial_port="0" display="2" drive="0" customheight="480" enable_hotplug="0" smart_card="0" sound="0" customwidth="640"/>
  <programs app_path="" programs_checked="0" folder_path=""/>
  <experience font_smoothing="0" themes="0" dragging="0" caching="1" desktop_background="0" animation="0" preset="0" desktop_composition="0"/>
  <proxy use_proxy="0" port="" password="" server="" username="" auth="0" type="0"/>
  <authentication auth_mode="0"/>
  <advanced enable_published_desktop_launcher="0" use_primary_monitor_only="0" span_desktops="1" use_prewin2000_format="0" client_system_settings="0" register_extensions="0" client_system_colors="0" enable_desktop_smart_sizing="0" create_shortcuts="1" redirect_mails="0" compression="1" enable_client_reconnect="0" host_name="" redirect_urls="0" connect_console="0"/>
 </farm>

