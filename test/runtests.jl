using Hanzi
using Test

@testset "Hanzi.jl" begin
    # PINYIN TESTS
    @test Hanzi.pinyin("㐀") == [["qiū"]] # test single character `multiple=false` singular pronunciation
    @test Hanzi.pinyin("㐀", multiple=true) == [["qiū"]] # test single character `multiple=true` singular pronunciation
    @test Hanzi.pinyin("是") == [["shì"]] # test single character `multiple=false` multiple pronunciations
    @test Hanzi.pinyin("是", multiple=true) == [["shì", "tí"]] # test single character `multiple=true` multiple pronunciations
    @test Hanzi.pinyin("你好") == [["nǐ"], ["hǎo"]] # test multiple characters `multiple=false` multiple pronunciations
    @test Hanzi.pinyin("你好", multiple=true) == [["nǐ"], ["hǎo", "hào"]] # test multiple characters `multiple=true` multiple pronunciations
    @test Hanzi.pinyin("我叫John。你呢？") == [["wǒ"], ["jiào"], ["John。"], ["nǐ"], ["ne"], ["？"]] # test multiple characters `multiple=false` multiple pronunciations non-recognized glyphs
    @test Hanzi.pinyin("我叫John。你呢？", multiple=true) == [["wǒ"], ["jiào"], ["John。"], ["nǐ"], ["ne", "ní", "nǐ", "nī"], ["？"]] # test multiple characters `multiple=true` multiple pronunciations non-recognized glyphs

    # WADE-GILES TESTS
    @test Hanzi.wadegiles("㐀") == [["ch'iu1"]] # test single character `multiple=false` singular pronunciation
    @test Hanzi.wadegiles("㐀", multiple=true) == [["ch'iu1"]] # test single character `multiple=true` singular pronunciation
    @test Hanzi.wadegiles("是") == [["shih4"]] # test single character `multiple=false` multiple pronunciations
    @test Hanzi.wadegiles("是", multiple=true) == [["shih4", "t'i2"]] # test single character `multiple=true` multiple pronunciations
    @test Hanzi.wadegiles("你好") == [["ni3"], ["hao3"]] # test multiple characters `multiple=false` multiple pronunciations
    @test Hanzi.wadegiles("你好", multiple=true) == [["ni3"], ["hao3", "hao4"]] # test multiple characters `multiple=true` multiple pronunciations
    @test Hanzi.wadegiles("我叫John。你呢？") == [["wo3"], ["chiao4"], ["John。"], ["ni3"], ["ne"], ["？"]] # test multiple characters `multiple=false` multiple pronunciations non-recognized glyphs
    @test Hanzi.wadegiles("我叫John。你呢？", multiple=true) == [["wo3"], ["chiao4"], ["John。"], ["ni3"], ["ne", "ni2", "ni3", "ni1"], ["？"]] # test multiple characters `multiple=true` multiple pronunciations non-recognized glyphs
end
