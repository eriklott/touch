module Touch exposing (..)

{-| A useful set of utilities for decoding browser touch events

# Types
@docs Position

# Decoders
@docs position, target, identifier, touches, touch, targetTouches, targetTouch,
    changedTouches, changedTouch, touchList
-}

import Json.Decode as Decode
import Dict exposing (Dict)


{-| position represents an on-screen position
-}
type alias Position =
    { x : Int
    , y : Int
    }


{-| The decoder used to extract a `Position` from a JavaScript touch event.
-}
position : Decode.Decoder Position
position =
    Decode.map2 Position
        (Decode.field "pageX" Decode.int)
        (Decode.field "pageY" Decode.int)


{-| get the target of the touch event
-}
target : Decode.Decoder a -> Decode.Decoder a
target =
    Decode.field "target"


{-| get the touch identifier
-}
identifier : Decode.Decoder Int
identifier =
    Decode.field "identifier" Decode.int


{-| A list of Touches for every point of contact currently touching the surface.
-}
touches : Decode.Decoder a -> Decode.Decoder (List a)
touches =
    Decode.field "touches" << touchList


{-| Get point of contact currently touching the surface by its identifier
-}
touch : Int -> Decode.Decoder a -> Decode.Decoder a
touch idx =
    Decode.at [ "touches", toString idx ]


{-| A list of Touches for every point of contact that is touching the surface
and started on the element that is the target of the current event
-}
targetTouches : Decode.Decoder a -> Decode.Decoder (List a)
targetTouches =
    Decode.field "touches" << touchList


{-| Get point of contact that is touching the surface and started on the
element that is the target of the current event by its identifier.
-}
targetTouch : Int -> Decode.Decoder a -> Decode.Decoder a
targetTouch idx =
    Decode.at [ "targetTouches", toString idx ]


{-| A list of Touches for every point of contact which contributed to the event.
-}
changedTouches : Decode.Decoder a -> Decode.Decoder (List a)
changedTouches =
    Decode.field "changedTouches" << touchList


{-| Get point of contact which contributed to the event by its identifier.
-}
changedTouch : Int -> Decode.Decoder a -> Decode.Decoder a
changedTouch idx =
    Decode.at [ "changedTouches", toString idx ]


{-| A list of Touches.
-}
touchList : Decode.Decoder a -> Decode.Decoder (List a)
touchList decoder =
    Decode.map2 (,) (Decode.maybe identifier) decoder
        |> Decode.dict
        |> Decode.map Dict.values
        |> Decode.map (List.filterMap (\( k, v ) -> Maybe.map (\_ -> v) k))
