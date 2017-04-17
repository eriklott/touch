module Example exposing (..)

import Html exposing (..)


type alias Model =
    {}


type Msg
    = Msg


update : msg -> model -> model
update msg model =
    model


view : model -> Html msg
view model =
    text ""


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = {}
        , update = update
        , view = view
        }
