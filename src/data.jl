const DATA_PATH::String = "../pinyin-data/pinyin.txt"

function to_char(unicode::String)::Char
    parse(Int, unicode[3:end-1], base=16) |> Char # splice because they start with unnecessary "U+" and end with unnecessary ":"
end

function to_pinyin_pair(line::Tuple{String, Vector{String}})::Pair{String, String}
    line[1] => line[2][1]
end

function to_hanzi_pair(line::Tuple{String, Vector{String}})::Vector{Pair{String, String}}
    [pinyin => line[1] for pinyin::String in line[2]]
end

function make_pairs(line::String)::Tuple{String, Vector{String}}
    split_line::Vector{String} = split(line, " ")
    ("$(to_char(split_line[1]))", split(split_line[2], ","))
end

function create_dicts(path::String)::Tuple{Dict{String, String}, Dict{String, String}}
    contents::Vector{Tuple{String, Vector{String}}} = map(make_pairs, readlines(path)[3:end]) # splice to remove first two lines, unused
    to_hanzi_dict::Dict{String, String} = map(to_hanzi_pair, contents) |> x -> reduce(vcat, x) |> Dict
    to_pinyin_dict::Dict{String, String} = map(to_pinyin_pair, contents) |> Dict
    (to_hanzi_dict, to_pinyin_dict)
end

const PINYIN_TO_HANZI::Dict{String, String}, HANZI_TO_PINYIN::Dict{String, String} = create_dicts(DATA_PATH)