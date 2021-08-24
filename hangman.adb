-- CIS 3190 DE - Assignment 2
-- Author: Siri Chandana Kathroju
-- Student ID: 1002780
-- Date: 3/8/2021
-- Program: Game of Hangman by Dave Ahl, Digital. Converted to Fortran 77 by M.Writh, April 2012
--          Translating hang5.for from legacy Fortran to a modern Ada program hangman.adb through a process of reengineering via translation.

-- I/O routines for text from the library
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
-- Package to provide a random number generator to help generate a random integer from a specified range 
with Ada.Numerics.Discrete_Random;
-- Package to represent character values 
with Ada.Strings.Maps; use Ada.Strings.Maps;

procedure Hangman is

    -- Create a range of numbers
    type randRange is range 1..50;
	
    -- A new instance of the package is created, using a specified range
    package randInd is new ada.Numerics.Discrete_Random(randRange);
    use randInd;
	
    -- Random-value generator is initialized
    generator : randInd.Generator;

    -- Variable to display the hangman diagram
    hangman_diagram : array(1..12) of string(1..12);

    -- Variable for the user's guesses
    user_guesses : string(1..26);
    letter : character;

    -- Variable to store the Y/N answer
    user_answer : character;

    counter : integer;

    -- Variable of the length of the word in the dictoionary
    length_of_word : integer;

    -- Stores the word located in the dictionary
    word : string(1..20);

    -- Variable to hold the length of the guessed word
    length_of_guessed_word : integer;

    -- Variable to store the user's guessed word
    guessed_word : string(1..20);

    -- Variable to hold the length of the hidden word
    length_of_hidden_word : integer;

    -- Variable for the hidden word
    hidden_word : string(1..20);

    -- Variable to track number of guesses
    num_of_guesses : integer;

    -- Variable to replace the dash with the correct letter
    replaced_letter : integer;

    -- Variable to track the number of incorrect guesses
    num_of_incorrect_guess : integer;
    

    arr : array(randRange) of Boolean := (randRange => false);
    index_of_dictionary : randRange;
    length_of_dictionary : array(randRange) of integer := (
        3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5,
        6, 6, 6, 6, 6, 6, 7, 7, 7, 6, 7, 7, 8, 8, 8, 8, 8, 9, 9, 9, 9,
        9, 10, 11, 11, 10, 11, 19, 13);

	-- Dictionary of words
    dictionary : array(randRange) of string(1..20) := (
        "gum                 ", "sin                 ", "for                 ",
        "cry                 ", "lug                 ", "bye                 ",
        "fly                 ", "ugly                ", "each                ",
        "from                ", "work                ", "talk                ",
        "with                ", "self                ", "pizza               ",
        "thing               ", "feign               ", "fiend               ",
        "elbow               ", "fault               ", "dirty               ",
        "budget              ", "spirit              ", "quaint              ",
        "maiden              ", "escort              ", "pickax              ",
        "example             ", "tension             ", "quinine             ",
        "kidney              ", "replica             ", "sleeper             ",
        "triangle            ", "kangaroo            ", "mahogany            ",
        "sergeant            ", "sequence            ", "moustache           ",
        "dangerous           ", "scientist           ", "different           ",
        "quiescent           ", "magistrate          ", "erroneously         ",
        "loudspeaker         ", "phytotoxic          ", "matrimonial         ",
        "parasympathomimetic ", "thigmotropism       ");
begin
    -- Display the message when the game starts
    put_line("The Game of Hangman");

    counter := 1;
    while counter <= 50 loop
    
        -- Intializing the hangman diagram
        hangman_diagram(1) := (1..7 => 'X') & (1..5 => ' ');
        for i in 2..12 loop

            hangman_diagram(i)(1) := 'X';
            hangman_diagram(i)(2..12) := (2..12 => ' ');

        end loop;
        hangman_diagram(2)(7) := 'X';
        hidden_word := (1..20 => '-');
        user_guesses := (1..26 => ' ');

        num_of_incorrect_guess := 0;
        num_of_guesses := 0;
        
        -- Generates random words from the dictionary for hangman
        loop

            index_of_dictionary := Random(generator);
            if arr(index_of_dictionary) = false then
                exit;
            end if;

        end loop;

        arr(index_of_dictionary) := true;
        word := dictionary(index_of_dictionary);
        length_of_word := length_of_dictionary(index_of_dictionary);
        length_of_hidden_word := length_of_word;

        -- Displays dashes to represent the length of the hidden word
        put_line(hidden_word(1..length_of_hidden_word));

        while num_of_incorrect_guess <= 10 loop

            -- Displays all the letters the user guessed by seperating with a comma
            put_line("Here are the letters you used: ");
            for i in 1..num_of_guesses loop

                put(user_guesses(i)); put(',');

            end loop;
            put_line(" ");

            -- Prompts the user to enter a letter for their guess
            put_line("What is your guess? ");
            get(letter);
            skip_line;

            -- Validates if the user's guessed letter has already been guessed before
            if Is_In(letter, To_Set(user_guesses)) then
                put_line("You guessed that letter before");

            else
                -- Counter to track the number of times the user guesses the letters
                num_of_guesses := num_of_guesses + 1;
                user_guesses(num_of_guesses) := letter;

                -- Change the dashes to the letter, if the letter is contained in word
                replaced_letter := 0;
                for i in 1..length_of_word loop

                    if word(i) = letter then
                        hidden_word(i) := letter;
                        replaced_letter := replaced_letter + 1;
                    end if;

                end loop;
            
                -- The image changes everytime the user's guessed letter is not contained in the word
                if replaced_letter = 0 then
                    num_of_incorrect_guess := num_of_incorrect_guess + 1;
                    put_line("Invalid character");

                    -- Displays parts of the hangman body
                    case num_of_incorrect_guess is 
					
						when 10 =>
                            put_line("Here's the other foot -- You're hung!!.");
                            hangman_diagram(12)(4) := '-'; hangman_diagram(12)(3) := '\';
						when 9 =>
                            put_line("Now we draw one foot.");
                            hangman_diagram(12)(4) := '\'; hangman_diagram(3)(3) := '-';
						when 8 =>
                            put_line("Next the other hand.");
                            hangman_diagram(3)(3) := '/';
						when 7 =>
                            put_line("Now we put up a hand.");
                            hangman_diagram(3)(11) := '\';
						when 6 =>
                            put_line("This time we draw the left leg.");
                            hangman_diagram(10)(8) := '\'; hangman_diagram(11)(9) := '\';
						when 5 =>
                            put_line("Now, let's draw the right leg.");
                            hangman_diagram(10)(6) := '/'; hangman_diagram(11)(5) := '/';
						when 4 =>
                            put_line("This time it's the other arm.");
                            hangman_diagram(4)(11) := '/'; hangman_diagram(5)(10) := '/'; hangman_diagram(6)(9) := '/'; hangman_diagram(7)(8) := '/';
						when 3 => 
                            put_line("Next we draw an arm.");
                            hangman_diagram(4)(3) := '\'; hangman_diagram(5)(4) := '\'; hangman_diagram(6)(5) := '\'; hangman_diagram(7)(6) := '\';
						when 2 =>
                            put_line("Now we draw a body.");
                            hangman_diagram(6)(7) := 'X'; hangman_diagram(7)(7) := 'X'; hangman_diagram(8)(7) := 'X'; hangman_diagram(9)(7) := 'X';
                        when 1 =>
                            put_line("First we draw a head.");
                            hangman_diagram(3)(6) := '-'; hangman_diagram(3)(7) := '-'; hangman_diagram(3)(8) := '-'; 
                            hangman_diagram(4)(5) := '('; hangman_diagram(4)(6) := '.'; hangman_diagram(4)(8) := '.'; hangman_diagram(4)(9) := ')';
                            hangman_diagram(5)(6) := '-'; hangman_diagram(5)(7) := '-'; hangman_diagram(5)(8) := '-';                     
                        when others =>
                            null;

                    end case;

                    -- Displays the image of the hangman by the parts of the body 
                    for i in 1..12 loop
                        put_line(hangman_diagram(i));
                    end loop;

                -- Validates if the user's guess matches the word
                elsif Is_In('-', To_Set(hidden_word(1..length_of_hidden_word))) then

                    -- Prompts the user to guess the word
                    put_line(hidden_word(1..length_of_hidden_word));
                    put_line("What is your guess for the word? ");
                    get_line(guessed_word, length_of_guessed_word);

                    -- If the user guesses the word correctly, it will display the number of times it took them to guess the word
                    if length_of_word = length_of_guessed_word then

						if word(1..length_of_word) = guessed_word(1..length_of_guessed_word) then
							put("Right! It took you ");
							put(num_of_guesses);
							put_line(" guesses");
							exit;
						end if;

                    else
                        put_line("Wrong!");
                    end if;

                else
                    -- Informs the user that they found all the letters in the word
                    put_line("You found the letters!");
                end if;

            end if;

        end loop;

        -- The user only gets 10 chances to guess the word correctly 
        if num_of_incorrect_guess = 10 then
            put_line("Sorry, you loose. The word was " & word(1..length_of_word));
        end if;

        -- Prompts the user if they want a another word 
        put_line("Do you want another word? (Y/N) ");
        get(user_answer);

        -- If the user enters 'N' then the game will end 
        if user_answer = 'N' then
            put_line("See you next time! Bye.");
            exit;

        -- If the user enters 'Y' then the game will continue
		elsif user_answer = 'Y' then
			counter := counter + 1;

		else
            -- If the user enters anything other than Y or N, then the game will continue
			put_line("Did not understand what you entered! We will assume you want another word.");
			counter := counter + 1;
        end if;
        
    end loop;
	
	-- Informs the user that they completed through all the words in the dictionary
    if counter = 51 then
        put_line("You did all the words");
    end if;

    -- Informs the user the game has ended
    put_line("Ending...");

end Hangman;