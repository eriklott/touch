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
        , describe "Touch.touchList"
            [ test "returns dict" <|
                \() ->
                    Expect.equal (Ok [ 100 ]) (Decode.decodeString (Touch.touchList <| Decode.field "pageX" Decode.int) "{\"0\":{\"identifier\":0,\"pageX\":100}}")
            , test "ignores non-touch nodes" <|
                \() ->
                    Expect.equal (Ok [ 100 ]) (Decode.decodeString (Touch.touchList <| Decode.field "pageX" Decode.int) "{\"length\":1,\"0\":{\"identifier\":0,\"pageX\":100,\"pageY\":100}}")
            , test "reports unknown property" <|
                \() ->
                    let
                        result =
                            (Decode.decodeString (Touch.touchList <| Decode.field "badProperty" Decode.int) "{\"length\":1,\"0\":{\"identifier\":0,\"pageX\":100,\"pageY\":100}}")
                    in
                        case result of
                            Ok _ ->
                                Expect.fail "expected unknown property to return error result"

                            Err _ ->
                                Expect.pass
            ]
        ]
