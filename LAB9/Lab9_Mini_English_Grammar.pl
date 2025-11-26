% Prolog Lab 09: Mini English Grammar with DCGs
% Yachay Tech University - Mathematical and Computational Logic
% Author: Christopher Ortiz
% Date: 2025-11-26
% Description:
%   Implementation of a small English grammar using DCGs (Definite Clause Grammars).
% 
% Grammar (DCG):
%   sentence --> noun_phrase, verb_phrase.
%   noun_phrase --> opt_determiner, adjectives, noun.
%   verb_phrase --> verb, noun_phrase.
%
% Lexicon:
%   determiner --> [the] | [a].
%   noun --> [cat] | [dog] | [fish] | [bird].
%   verb --> [eats] | [sees].
%   adjective --> [big] | [small] | [angry].
%
% Note:
%   - By allowing optional determiners, sentences like [the, cat, eats, fish] are accepted.
%
sentence --> noun_phrase, verb_phrase.

% noun_phrase with optional determiner
noun_phrase --> opt_determiner, adjectives, noun.

verb_phrase --> verb, noun_phrase.

% determiners
determiner --> [the].
determiner --> [a].

% optional determiner: [] or determiner
opt_determiner --> [].              % no determiner
opt_determiner --> determiner.      % with determiner

% nouns
noun --> [cat].
noun --> [dog].
noun --> [fish].
noun --> [bird].

% verbs
verb --> [eats].
verb --> [sees].

% adjectives
adjective --> [big].
adjective --> [small].
adjective --> [angry].

% zero or more adjectives
adjectives --> [].                 
adjectives --> adjective, adjectives.

% ---------- Examples ----------
% Parsing (recognition):
% ?- phrase(sentence, [the, cat, eats, fish]).      
% true.
% ?- phrase(sentence, [a, big, angry, dog, sees, the, fish]).
% true.
% ?- phrase(sentence, [big, dog, eats, fish]).
% true.    % (no determiner in subject and object)
%
% Generation (production):
% ?- phrase(sentence, X).
% Example solutions you may see (first few):
% X = [cat, eats, cat]
% X = [cat, eats, dog]
% X = [cat, eats, fish]
% X = [cat, eats, bird]
% X = [cat, eats, big, bird]
