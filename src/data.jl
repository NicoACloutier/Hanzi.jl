"Relative path to data directory."
const DATA_PATH::String = "../pinyin-data/pinyin.txt"

"""
Change a unicode string in the format U+`code`: into a character.
Arguments:
    `unicode::String`: The unicode representation string.
Returns:
    `::Char`: The converted character
"""
function to_char(unicode::String)::Char
    parse(Int, unicode[3:end-1], base=16) |> Char # splice because they start with unnecessary "U+" and end with unnecessary ":"
end

"""
Turn a data line into a pair mapping from Hanzi to pinyin.
Arguments:
    `line::Tuple{String, Vector{String}}`: A tuple with a Hanzi character as the first item and a vector of pinyin representations as the second.
Returns:
    `::Pair{String, String}`: A mapping from Hanzi to pinyin.
"""
function to_pinyin_pair(line::Tuple{String, Vector{String}})::Pair{String, String}
    line[1] => line[2][1]
end

"""
Turn a data line into a pair mapping from pinyin to Hanzi.
Arguments:
    `line::Tuple{String, Vector{String}}`: A tuple with a Hanzi character as the first item and a vector of pinyin representations as the second.
Returns:
    `::Vector{Pair{String, String}}`: All mappings from a pinyin to Hanzi.
"""
function to_hanzi_pair(line::Tuple{String, Vector{String}})::Vector{Pair{String, String}}
    [pinyin => line[1] for pinyin::String in line[2]]
end

"""
Create data pairs out of a line in the data file.
Arguments:
    `line::String`: The line in the data file in the format U+`code`: `pinyin` # `hanzi`
Returns:
    `::Tuple{String, Vector{String}}`: A tuple with Hanzi as the first item and a vector of pinyin as the second.
"""
function make_pairs(line::String)::Tuple{String, Vector{String}}
    split_line::Vector{String} = split(line, " ")
    ("$(to_char(split_line[1]))", split(split_line[2], ","))
end

"""
Create dictionaries mapping Hanzi to pinyin and vice versa out of a data file.
Arguments:
    `path::String`: The path to the file with data.
Returns:
    `::Dict{String, String}`: A dictionary mapping pinyin to Hanzi.
    `::Dict{String, String}`: A dictionary mapping Hanzi to pinyin.
"""
function create_dicts(path::String)::Tuple{Dict{String, String}, Dict{String, String}}
    contents::Vector{Tuple{String, Vector{String}}} = map(make_pairs, readlines(path)[3:end]) # splice to remove first two lines, unused
    to_hanzi_dict::Dict{String, String} = map(to_hanzi_pair, contents) |> x -> reduce(vcat, x) |> Dict
    to_pinyin_dict::Dict{String, String} = map(to_pinyin_pair, contents) |> Dict
    (to_hanzi_dict, to_pinyin_dict)
end

"Dictionaries mapping Hanzi to pinyin and vice versa."
const PINYIN_TO_HANZI::Dict{String, String}, HANZI_TO_PINYIN::Dict{String, String} = create_dicts(DATA_PATH)