include("data.jl")

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
    `Vector{Vector{String}}`: If `multiple` is `false`, a vector of single-item vectors with Hanzi pronunciations.
        If `multiple` is `true`, a vector of variable-length vectors, with each containing the possible pronunciations.
"""
function pinyin(reference::String; multiple::Bool=false)::Vector{Vector{String}}
    to_pinyin(reference, HANZI_TO_PINYIN, multiple)
end