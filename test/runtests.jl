using Test
using Solitaire

@testset "individual moves" begin
    Card = Solitaire.Card
    A = Solitaire.A
    B = Solitaire.B

    @testset "move_A" begin
        @test Solitaire.move_A(Card[A,1,2]) == Card[1,A,2]
        @test Solitaire.move_A(Card[1,A,2]) == Card[1,2,A]
        @test Solitaire.move_A(Card[1,2,A]) == Card[1,A,2]
    end

    @testset "move_B" begin
        @test Solitaire.move_B(Card[B,1,2]) == Card[1,2,B]
        @test Solitaire.move_B(Card[1,B,2]) == Card[1,B,2]
        @test Solitaire.move_B(Card[1,2,B]) == Card[1,2,B]
        @test Solitaire.move_B(Card[1,2,B,3]) == Card[1,B,2,3]
    end

    @testset "cut_AB" begin
        @test Solitaire.cut_AB(Card[A,B]) == Card[A,B]
        @test Solitaire.cut_AB(Card[B,A]) == Card[B,A]
        @test Solitaire.cut_AB(Card[1,A,B]) == Card[A,B,1]
        @test Solitaire.cut_AB(Card[A,1,B]) == Card[A,1,B]
        @test Solitaire.cut_AB(Card[A,B,1]) == Card[1,A,B]
        @test Solitaire.cut_AB(Card[1,2,A,3,4,B,5,6]) == Card[5,6,A,3,4,B,1,2]
        @test Solitaire.cut_AB(Card[1,2,B,3,4,A,5,6]) == Card[5,6,B,3,4,A,1,2]
    end

    @testset "cut_bottom" begin
        @test Solitaire.cut_bottom(Card[4,3,2,1]) == Card[3,2,4,1]
        @test Solitaire.cut_bottom(Card[1,4,3,2]) == Card[3,1,4,2]
        @test Solitaire.cut_bottom(Card[4,1,2,3]) == Card[4,1,2,3]
    end

    @testset "value" begin
        @test Solitaire.value(Card[1, 2, 3]) == 2
        @test Solitaire.value(Card[2, 1, 3]) == 3
        @test Solitaire.value(Card[1, 30, 2]) == 30  # no mod26 yet
        @test Solitaire.value(Card[1, A, 32]) == 53  # no skipping yet
    end

    @testset "cut_given" begin
        @test Solitaire.cut_given(Card[1, 2, 3], 1) == Card[2, 1, 3]
        @test Solitaire.cut_given(Card[1, 2, 3], 2) == Card[1, 2, 3]
        @test Solitaire.cut_given(Card[1, 2, 3, 4], 2) == Card[3, 1, 2, 4]
    end
end

@testset "raw generator output" begin
    # reference output
    ref = [4, 49, 10, 53, 24, 8, 51, 44, 6, 4, 33, 20, 39, 19, 34, 42]
    iter = Solitaire.DeckIterator(Solitaire.sorted_deck())
    for t in zip(ref, iter)
        @test t[1] == t[2]
    end
end

@testset "raw generator output" begin
    # reference output
    ref = [4, 49, 10, 24, 8, 51, 44, 6, 4, 33, 20, 39, 19, 34, 42]
    iter = Solitaire.skip_jokers(Solitaire.DeckIterator(Solitaire.sorted_deck()))
    for t in zip(ref, iter)
        @test t[1] == t[2]
    end
end

@testset "encryption with passphrase" begin
    @test Solitaire.encrypt("AAAAAAAAAAAAAAA", "") == "EXKYIZSGEHUNTIQ"
    @test Solitaire.encrypt("AAAAAAAAAAAAAAA", "f") == "XYIUQBMHKKJBEGY"
    @test Solitaire.encrypt("AAAAAAAAAAAAAAA", "fo") == "TUJYMBERLGXNDIW"
    @test Solitaire.encrypt("AAAAAAAAAAAAAAA", "foo") == "ITHZUJIWGRFARMW"
    @test Solitaire.encrypt("AAAAAAAAAAAAAAA", "a") == "XODALGSCULIQNSC"
    @test Solitaire.encrypt("AAAAAAAAAAAAAAA", "aa") == "OHGWMXXCAIMCIQP"
    @test Solitaire.encrypt("AAAAAAAAAAAAAAA", "aaa") == "DCSQYHBQZNGDRUT"
    @test Solitaire.encrypt("AAAAAAAAAAAAAAA", "b") == "XQEEMOITLZVDSQS"
    @test Solitaire.encrypt("AAAAAAAAAAAAAAA", "bc") == "QNGRKQIHCLGWSCE"
    @test Solitaire.encrypt("AAAAAAAAAAAAAAA", "bcd") == "FMUBYBMAXHNQXCJ"
    @test Solitaire.encrypt("AAAAAAAAAAAAAAAAAAAAAAAAA", "cryptonomicon") == "SUGSRSXSWQRMXOHIPBFPXARYQ"
    @test Solitaire.encrypt("SOLITAIRE", "cryptonomicon") == "KIRAKSFJA"
end

@testset "decryption with passphrase" begin
    @test Solitaire.decrypt("EXKYIZSGEHUNTIQ", "") == "AAAAAAAAAAAAAAA"
    @test Solitaire.decrypt("XYIUQBMHKKJBEGY", "f") == "AAAAAAAAAAAAAAA"
    @test Solitaire.decrypt("TUJYMBERLGXNDIW", "fo") == "AAAAAAAAAAAAAAA"
    @test Solitaire.decrypt("ITHZUJIWGRFARMW", "foo") == "AAAAAAAAAAAAAAA"
    @test Solitaire.decrypt("XODALGSCULIQNSC", "a") == "AAAAAAAAAAAAAAA"
    @test Solitaire.decrypt("OHGWMXXCAIMCIQP", "aa") == "AAAAAAAAAAAAAAA"
    @test Solitaire.decrypt("DCSQYHBQZNGDRUT", "aaa") == "AAAAAAAAAAAAAAA"
    @test Solitaire.decrypt("XQEEMOITLZVDSQS", "b") == "AAAAAAAAAAAAAAA"
    @test Solitaire.decrypt("QNGRKQIHCLGWSCE", "bc") == "AAAAAAAAAAAAAAA"
    @test Solitaire.decrypt("FMUBYBMAXHNQXCJ", "bcd") == "AAAAAAAAAAAAAAA"
    @test Solitaire.decrypt("SUGSRSXSWQRMXOHIPBFPXARYQ", "cryptonomicon") == "AAAAAAAAAAAAAAAAAAAAAAAAA"
    @test Solitaire.decrypt("KIRAKSFJA", "cryptonomicon") == "SOLITAIRE"
end
