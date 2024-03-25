include("pinyin.jl")

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
Create data pairs out of a line in the data line.
Arguments:
    `line::String`: The line in the data line in the format U+`code`: `pinyin`
Returns:
    `::Tuple{String, Vector{String}}`: A tuple with Hanzi as the first item and a vector of pinyin as the second.
"""
function make_pairs(line::String)::Tuple{String, Vector{String}}
    split_line::Vector{String} = split(line, " ")
    (to_char(split_line[1]) |> string, split(split_line[2], ","))
end

"""
Create dictionary mapping Hanzi to pinyin out of a data string.
Arguments:
    `hanzi::String`: The Hanzi data string.
Returns:
    `::Dict{String, Vector{String}}`: A dictionary mapping Hanzi to all pinyin representations.
"""
function create_dict(hanzi::String)::Dict{String, Vector{String}}
    contents::Vector{Tuple{String, Vector{String}}} = map(make_pairs, map(string, split(hanzi, "\n")))
    map(x -> x[1] => x[2], contents) |> Dict
end

"Dictionary mapping Hanzi to pinyin."
const HANZI_TO_PINYIN::Dict{String, Vector{String}} = create_dict(HANZI)