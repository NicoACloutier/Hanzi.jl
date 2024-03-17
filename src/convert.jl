include("data.jl")

function give(to_give::Vector{String}, multiple::Bool)::Vector{String}
    multiple ? to_give : [to_give[1]]
end

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

function pinyin(reference::String; multiple::Bool=false)::Vector{Vector{String}}
    to_pinyin(reference, HANZI_TO_PINYIN, multiple)
end