use inc::Module::Install;

name     'VelvetOptimiser';
all_from 'lib/VelvetOpt/Assembly.pm';
version  '2.24';
author   q{Simon Gladman <simon.gladman@csiro.au>};
license  'gpl';
perl_version '5.008';
requires_external_bin 'velveth';
requires_external_bin 'velvetg';
install_script 'VelvetOptimiser';

auto_install;

WriteAll;
