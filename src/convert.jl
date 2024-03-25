include("data.jl")

"The number of unique vowel qualities for retranscription."
const NUM_VOWELS = 6
"The number of tones to be used for retranscription."
const NUM_TONES = 4
"A vector of vowels used in pinyin, ordered according to tone."
const VOWELS = ["ā", "ē", "ī", "ō", "ū", "ǖ", "á", "é", "í", "ó", "ú", "ǘ", "ǎ","ě",
    "ǐ", "ǒ", "ǔ", "ǚ", "à", "è", "ì", "ò", "ù", "ǜ", "a", "e", "i", "o", "u", "ü"]
"Pinyin to Wade-Giles onset conversion dictionary."
const WADEGILES_ONSET = Dict(Regex(pair[1] * "(?=[" * join(VOWELS, "") * "])") => pair[2] for pair in
    ["p" => "p'", "b" => "p", "t" => "t'", "d" => "t", "k" => "k'", "g" => "k", 
    "ch" => "ch'", "zh" => "ch", "q" => "ch'", "j" => "ch", "x" => "hs", "r" => "j"])
"Pinyin to Wade-Giles coda/nucleus conversion dictionary."
const WADEGILES_CODA = map(x -> Regex(x[1] * "(?=[\\b1-9])") => x[2], 
    ["ie" => "ieh", "ian" => "ien", "ong" => "ung", "üe" => "üeh",
     "ye" => "yeh", "yu" => "yü", "yun" => "yün", "yuan" => "yüan",
     "yan" => "yen", "you" => "yu", "chi" => "chih", "ch'i" => "ch'ih",
     "shi" => "shih", "ji" => "jih", "tzi" => "tzŭ", "tz'i" => "tz'ŭ",
     "si" => "sŭ", "wen" => "wên", "eng" => "êng", "e" => "ê", 
     "er" => "êrh"]) |> Dict

"""
Returns the first item of a vector if `multiple` is false, otherwise the vector.
Arguments:
    `to_give::Vector{String}`: The vector to return.
    `multiple::Bool`: Whether to return the vector or the first item of the vector.
Returns:
    `::Vector{String}`: A one-item vector of the first item of `to_give` if `multiple` is true, otherwise `to_give`.
"""
function give(to_give::Vector{String}, multiple::Bool)::Vector{String}
    multiple ? to_give : [to_give[1]]
end

"""
Convert a Hanzi reference string to pinyin given a conversion map.
Arguments:
    `reference::String`: The Hanzi string.
    `conversions::Dict{String, Vector{String}}`: A dictionary mapping Hanzi to all possible pinyin representations.
    `multiple::Bool`: Whether to return multiple pronunciations.
Returns:
    `::Vector{Vector{String}}`: The converted pronunciation vector.
"""
function to_pinyin(reference::String, conversions::Dict{String, Vector{String}}, multiple::Bool)::Vector{Vector{String}}
    unknown::String = ""
    elements::Vector{Vector{String}} = []
    for element::String in map(string, reference |> collect)
        in_list::Bool = haskey(conversions, element)
        if in_list && length(unknown) != 0
            push!(elements, [unknown])
            push!(elements, give(conversions[element], multiple))
            unknown = ""
        elseif in_list push!(elements, give(conversions[element], multiple))
        else unknown *= element end
    end
    length(unknown) == 0 ? elements : push!(elements, [unknown])
end

"""
Find the pinyin of a Hanzi reference string.
Arguments:
    `reference::String`: The Hanzi string.
    Optional:
    `multiple::Bool=false`: Whether to return multiple pronunciations for characters with multiple pronunciations.
Returns:
    `::Vector{Vector{String}}`: If `multiple` is `false`, a vector of single-item vectors with Hanzi pronunciations.
        If `multiple` is `true`, a vector of variable-length vectors, with each containing the possible pronunciations.
"""
function pinyin(reference::String; multiple::Bool=false)::Vector{Vector{String}}
    to_pinyin(reference, HANZI_TO_PINYIN, multiple)
end

"""
Separate quality and tone information on a vowel.
Arguments:
    `vowel::String`: The vowel to find information on.
    `vowels::Vector{String}`: A complete vector of vowel graphemes in the transcription scheme.
    `num_tones::Int`: The number of tones to be found.
    `num_vowels::Int`: The number of unique vowel qualities.
Returns:
    `::String`: The plain (no diacritics) vowel grapheme.
    `::Int`: The tone number, from 1-4, with 5 signifying neutral tone.
"""
function get_vowel_info(vowel::String, vowels::Vector{String}, num_tones::Int, num_vowels::Int)::Tuple{String, Int}
    place::Int = findall(==(vowel), vowels)[1][1]
    (vowels[(place - 1) % num_vowels + num_vowels * num_tones + 1], ((place - 1) / num_vowels |> floor) + 1)
end

"""
Go through a dictionary of potential conversions and make the first conversion that appears.
    Returns `transcription` as inputted if none found.
Arguments:
    `transcription::String`: The transcription syllable to operate on.
    `conversions::Dict{Regex, String}`: The conversions to be made.
Returns:
    `::String`: The updated transcription.
"""
function replace_conversions(transcription::String, conversions::Dict{Regex, String})::String
    for conversion::Pair{Regex, String} in conversions
        if match(conversion[1], transcription) |> isnothing |> !
            transcription = replace(transcription, conversion)
            break
        end
    end
    transcription
end

"""
Rewrite a syllable that uses pinyin diacritics for tone markings using syllable-final numbers instead.
Arguments:
    `transcribed::String`: The syllable with pinyin tone diacritics.
Returns:
    `::String`: The updated syllable with syllable-final tone numbers.
"""
function number_tone_vowel(transcribed::String)::String
    for vowel::String in VOWELS
        if occursin(vowel, transcribed)
            vowel_info::Tuple{String, Int} = get_vowel_info(vowel, VOWELS, NUM_TONES, NUM_VOWELS)
            transcribed = replace(transcribed, vowel => vowel_info[1])
            transcribed *= vowel_info[2] <= NUM_TONES ? string(vowel_info[2]) : ""
            break
        end
    end
    transcribed
end

"""
Re-transcribe Mandarin according to a new transcription scheme.
Arguments:
    `transcribed::String`: The string to convert to a new transcription scheme.
    `onset_conversions::Dict{Regex, String}`: A set of RegEx patterns mapping to strings to change syllable onsets.
    `coda_conversions::Dict{Regex, String}`: A set of RegEx patterns mapping to strings to change syllable codas and nuclei.
    `vowel_predicate::Function`: The predicate for changing vowels from one transcription scheme to another.
Returns:
    `::String`: The newly retranscribed syllable.
"""
function retranscribe(transcribed::String, onset_conversions::Dict{Regex, String}, 
                      coda_conversions::Dict{Regex, String}, vowel_predicate::Function)::String
    transcribed = replace_conversions(transcribed, onset_conversions) |> vowel_predicate
    replace_conversions(transcribed, coda_conversions)
end

"""
Find the Wade-Giles of a Hanzi reference string.
Arguments:
    `reference::String`: The Hanzi string.
    Optional:
    `multiple::Bool=false`: Whether to return multiple pronunciations for characters with multiple pronunciations.
Returns:
    `::Vector{Vector{String}}`: If `multiple` is `false`, a vector of single-item vectors with Hanzi pronunciations.
        If `multiple` is `true`, a vector of variable-length vectors, with each containing the possible pronunciations.
"""
function wadegiles(reference::String; multiple::Bool=false)::Vector{Vector{String}}
    pinyin_string::Vector{Vector{String}} = pinyin(reference, multiple=multiple)
    [map(x -> retranscribe(x, WADEGILES_ONSET, WADEGILES_CODA, number_tone_vowel), syllables) for syllables::Vector{String} in pinyin_string]
end