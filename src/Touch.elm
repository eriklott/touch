module Touch exposing (..)

{-| A useful set of utilities for decoding browser touch events

# Types
@docs Position

# Decoders
@docs position, target, identifier, touches, touch, targetTouches, targetTouch,
    changedTouches, changedTouch, touchList
-}

import Json.Decode as Json


{-| position represents an on-screen position
-}
type alias Position =
    { x : Int
    , y : Int
    }


{-| The decoder used to extract a `Position` from a JavaScript touch event.
-}
position : Json.Decoder Position
position =
    Json.map2 Position
        (Json.field "pageX" Json.int)
        (Json.field "pageY" Json.int)


{-| get the target of the touch event
-}
target : Json.Decoder a -> Json.Decoder a
target =
    Json.field "target"


{-| get the touch identifier
-}
identifier : Json.Decoder Int
identifier =
    Json.field "identifier" Json.int


{-| A list of Touches for every point of contact currently touching the surface.
-}
touches : Json.Decoder a -> Json.Decoder (List a)
touches =
    Json.field "touches" << touchList


{-| Get point of contact currently touching the surface by its identifier
-}
touch : Int -> Json.Decoder a -> Json.Decoder a
touch idx =
    Json.at [ "touches", toString idx ]


{-| A list of Touches for every point of contact that is touching the surface
and started on the element that is the target of the current event
-}
targetTouches : Json.Decoder a -> Json.Decoder (List a)
targetTouches =
    Json.field "touches" << touchList


{-| Get point of contact that is touching the surface and started on the
element that is the target of the current event by its identifier.
-}
targetTouch : Int -> Json.Decoder a -> Json.Decoder a
targetTouch idx =
    Json.at [ "targetTouches", toString idx ]


{-| A list of Touches for every point of contact which contributed to the event.
-}
changedTouches : Json.Decoder a -> Json.Decoder (List a)
changedTouches =
    Json.field "changedTouches" << touchList


{-| Get point of contact which contributed to the event by its identifier.
-}
changedTouch : Int -> Json.Decoder a -> Json.Decoder a
changedTouch idx =
    Json.at [ "changedTouches", toString idx ]


{-| A list of Touches.
-}
touchList : Json.Decoder a -> Json.Decoder (List a)
touchList decoder =
    let
        toTouchKeysLoop num count accum =
            if count < num then
                toTouchKeysLoop num (count + 1) (accum ++ [ toString count ])
            else
                accum

        toTouchKeys num =
            toTouchKeysLoop num 0 []

        decodeTouchValues =
            List.map (\key -> Json.field key decoder)
                >> List.foldr (Json.map2 (\a accum -> a :: accum)) (Json.succeed [])
    in
        Json.field "length" Json.int
            |> Json.map toTouchKeys
            |> Json.andThen decodeTouchValues
