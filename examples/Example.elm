module Example exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode
import Touch
import Debug
import String


type alias Model =
    { msg : String }


type Msg
    = TouchStart (List Touch.Position)


update : Msg -> Model -> Model
update msg model =
    case Debug.log "msg" msg of
        TouchStart pos ->
            { model | msg = pos |> List.head |> Maybe.withDefault (Touch.Position 0 0) |> (\pos -> "x:" ++ toString pos.x ++ "   y:" ++ toString pos.y) }


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text model.msg ]
        , button [ on "touchstart" (Decode.map TouchStart (Touch.touches Touch.position)) ] [ text "click me" ]
        ]


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = { msg = "" }
        , update = update
        , view = view
        }
