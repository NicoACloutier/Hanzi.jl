"Relative path to data directory."
const DATA_PATH = "./pinyin-data/pinyin.txt"

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
Create data pairs out of a line in the data file.
Arguments:
    `line::String`: The line in the data file in the format U+`code`: `pinyin` # `hanzi`
Returns:
    `::Tuple{String, Vector{String}}`: A tuple with Hanzi as the first item and a vector of pinyin as the second.
"""
function make_pairs(line::String)::Tuple{String, Vector{String}}
    split_line::Vector{String} = split(line, " ")
    (to_char(split_line[1]) |> string, split(split_line[2], ","))
end

"""
Create dictionary mapping Hanzi to pinyin out of a data file.
Arguments:
    `path::String`: The path to the file with data.
Returns:
    `::Dict{String, Vector{String}}`: A dictionary mapping Hanzi to all pinyin representations.
"""
function create_dict(path::String)::Dict{String, Vector{String}}
    contents::Vector{Tuple{String, Vector{String}}} = map(make_pairs, readlines(path)[3:end]) # splice to remove first two lines, unused
    map(x -> x[1] => x[2], contents) |> Dict
end

"Dictionary mapping Hanzi to pinyin."
const HANZI_TO_PINYIN::Dict{String, Vector{String}} = create_dict(DATA_PATH)