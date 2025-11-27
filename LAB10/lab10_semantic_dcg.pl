% Prolog Lab 10: Semantic DCGs - From Sentences to Meaning
% Yachay Tech University - Mathematical and Computational Logic
% Author: Christopher Ortiz
% Date: 2025-11-27
% Description:
%   Semantic extension of the mini English grammar using DCGs.
%   Determiners are now optional for noun phrases (both syntax-only and semantic variants).
%

% ---------------------------
% Task A - Base semantic grammar 
% ---------------------------
% sentence(Sem) : Sem is the semantic representation of the sentence.
sentence(Sem) --> noun_phrase(Subject), verb_phrase(Subject, Sem).

% noun_phrase(Subj) : now allows optional determiner and optional adjectives (syntax-only)
noun_phrase(Subj) --> opt_determiner, adjectives, noun(Subj).

% verb_phrase(Subject, Sem) : combine verb with object to build Sem.
verb_phrase(Subject, Sem) --> verb(Verb), noun_phrase(Object), { Sem =.. [Verb, Subject, Object] }.

% ---------------------------
% Lexicon with semantics (nouns and verbs as terms)
% ---------------------------
noun(cat)  --> [cat].
noun(dog)  --> [dog].
noun(fish) --> [fish].
noun(bird) --> [bird].

verb(eat) --> [eats].
verb(see) --> [sees].

% determiner productions kept (but made optional via opt_determiner)
determiner --> [the].
determiner --> [a].

% optional determiner: empty or determiner token
opt_determiner --> [].              
opt_determiner --> determiner.      

% ---------------------------
% Adjectives (syntax-only)
% ---------------------------
adjectives --> [].                 
adjectives --> adjective, adjectives.

adjective --> [big].
adjective --> [small].
adjective --> [angry].

% ---------------------------
% Extension: adjectives (semantic version)
% ---------------------------
% Collect modifiers as a list and represent noun phrases as entity(Noun, Mods)

adjective_sem(big)   --> [big].
adjective_sem(small) --> [small].
adjective_sem(angry) --> [angry].

adjectives_sem([])     --> [].
adjectives_sem([M|Ms]) --> adjective_sem(M), adjectives_sem(Ms).

% noun_phrase_sem: allows optional determiner and collects modifiers
noun_phrase_sem(entity(N, Mods)) --> opt_determiner, adjectives_sem(Mods), noun(N).

% verb_phrase_sem and sentence_sem for fully semantic noun phrases
verb_phrase_sem(Subject, Sem) --> verb(Verb), noun_phrase_sem(Object), { Sem =.. [Verb, Subject, Object] }.
sentence_sem(Sem) --> noun_phrase_sem(Subject), verb_phrase_sem(Subject, Sem).

% Convenience: mixed variant that uses semantic subject but syntax-only object, or viceversa.
% sentence_adj_sem uses semantic noun_phrase for subject and base verb_phrase (object uses noun_phrase)
sentence_adj_sem(Sem) --> noun_phrase_sem(Subject), verb_phrase(Subject, Sem).

% Example:
%             
%   ?- phrase(sentence(S), [the, cat, eats, fish]).   
%   S = eat(cat, fish).
%   ?- phrase(sentence(S), [cat, eats, fish]).       
%   S = eat(cat, fish).
%   ?- phrase(sentence_sem(S), [big, dog, sees, a, fish]). 
%   S = see(entity(dog, [big]), entity(fish, []))
%
% ---------------------------------------------------------------------------
