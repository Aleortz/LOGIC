% Lab 2 - Date: 2025-09-28
% Author: Christopher Ortiz


% 1. KNOWLEDGE BASE: IBARRA ANIMAL IDENTIFICATION SYSTEM
% ---------------------------------------------------------------------------
% --- Animal Properties ---
has_fur(cat).
has_fur(dog).
has_fur(andean_wild_rabbit).
has_fur(big_eared_bat).
has_fur(andean_fox).
has_fur(white_tailed_deer).

lays_eggs(chicken).
lays_eggs(duck).
lays_eggs(andean_hummingbird).
lays_eggs(eared_dove).
lays_eggs(great_thrush).

flies(andean_hummingbird).
flies(eared_dove).
flies(great_thrush).
flies(big_eared_bat).
flies(duck).

swims(duck).
swims(andean_fox). 
swims(white_tailed_deer). 

domesticated(cat).
domesticated(dog).
domesticated(chicken).
domesticated(duck).

barks(dog).
meows(cat).
chirps(andean_hummingbird).
coos(eared_dove).
sings(great_thrush).
screeches(big_eared_bat).
runs(andean_wild_rabbit).
howls(andean_fox).
bleats(white_tailed_deer).

% Classification rules
is_mammal(X) :- has_fur(X).
is_bird(X) :- lays_eggs(X), flies(X).
is_terrestrial(X) :- has_fur(X).
is_domesticated(X) :- domesticated(X).
can_fly(X) :- flies(X).
can_swim(X) :- swims(X).

% Ambiguity handling
possible_animals(List) :- findall(A, matches(A), List).
matches(A) :- has_fur(A).
matches(A) :- lays_eggs(A).

% Recursive rule for classification tree
is_a(cat, mammal).
is_a(dog, mammal).
is_a(andean_wild_rabbit, mammal).
is_a(big_eared_bat, mammal).
is_a(andean_fox, mammal).
is_a(white_tailed_deer, mammal).
is_a(mammal, vertebrate).

is_a(chicken, bird).
is_a(duck, bird).
is_a(andean_hummingbird, bird).
is_a(eared_dove, bird).
is_a(great_thrush, bird).
is_a(bird, vertebrate).

is_a(vertebrate, animal).

ancestor(X, Y) :- is_a(X, Y).
ancestor(X, Y) :- is_a(X, Z), ancestor(Z, Y).

% Interactive identification procedure
identify_animal(Animal) :-
    ask('Does it have fur?', Fur),
    (Fur == yes ->
        ask('Does it bark?', Bark),
        (Bark == yes -> Animal = dog ;
            ask('Does it meow?', Meow), (Meow == yes -> Animal = cat ;
            ask('Is it small and runs fast?', Runs), (Runs == yes -> Animal = andean_wild_rabbit ;
            ask('Does it have big ears and fly?', Bat), (Bat == yes -> Animal = big_eared_bat ;
            ask('Does it howl?', Howl), (Howl == yes -> Animal = andean_fox ;
            Animal = white_tailed_deer)))))
    ;
        ask('Does it lay eggs?', Eggs),
        (Eggs == yes ->
            ask('Does it fly?', Fly), 
            (Fly == yes ->
                ask('Does it sing?', Sings), (Sings == yes -> Animal = great_thrush ;
                ask('Does it chirp?', Chirps), (Chirps == yes -> Animal = andean_hummingbird ;
                ask('Does it coo?', Coos), (Coos == yes -> Animal = eared_dove ; Animal = duck)))
            ; Animal = chicken)
        ;
            Animal = unknown
        )
    ),
    write('I think the animal is: '), write(Animal), nl.

% Simple input/output for questions
ask(Question, Answer) :-
    write(Question), write(' (yes/no): '), nl,
    read(Answer).

% Example queries and results
% Which animals have fur?
% ?- has_fur(X).
% X = cat ;
% X = dog ;
% X = andean_wild_rabbit ;
% X = big_eared_bat ;
% X = andean_fox ;
% X = white_tailed_deer.

% Which animals can fly?
% ?- can_fly(X).
% X = andean_hummingbird ;
% X = eared_dove ;
% X = great_thrush ;
% X = big_eared_bat ;
% X = duck.

% Is the cat a vertebrate?
% ?- ancestor(cat, vertebrate).
% true.

% Is the andean_wild_rabbit an animal?
% ?- ancestor(andean_wild_rabbit, animal).
% true.

% Which possible animals match the known facts?
% ?- possible_animals(L).
% L = [cat, dog, andean_wild_rabbit, big_eared_bat, andean_fox, white_tailed_deer, chicken, duck, andean_hummingbird, eared_dove, great_thrush]