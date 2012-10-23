#       VelvetOpt::hwrap.pm
#
#       Copyright 2008 Simon Gladman <simon.gladman@monash.edu>
#
#       This program is free software; you can redistribute it and/or modify
#       it under the terms of the GNU General Public License as published by
#       the Free Software Foundation; either version 2 of the License, or
#       (at your option) any later version.
#
#       This program is distributed in the hope that it will be useful,
#       but WITHOUT ANY WARRANTY; without even the implied warranty of
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#       GNU General Public License for more details.
#
#       You should have received a copy of the GNU General Public License
#       along with this program; if not, write to the Free Software
#       Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#       MA 02110-1301, USA.
#
#		Version 1.1 - 14/07/2010 - Added support for changing input file types
#		Version 1.2 - 11/08/2010 - Changed velveth help parser for new velvet help format
#									Thanks to Alexie Papanicolaou - CSIRO for the patch.
#		Version 1.3 - 05/10/2012 - Added support for new velveth options

package VelvetOpt::hwrap;

=head1 NAME

VelvetOpt::hwrap.pm - Velvet hashing program wrapper module.

=head1 AUTHOR

Simon Gladman, CSIRO, 2007, 2008.

=head1 LICENSE

Copyright 2008 Simon Gladman <simon.gladman@csiro.au>

       This program is free software; you can redistribute it and/or modify
       it under the terms of the GNU General Public License as published by
       the Free Software Foundation; either version 2 of the License, or
       (at your option) any later version.

       This program is distributed in the hope that it will be useful,
       but WITHOUT ANY WARRANTY; without even the implied warranty of
       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
       GNU General Public License for more details.

       You should have received a copy of the GNU General Public License
       along with this program; if not, write to the Free Software
       Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
       MA 02110-1301, USA.

=head1 SYNOPSIS

    use VelvetOpt::hwrap;
    use VelvetOpt::Assembly;
    my $object = VelvetOpt::Assembly->new(
        timestamph => "23 November 2008 15:00:00",
        ass_id => "1",
        versionh => "0.7.04",
        pstringh => "test 21 -fasta test_reads.fna",
        ass_dir => "/home/gla048/Desktop/newVelvetOptimiser/data_1"
    );
    my $worked = VelvetOpt::hwrap::objectVelveth($object);
    if($worked){
        print $object->toString();
    }
    else {
        die "Error in velveth..\n" . $object->toString();
    }

=head1 DESCRIPTION

A wrapper module to run velveth on VelvetAssembly objects or on velveth
parameter strings. Also contains private methods to check velveth
parameter strings, run velveth and return results.

=head2 Uses

=over 8

=item strict

=item warnings

=item Carp

=item VelvetOpt::Assembly

=item POSIX qw(strftime)

=back

=head2 Private Fields

=over 8

=item interested

STDERR printing debug message toggle.  1 for on, 0 for off.

=back

=head2 Methods

=over 8

=item _runVelveth

Private method which runs velveth with the supplied velveth parameter string and returns velveth output messages as a string.

=item _checkVHString

Private method which checks for a correctly formatted velveth string.  Returns 1 or 0.

=item objectVelveth

Accepts a VelvetAssembly object and the number of categories velvet was compiled with, looks for the velveth parameter string it contains, checks it, sends it to _runVelveth, collects the results and stores them in the VelvetAssembly object.

=item stringVelveth

Accepts a velveth parameter string and the number of categories velvet was compiled with, checks it, sends it to _runVelveth and then collects and returns the velveth output messages.

=back

=cut

use warnings;
use strict;
use Carp;
use VelvetOpt::Assembly;
use POSIX qw(strftime);

my $interested = 0;

my $cats;
my $maxkmerlength;
my %Fileformats;
my %Readtypes;
my %Otheroptions;
my %Filelayouts;

my $usage;
my $inited = 0;

sub init {
	#run a velveth to get its help lines..
	my $response = &_runVelveth(" ");
	
	#get the categories
	$response =~ m/CATEGORIES = (\d+)/;
	$cats = $1;
	unless($cats){$cats = 2;}
	
	#get the maxkmerlength
	$response =~ m/MAXKMERLENGTH = (\d+)/;
	$maxkmerlength = $1;
	
	#get the file format options
	$response =~ m/(File format options:(.*)\(Note:)/s;
	splitVHOptions($1, \%Fileformats);
	
	#get the file layouts
	unless($response =~ m/File layout options for paired reads.*:\n(.*)Read type options:/s){ warn "No match for file layout options\n$!";}
	splitVHOptions($1, \%Filelayouts);
	
	#get the read type options
	$response =~ m/(Read type options:(.*)Options:)/s;
	splitVHOptions($1, \%Readtypes);
	
	#get the other options
	$response =~ m/\nOptions:(.*)Synopsis:/s;
	splitVHOptions($1, \%Otheroptions);
	
	#make up the standard usage for velveth parameter strings...
	$usage = "Incorrect velveth parameter string: Needs to be of the form\n{[-file_layout][-file_format][-read_type] filename} or {-other_option}\n";
	$usage .= "Where:\nFile layout options (for paired end reads):\n";
	foreach my $key(sort keys %Filelayouts){
		$usage .= "\t$key\n";
	}
	$usage .= "File format options:";
	foreach my $key (sort keys %Fileformats){
		$usage .= "\t$key\n";
	}
	$usage .= "Read type options:\n";
	foreach my $key (sort keys %Readtypes){
		$usage .= "\t$key\n";
	}
	$usage .= "Other options:\n";
	foreach my $key (sort keys %Otheroptions){
		$usage .= "\t$key\n";
	}
	$usage .= "\nThere can be more than one filename specified as long as its a different type.\nStopping run\n";
	
	#set inited to 1
	$inited = 1;
}

sub splitVHOptions {
	my $section = shift;
	my $opts = shift;
	my @t = split /\n/, $section;
	foreach(@t){
		#if(/\s+(-\S+)/){
		while(/\s+(-\S+)/g){
			$opts->{$1} = 1;
		}
	}
}

sub _runVelveth {
	#unless($inited){ &init(); }
    my $cmdline = shift;
    my $output = "";
    print STDERR "About to run velveth!\n" if $interested;
    $output = `velveth $cmdline`;
    $output .= "\nTimestamp: " . strftime("%b %e %Y %H:%M:%S", localtime) . "\n";
    return $output;
}

sub _checkVHString {
    unless($inited){ &init(); }
	print STDERR $usage if $interested;
	my $line = shift;
	my $useless = shift;
	
	print STDERR "\tIN checkVHString: About to test $line\n" if $interested;
	
	my $ok = 1;
	
	#first remove all "other" options.
	foreach(keys %Otheroptions){
		$line =~ s/$_//;
	}
	
	#get each m/-options+ filename+/ block
	my @blocks;
    $line =~ s/^/ /;
    while ($line =~ m/(\b(-[\w\d]+\s+)+[\w\/\\\. ]+)/g) {
		my $text = $1;
        $text =~ s/\s+$//;
		push @blocks, $text;
	}
	
	#look at each block in turn
	foreach my $block(@blocks) {
		my $blockgood = 1;
		my $numfiles = 0;
		my $formatused = 0;
		my $layoutused = 0;
		my $readused = 0;
		my $separate = 0;
		my $paired = 0;
		my @files_to_check;
		
		print STDERR "\tIN checkVHString: Block being checked: $block\n" if $interested;
		
		my @t = split /\s+/, $block;
		
		#look at each part of the block
		foreach my $x(@t){
			#check if its an option, otherwise its a filename...
			unless($x =~ m/^-/){
				push @files_to_check, $x; 
				$numfiles ++;
				next;
			}
			#make sure its a valid option.
			#check file formats first
			if($Fileformats{$x}){
				$formatused ++;
			}
			elsif($Filelayouts{$x}){
				$layoutused ++;
			}
			elsif($Readtypes{$x}){
				$readused ++;
				$paired ++ if $x =~ m/Paired/;
			}
			else {
				$blockgood = 0;
				if($x =~ m/(\d+)$/){
					carp "*** Category number $1 in $x higher than that velvet compiled with ($cats)\n";
				}
				else {
					carp "*** Unknown option used: $x in file block: $block\n";
				}
				
			}
			if($x eq "-separate"){
				$separate = 1;
			}
		}
		
		#make sure only 1 filetype, format and readtype is used in each block
		if($formatused > 1){
			carp "*** Too many file formats used in block: $block\n";
			$blockgood = 0;
		}
		if($layoutused > 1){
			carp "*** Too many file layouts used in block: $block\n";
			$blockgood = 0;
		}
		if($readused > 1){
			carp "*** Too many read type specifications used in block: $block\n";
			$blockgood = 0;
		}
		
		#check appropriate number of files if separate..
		if($separate && $numfiles != 2){
			carp "*** $numfiles files specified for -separate option in block: $block. Require exactly 2.\n";
			$blockgood = 0;
		}
		
		#check if paired read type option was chosen...
		if($separate && !$paired){
			carp "*** -separate chosen without valid Paired read type specified in block: $block. Need to specify either -shortPaired or -longPaired\n";
			$blockgood = 0;
		}
		
		#make sure files are readable..
		foreach my $file(@files_to_check){
			unless(-r $file){
				$blockgood = 0;
				carp "*** File $file doesn't exist or is unreadable.\n";
			}
		}
		unless($blockgood){ print STDERR "Block $block FAILED!\n"}
		
		#if block is no good then whole thing is no good...
		$ok = $blockgood;
	}
	
	return $ok;
	
	
	
}

sub objectVelveth {
    unless($inited){ &init(); }
    my $va = shift;
	my $cats = shift;
    my $cmdline = $va->{pstringh};
    if(_checkVHString($cmdline, $cats)){
        $va->{velvethout} = _runVelveth($cmdline);
        my @t = split /\n/, $va->{velvethout};
        $t[$#t] =~ s/Timestamp:\s+//;
        $va->{timestamph} = $t[$#t];
        return 1;
    }
    else {
        $va->{velvethout} = "Formatting errors in velveth parameter string.$usage";
        return 0;
    }
}

sub stringVelveth {
	unless($inited){ &init(); }
    my $cmdline = shift;
	my $cats = shift;
    if(_checkVHString($cmdline,$cats)){
        return _runVelveth($cmdline);
    }
    else {
        return "Formatting errors in velveth parameter string.$usage";
    }
}

1;
