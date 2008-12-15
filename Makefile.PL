use inc::Module::Install;

name           'Term-TransKeys';
all_from       'lib/Term/TransKeys.pm';
requires       'Term::ReadKey'  => '2.30';

WriteAll;
