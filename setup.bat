set PERL_CPANM_HOME=%cd%\cpan
perl cpanm -l extlib Module::CoreList
type modlist.txt |perl -Iextlib/lib/perl5 cpanm -n -L extlib
pause
