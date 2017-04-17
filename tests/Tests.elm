module Tests exposing (..)

import Test exposing (..)
import Expect


-- import Fuzz exposing (list, int, tuple, string)

import Touch
import Json.Decode as Decode


all : Test
all =
    describe "Touch Test"
        [ describe "identifier"
            [ test "return int" <|
                \() ->
                    Expect.equal (Ok 2) (Decode.decodeString Touch.identifier "{\"identifier\":2}")
            ]
        , describe "target"
            [ test "return targetNode" <|
                \() ->
                    Expect.equal (Ok "mytarget") (Decode.decodeString (Touch.target Decode.string) "{\"target\":\"mytarget\"}")
            ]
        , describe "touchList"
            [ test "returns dict" <|
                \() ->
                    Expect.equal (Ok [ 100 ]) (Decode.decodeString (Touch.touchList <| Decode.field "pageX" Decode.int) "{\"0\":{\"identifier\":0,\"pageX\":100}}")
            ]
        ]
