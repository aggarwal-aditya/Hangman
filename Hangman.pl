#!usr/bin/perl
use strict;
use feature 'say';
use experimental 'smartmatch';

#This is the intitial list of words
my @word_list=("computer","radio","calculator","teacher","bureau","police","geometry","president","subject","country","enviroment","classroom","animals","province","month","politics","puzzle","instrument","kitchen","language","vampire","ghost","solution","service","software","virus25","security","phonenumber","expert","website","agreement","support","compatibility","advanced","search","triathlon","immediately","encyclopedia","endurance","distance","nature","history","organization","international","championship","government","popularity","thousand","feature","wetsuit","fitness","legendary","variation","equal","approximately","segment","priority","physics","branche","science","mathematics","lightning","dispersion","accelerator","detector","terminology","design","operation","foundation","application","prediction","reference","measurement","concept","perspective","overview","position","airplane","symmetry","dimension","toxic","algebra","illustration","classic","verification","citation","unusual","resource","analysis","license","comedy","screenplay","production","release","emphasis","director","trademark","vehicle","aircraft","experiment");



#This is the subroutine whcih is responsible for new words addition
sub new_words(){
say "The game has learnt highfalutin words over the years, but if you would like to teach new words to the game press (1) else press (0)";
my $inp=<STDIN>;
chomp($inp);
if($inp==1)
{
	#We ask the user to enter the file path/name from where we should add new words. Each line in the file is considered a new word, accordingly the read strings from file are pushed to the word list
	say "Please Enter the name/path of file from where we should learn new words. It is expected that the file contains each new word in a new line";
	$inp=<STDIN>;
	chomp($inp);
	open(my$fh,"<",$inp);
	my $count=0;
	while(my $line=<$fh>){
	push(@word_list,$line);
	$count+=1;
	}
	close($fh);
	
	#If the file is empty/unreachable we exit and let the user know about it
	if($count){
	say "Thank you, we've updated our word list"
	}
	else{
	say "Couldnt find the file specefied/the file is empty";
	}	
}
}




#This subroutine checks if a given value is present in a given list
sub used{
	my $val=$_[0];
	my $ref=$_[1];
	my @arr=@$ref;
		
# We use for each loop to run a linear search in the list 	
	foreach my $char (@arr){
		if($char eq $val){
		return 1;
		}
	}
	return 0;
}


#This subroutine checks if the user has won by comparing the characters in the word to be guessed and the characters guessed by user
sub won{
	my $str=$_[0];
	my $ref=$_[1];
	my @arr=@$ref;
	my @word=@$str;
	
	#We use perl smart match feature which reuturns true if the particular character is found in an array. We check that if each character of the word to be guessed is present in the guessed characters array. If so the user has won.
	foreach my $char (@word){
	if(!($char ~~ @arr)){
		return 0;
	}
	}
	return 1;	
	
}


#This is standard subroutine to display the hanged man based on the number of lives left
sub disp_man{
	my $count=$_[0];
	if($count==0){
	say "  +---+ ";
        say "  |   | ";
    say"      | ";
    say"      | ";
    say"      | ";
    say"      | ";
    say" ========= ";
        
	}
	if($count==1){
	say"  +---+ ";
    say"  |   | ";
    say"  O   | ";
    say"      | ";
    say"      | ";
    say"      | ";
    say" ========= ";
	}
	if($count==2){
	 say"  +---+ ";
    say"  |   | ";
    say"  O   | ";
    say"  |   | ";
    say"      | ";
    say"      | ";
    say" ========= ";
	}
	
	if($count==3){
	 say"  +---+ ";
    say"  |   | ";
    say"  O   | ";
    say" /|   | ";
    say"      | ";
    say"      | ";
    say" ========= ";
	}
	
	if($count==4){
	 say"  +---+ ";
    say"  |   | ";
    say"  O   | ";
    say" /|\\  | ";
    say"      | ";
    say"      | ";
    say" ========= ";
	}
	
	if($count==5){
	 say"  +---+ ";
    say"  |   | ";
    say"  O   | ";
    say" /|\\  | ";
    say" /    | ";
    say"      | ";
    say" ========= ";
	}
	
	if($count==6){
	 say"  +---+ ";
    say"  |   | ";
    say"  O   | ";
    say" /|\\  | ";
    say" / \\  | ";
    say"      | ";
    say" ========= ";
	}	
}




#This the game module which is responsible for book keeping. It keeps track of the word to be guessed, the characters already guessed by user, lives remaining and calls other subroutines to check if the user has won/ whether the input is valid
sub game_module(){	
	my $wrong_guess_made=0;
	my $max_wrong_guess=6;
	my @all_guess=();
	my @wrong_guess=();
	my $index=int(rand(@word_list));
	my $to_be_guessed=$word_list[$index];
	$ to_be_guessed=lc($to_be_guessed);
	my @chars=split("",$to_be_guessed);
	disp_man(0);
	while($wrong_guess_made<$max_wrong_guess)
	{
		print("Here is your word: ");
		my $all_guess_ref=\@all_guess;
		my $chars_ref=\@chars;
		for (my $i=0;$i<(length($to_be_guessed));$i++){
		if(used($chars[$i],$all_guess_ref)){
		print("$chars[$i] ");
		}
		else
		{
			print("_ ");
			}
		}
		say "";
		my $inp;
		print("Miss so Far: [");
		foreach my $temp (@wrong_guess)
		{
			print($temp);
			print(" ");
		}
		print("]");
		say "";
		print("Make a guess: ");
		$inp=<>;
		$inp=lc($inp);
		chomp($inp);
		$inp=substr($inp,0,1);
		#We do some typechecking to ensure the user does not enter any invalid character
		if(!($inp=~/^[a-z]+$/)){
		say "Invalid Input";
		}
		else{
		#If the letter is already guessed we prompt the user.
			if(used($inp,$all_guess_ref))
			{
			say "You have already guessed this letter";
			}
			#This checks if the entered character is present in word.
			elsif(used($inp,$chars_ref))
			{
			say "Good Guess";
			push(@all_guess,$inp);
			}
			else
			{
			say "Wrong Guess";
			push(@all_guess,$inp);
			push(@wrong_guess,$inp);
			$wrong_guess_made+=1;
			}
		}
#Checks if we have won and to ensure easy book keeping we set $wrong_guess_made=0 
		if(won($chars_ref,$all_guess_ref)){
			$wrong_guess_made=0;
			last;
		}
			disp_man($wrong_guess_made);
	}
	
	if($wrong_guess_made)
	{
		say "You are hanged!(Lost)";
		say "The correct word was $to_be_guessed";
		return 0;
	}
	else
	{
		say "Wow you guessed $to_be_guessed . That was a tough one!";
		say "You survived!. Well Played!(Won)";
		return 1;
		
	}
	
}



my $con=1;
my $score=0;
say "\t\t\tWelcome to THE HANGMAN";
new_words();
while($con){
$score+=game_module();
$con+=1;
say "To Play Again Press any key, to exit press \"N\"";
my $re=<>;
chomp($re);
if(lc($re) eq "n"){
last;
}
}
$con-=1;
say "Your total score was $score/$con";










