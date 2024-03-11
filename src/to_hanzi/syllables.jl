"""
Find the starting item within a reference from a vector of possible starters.
Arguments:
    `reference::String`: The reference string to find the starter for.
    `items::Vector{String}`: The possible starter items.
Returns:
    `::String`: The starting item if found, otherwise an empty string.
"""
function starter(reference::String, items::Vector{String})::String
    for item in items
        if startswith(reference, item) return item end
    end
    ""
end

"""
Add a starting item within a reference string to an accumulation string.
Arguments:
    `total::String`: The accumulation string before the addition.
    `reference::String`: The reference to search in the beginning of.
    `items::Vector{String}`: The items to search for in the beginning of the string.
Returns:
    `::String`: The accumulation string with the addition.
"""
function additem(total::String, reference::String, items::Vector{String})::String
    total * starter(reference, items)
end

"""
Search for two starting elements in a reference string, adding the first if found.
Arguments:
    `total::String`: The accumulation string before the addition.
    `reference::String`: The reference to search in the beginning of.
    `items::Vector{String}`: The items to search for in the beginning of the string.
Returns:
    `::String`: The accumulation string with the addition if found.
"""
function doublestart(total::String, reference::String, items::Vector{String})::String
    start::String = starter(reference, items)
    shorter::String = reference[length(start)+1:end]
    if starter(shorter, items) != "" || length(shorter) == 0 return total * start end
    total
end

"""
Find up to three beginning characters in a reference string, adding them if found.
Arguments:
    `total::String`: The accumulation string before the addition.
    `reference::String`: The reference to search in the beginning of.
    `items::Vector{String}`: The items to search for in the beginning of the string.
Returns:
    `::String`:  The accumulation string with the addition if found.
"""
function findbeginnings(total::String, reference::String, items::Vector{String})::String
    regexmatch::Union{RegexMatch, Nothing} = match("^[$(reduce(*, items))]{1,3}" |> Regex, reference)
    if isnothing(regexmatch) return total
    else return total * regexmatch.match end
end

"""
Split syllables in a Mandarin romanization with no spaces or other delimiting characters.
Arguments:
    `transcription::String`: The transcription to split into syllables.
    `consonants::Vector{String}`: The consonants within this romanization of Mandarin.
    `vowels::Vector{String}`: The vowels within this romanization of Mandarin.
Returns:
    `::Vector{String}`: The syllables within the given transcription.
"""
function splitsyllables(transcription::String, consonants::Vector{String}, vowels::Vector{String}, allowable::Vector{Char})::Vector{String}
    for char in unique(transcription) # Check for non-allowable characters. If present, return.
        if !in(char, allowable) return [transcription] end
    end
    syllables::Vector{String} = []
    while length(transcription) > 0
        syllable::String = ""
        syllable = additem(syllable, transcription, consonants)
        syllable = findbeginnings(syllable, transcription[length(syllable)+1:end], vowels)
        syllable = doublestart(syllable, transcription[length(syllable)+1:end], consonants)
        push!(syllables, syllable)
        transcription = transcription[length(syllable)+1:end]
    end
    syllables
end

"""
Find all syllables in a Mandarin romanization given the romanization's consonants and vowels.
Arguments:
    `transcription::String`: The Mandarin romanization.
    `consonants::Vector{String}`: A vector of unique consonant phonemes used in the romanization.
    `vowels::Vector{String}`: A vector of unique vowel phonemes used in thhe romanization.
Returns:
    `::Vector{String}`: The parsed syllables within the given transcription.
"""
function syllables(transcription::String, consonants::Vector{String}, vowels::Vector{String})::Vector{String}
    allowable::Vector{Char} = mapreduce(x -> vcat(x) |> join, *, [consonants, vowels, [" ", "'"]]) |> unique
    mapreduce(x -> splitsyllables(string(x), consonants, vowels, allowable), vcat, split(transcription, r"[ ']"))
end