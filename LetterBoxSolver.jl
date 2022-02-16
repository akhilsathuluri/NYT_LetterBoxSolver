# Imports
using DelimitedFiles
using Combinatorics
using Permutations

# Run a simple search through words data
# Getting the word dataset
# words_path = "./english-words/words_alpha.txt"
words_path = "./oxford_words.txt"
words_alpha = readdlm(words_path);

# Declare sets of variables
letters = (('b', 'e', 'p'), ('u', 'i', 'n'), ('c', 't', 'a'), ('l', 'm', 'o'));
# letters = (('h', 'i', 'g'), ('a', 's', 'b'), ('m', 'x', 'c'), ('o', 'e', 't'));
# Construct the rules for the words search
# Letters that should be in the words
all_letters = collect(Iterators.flatten(letters));

# Step-1: Get the words containing only the basis letters
min_word_size = 10

# Declare empty word list
contains_letters_list = String[]
for word in words_alpha
    split_word = collect(word)
    word_length = size(split_word)
    # Add rules to filter only required words
    if all(in(all_letters).(split_word)) && (word_length[1] >= min_word_size)
        # Add it to the new word list
        push!(contains_letters_list, word)
    end
end

# Letter pairings that should not be in the words
bad_combos = String[]
for lett in letters
    for l in lett
        push!(bad_combos, string(l,l))
    end
    for perm in collect(permutations(lett,2))
        push!(bad_combos, join(perm))
    end
end

# Step-2: Get the candidate words

candidate_words = String[]
for word in contains_letters_list
    word_split = collect(word)
    word_length = (size(word_split))[1]
    combo_check = true
    for ii = 1:word_length-1
        combo_check = combo_check && !in(bad_combos).(join(word_split[ii:ii+1]))
    end
    if combo_check == true
        push!(candidate_words, word)
    end
end

# Now get candidate solutions
candidate_solutions = []
for first_word in candidate_words
    first_word_split = collect(first_word)
    last_letter = (first_word_split)[end]
    for second_word in candidate_words
        second_word_split = collect(second_word)
        first_letter = (second_word_split)[1]
        if last_letter == first_letter
            two_word_letters = union(first_word_split, second_word_split)
            if all(in(two_word_letters).(all_letters))
                push!(candidate_solutions, (first_word, second_word))
            end
        end
    end
end

println(candidate_solutions)
