function starter(reference::String, items::Vector{String})::String
    for item in items
        if startswith(reference, item) return item end
    end
    ""
end

function additem(total::String, reference::String, items::Vector{String})::String
    total * starter(reference, items)
end

function doublestart(total::String, reference::String, items::Vector{String})::String
    start::String = starter(reference, items)
    shorter::String = reference[length(start)+1:end]
    if starter(shorter, items) != "" || length(shorter) == 0 return total * start end
    total
end

function findbeginnings(total::String, reference::String, items::Vector{String})::String
    regexmatch::Union{RegexMatch, Nothing} = match("^[$(reduce(*, items))]{1,3}" |> Regex, reference)
    if isnothing(regexmatch) return total
    else return total * regexmatch.match end
end

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

function syllables(transcription::String, consonants::Vector{String}, vowels::Vector{String})::Vector{String}
    allowable::Vector{Char} = mapreduce(x -> vcat(x) |> join, *, [consonants, vowels, [" ", "'"]]) |> unique
    mapreduce(x -> splitsyllables(string(x), consonants, vowels, allowable), vcat, split(transcription, r"[ ']"))
end