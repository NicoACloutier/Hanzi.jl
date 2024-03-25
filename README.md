# Hanzi.jl

[![Build Status](https://github.com/NicoACloutier/Hanzi.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/NicoACloutier/Hanzi.jl/actions/workflows/CI.yml?query=branch%3Amain)

An open-source library for romanizing Hanzi written in Julia that supports pinyin and Wade-Giles romanization.

## Dependencies

This library requires a minimum of Julia 1.0 and does not depend on any external libraries.

## Usage

`Hanzi.jl` exports two functions: `pinyin` and `wadegiles`. Both functions expect a string as input and will product a `Vector{Vector{String}}`, where each `Vector{String}` are the possible pronunciations for a given Hanzi. By default, only one pronunciation per character will be returned, meaning each `Vector{String}` will have only one item. Setting the option `multiple=true` in the function call will return multiple pronunciations for applicable characters. If non-Hanzi characters are encountered adjacent to each other, they will be returned as single-item `Vector{String}`s.

### Usage examples

```julia
using Hanzi

Hanzi.pinyin("㐀") # [["qiū"]]
Hanzi.pinyin("㐀", multiple=true) # [["qiū"]]
Hanzi.pinyin("是") # [["shì"]]
Hanzi.pinyin("是", multiple=true) # [["shì", "tí"]]
Hanzi.pinyin("你好") # [["nǐ"], ["hǎo"]]
Hanzi.pinyin("你好", multiple=true) # [["nǐ"], ["hǎo", "hào"]]
Hanzi.pinyin("我叫John。你呢？") # [["wǒ"], ["jiào"], ["John。"], ["nǐ"], ["ne"], ["？"]]
Hanzi.pinyin("我叫John。你呢？", multiple=true) # [["wǒ"], ["jiào"], ["John。"], ["nǐ"], ["ne", "ní", "nǐ", "nī"], ["？"]]

Hanzi.wadegiles("㐀") # [["ch'iu1"]]
Hanzi.wadegiles("㐀", multiple=true) # [["ch'iu1"]]
Hanzi.wadegiles("是") # [["shih4"]]
Hanzi.wadegiles("是", multiple=true) # [["shih4", "t'i2"]]
Hanzi.wadegiles("你好") # [["ni3"], ["hao3"]]
Hanzi.wadegiles("你好", multiple=true) # [["ni3"], ["hao3", "hao4"]]
Hanzi.wadegiles("我叫John。你呢？") # [["wo3"], ["chiao4"], ["John。"], ["ni3"], ["ne"], ["？"]]
Hanzi.wadegiles("我叫John。你呢？", multiple=true) # [["wo3"], ["chiao4"], ["John。"], ["ni3"], ["ne", "ni2", "ni3", "ni1"], ["？"]]
```

## Special thanks
Thank you to [@mozillazg](https://www.github.com/mozillazg) and the maintainers and contributors of [`python-pinyin`](https://github.com/mozillazg/python-pinyin) (a similar library for Python) for providing publicly available and MIT-licensed data used in this project.

## Project information
This project was started by [Nicolas Antonio Cloutier](mailto:nicocloutier1@gmail.com) in 2024. There are no additional contributors as of yet. If you have suggestions, issues, or additions, feel free to open an issue or pull request on the [GitHub page](https://github.com/NicoACloutier/arxiv_ret). This project operates under the MIT license. Licensing information can be found in the file entitled `LICENSE` in this project's top-level directory.